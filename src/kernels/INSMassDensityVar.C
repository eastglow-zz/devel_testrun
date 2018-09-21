//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "INSMassDensityVar.h"

registerMooseObject("NavierStokesApp", INSMassDensityVar);

template <>
InputParameters
validParams<INSMassDensityVar>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the density variation part of the pressure equation calculated by INSMass kernel");
  params.addRequiredCoupledVar("u", "x-velocity");
  params.addCoupledVar("v", 0, "y-velocity"); // only required in 2D and 3D
  params.addCoupledVar("w", 0, "z-velocity"); // only required in 3D
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addParam<MaterialPropertyName>("density_name","rho","mass density as a function of variable, which can be provided by DerivativeParsedMaterial with derivative_order 2");
  params.addCoupledVar("coupled_vars", "Names of the coupled variables");
  return params;
}

INSMassDensityVar::INSMassDensityVar(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  // _nvar(_coupled_moose_vars.size()),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _L(getParam<Real>("prefactor")),
  _jvar2cvar(_nvar),
  _jvar2velvar(_nvar),
  _cvars(coupledComponents("coupled_vars")),
  _rho(getMaterialProperty<Real>("density_name")),
  _drho_dcvars(coupledComponents("coupled_vars")),
  _d2rho_dcvars2(coupledComponents("coupled_vars")),
  _cdots(coupledComponents("coupled_vars")),
  _cgrads(coupledComponents("coupled_vars")),
  _cdots_du(coupledComponents("coupled_vars")),
  _u_vel_var_number(coupled("u")),
  _v_vel_var_number(coupled("v")),
  _w_vel_var_number(coupled("w")),
  _u_vel(coupledValue("u")),  // will be provided by GlobalParams in input file
  _v_vel(coupledValue("v")),  // will be provided by GlobalParams in input file
  _w_vel(coupledValue("w"))  // will be provided by GlobalParams in input file
{
  // printf("_nvar = %d\n",_nvar);
  /// Get derivative data:
  /// _drho_dcvars
  for (unsigned int i = 0; i < _drho_dcvars.size(); ++i)
  {
    const VariableName iname = getVar("coupled_vars", i)->name();
    if (iname == _var.name())
      paramError("coupled_vars entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    /// The 1st derivatives
    _drho_dcvars[i] = &getMaterialPropertyDerivative<Real>("density_name", iname);

    /// The 2nd derivatives
    _d2rho_dcvars2[i].resize(_drho_dcvars.size());
    for (unsigned int j = 0; j < _drho_dcvars.size(); ++j)
    {
      const VariableName jname = getVar("coupled_vars", i)->name();
      if (jname == _var.name())
        paramError("coupled_vars entry error",\
                   "The kernel variable should not be specified in the the coupled parameter.");
      _d2rho_dcvars2[i][j] = &getMaterialPropertyDerivative<Real>("density_name", iname, jname);
    }

    /// Loading time derivatives and gradients of the coupled variables
    _cdots[i] = &coupledDot("coupled_vars", i);
    _cgrads[i] = &coupledGradient("coupled_vars", i);
    _cdots_du[i] = &coupledDotDu("coupled_vars", i);
  }

  /// initializing the jvar2cvar[]
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    _jvar2cvar[i] = _nvar+1;
    _jvar2velvar[i] = _nvar+1;
  }

  /// Mapping jvar and index for coupled_vars
  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    _cvars[i] = coupled("coupled_vars", i);
    _jvar2cvar[_cvars[i]] = i;
    // printf("!!! Kernel:INSMassDensityVar: _jvar2cvar[%d] = %d \n", i, _jvar2cvar[i]);
  }
  _jvar2velvar[_u_vel_var_number] = 0;
  if (_mesh.dimension() >= 2) _jvar2velvar[_v_vel_var_number] = 1;
  if (_mesh.dimension() >= 3) _jvar2velvar[_w_vel_var_number] = 2;

  // for (unsigned int i = 0; i < _nvar; ++i)
  // {
  //   printf("!!! Kernel:INSMassDensityVar: i = %d, _jvar2cvar[i] = %d, _jvar2velvar[i] = %d \n", i, _jvar2cvar[i], _jvar2velvar[i]);
  // }
}

void
INSMassDensityVar::initialSetup()
{
  validateCoupling<Real>("density_name");
  validateCoupling<Real>("coupled_vars");
  validateCoupling<Real>("u");
  validateCoupling<Real>("v");
  validateCoupling<Real>("w");
}

Real
INSMassDensityVar::computeQpResidual()
{
  Real returnval = 0;
  RealVectorValue U(_u_vel[_qp], _v_vel[_qp], _w_vel[_qp]);
  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    returnval += (*_drho_dcvars[i])[_qp] * ((*_cdots[i])[_qp] + (*_cgrads[i])[_qp] * U);
  }
  return -_L * returnval * _test[_i][_qp] / _rho[_qp]; // Negative sign has been attached to be consistent with INSMass kernel
}

Real
INSMassDensityVar::computeQpJacobian()
{
  return 0;
}

Real
INSMassDensityVar::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real returnval = 0.0;
  unsigned int jc = _jvar2cvar[jvar];
  unsigned int jv = _jvar2velvar[jvar];
  //printf("INSMassDensityVar::computeQpOffDiagJacobian; jvar = %d, jc = %d, jv = %d\n",jvar, jc, jv);
  if (jc < _nvar)
  // if (0)
  {
    Real terms_cvars = 0.0;
    Real term_with_phi = 0.0;
    Real term_with_gradphi = 0.0;
    RealVectorValue U(_u_vel[_qp], _v_vel[_qp], _w_vel[_qp]);

    if (jc > _cvars.size())
    {
      printf("INSMassDensityVar::computeQpOffDiagJacobian; jc = %d, _cvars.size() = %lu\n",jc, _cvars.size());
      mooseError("INSMassDensityVar::computeQpOffDiagJacobian; Check _jvar2cvar[]. jc > _cvars.size()");
    }

    for (unsigned int i = 0; i < _cvars.size(); ++i)
    {
      term_with_phi += ((*_drho_dcvars[i])[_qp] * (*_drho_dcvars[jc])[_qp] / _rho[_qp] -  (*_d2rho_dcvars2[i][jc])[_qp]) * ((*_cdots[i])[_qp] + (*_cgrads[i])[_qp] * U);
    }
    term_with_phi *= -_phi[_j][_qp] /_rho[_qp] ;

    term_with_gradphi = (*_drho_dcvars[jc])[_qp] * ((*_cdots_du[jc])[_qp] + _grad_phi[_j][_qp] * U)/_rho[_qp];
    terms_cvars = _L * (term_with_phi + term_with_gradphi) * _test[_j][_qp];

    returnval = -terms_cvars;  // Negative sign has been attached to be consistent with INSMass kernel
  }
  if (jv < _nvar)
  {
    Real terms_vels = 0;

    if (jv > _mesh.dimension()-1)
    {
      printf("INSMassDensityVar::computeQpOffDiagJacobian; jv = %d, _cvars.size() = %u\n",jv, _mesh.dimension()-1);
      mooseError("INSMassDensityVar::computeQpOffDiagJacobian; Check _jvar2velvar[]. jv > _mesh.dimension()-1");
    }
    for (unsigned int i = 0; i < _cvars.size(); ++i)
    {
      terms_vels += _L /_rho[_qp] * (*_drho_dcvars[i])[_qp] * (*_cgrads[i])[_qp](jv) * _phi[_j][_qp] * _test[_i][_qp];
    }
    returnval = -terms_vels; // Negative sign has been attached to be consistent with INSMass kernel
  }
  return returnval;
}
