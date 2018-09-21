//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "INSMomentumTractionFormDensityVar.h"

registerMooseObject("NavierStokesApp", INSMomentumTractionFormDensityVar);

template <>
InputParameters
validParams<INSMomentumTractionFormDensityVar>()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("This class computes density variation term"
                             "contributions for the 'traction' form of the governing equations.");
  params.addRequiredCoupledVar("u", "x-velocity");
  params.addCoupledVar("v", 0, "y-velocity"); // only required in 2D and 3D
  params.addCoupledVar("w", 0, "z-velocity"); // only required in 3D
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addParam<MaterialPropertyName>("density_name","rho","Density as a function of the coupled variable, which can be provided by DerivativeParsedMaterial with derivative_order 1");
  params.addCoupledVar("coupled_vars", "Names of the coupled variables");
  params.addParam<MooseEnum>("component", component, "The velocity component to compute");
  return params;
}

INSMomentumTractionFormDensityVar::INSMomentumTractionFormDensityVar(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _L(getParam<Real>("prefactor")),
  _jvar2cvar(_nvar+1),
  _cvars(coupledComponents("coupled_vars")),
  _rho(getMaterialProperty<Real>("density_name")),
  _drho_dcvars(coupledComponents("coupled_vars")),
  _u_vel(coupledValue("u")),  // will be provided by GlobalParams in input file
  _v_vel(coupledValue("v")),  // will be provided by GlobalParams in input file
  _w_vel(coupledValue("w")),  // will be provided by GlobalParams in input file
  _grad_u_vel(coupledGradient("u")),
  _grad_v_vel(coupledGradient("v")),
  _grad_w_vel(coupledGradient("w")),
  _component(getParam<MooseEnum>("component"))
{
  /// _drho_dcvars
  for (unsigned int i = 0; i < _drho_dcvars.size(); ++i)
  {
    const VariableName iname = getVar("coupled_vars", i)->name();
    if (iname == _var.name())
      paramError("coupled_vars entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    /// The 1st derivatives
    _drho_dcvars[i] = &getMaterialPropertyDerivative<Real>("density_name", iname);
  }

  /// initializing the jvar2cvar[]
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    _jvar2cvar[i] = _nvar+1;
  }

  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    _cvars[i] = coupled("coupled_vars", i);
    _jvar2cvar[_cvars[i]] = i;
  }

}

Real
INSMomentumTractionFormDensityVar::div_u(unsigned int dim)
{
  Real returnval = _grad_u_vel[_qp](0);
  switch (dim)
  {
    case 3:
      returnval += _grad_v_vel[_qp](1);
      returnval += _grad_w_vel[_qp](2);
      break;
    case 2:
      returnval += _grad_v_vel[_qp](1);
      break;
    case 1:
      break;
    default:
      paramError("INSMomentumTractionFormDensityVar::div_u()","dim is out of range");
      break;
  }
  return returnval;
}

void
INSMomentumTractionFormDensityVar::initialSetup()
{
  validateCoupling<Real>("density_name");
  validateCoupling<Real>("coupled_vars");
}

Real
INSMomentumTractionFormDensityVar::computeQpResidual()
{
  return -_L * _u[_qp] * _rho[_qp] * div_u(_mesh.dimension()) * _test[_i][_qp];
}

Real
INSMomentumTractionFormDensityVar::computeQpJacobian()
{
  Real returnval = _phi[_j][_qp] * div_u(_mesh.dimension());
  returnval += _u[_qp] * _grad_phi[_j][_qp](_component);
  return -_L * _rho[_qp] * returnval * _test[_i][_qp];
}

Real
INSMomentumTractionFormDensityVar::computeQpOffDiagJacobian(unsigned int jvar)
{
  unsigned int j = _jvar2cvar[jvar];
  if (j < _nvar)
  {
    return -_L * _u[_qp] * (*_drho_dcvars[_jvar2cvar[jvar]])[_qp] * _phi[_j][_qp] * div_u(_mesh.dimension()) * _test[_i][_qp];
  }else{
    return 0;
  }

}
