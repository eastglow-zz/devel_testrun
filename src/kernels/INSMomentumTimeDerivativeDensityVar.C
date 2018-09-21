//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "INSMomentumTimeDerivativeDensityVar.h"

registerMooseObject("NavierStokesApp", INSMomentumTimeDerivativeDensityVar);

template <>
InputParameters
validParams<INSMomentumTimeDerivativeDensityVar>()
{
  InputParameters params = validParams<TimeKernel>();
  params.addClassDescription("Momentum time derivative term with variable density coupled with field variables");
  params.addParam<MaterialPropertyName>("density_name","rho","Orientation dependent anisotropy function in terms of gradient components of aeta, which can be provided by DerivativeParsedMaterial with derivative_order 2");
  params.addCoupledVar("coupled_vars", "Name vector of gradient components of aeta, arguments of the tau function, in x y z order, e.g.) in 2D, dpx dpy, in 3D, dpx dpy dpz, where dpx, dpy, and dpz are defined as AuxVariables(FIRST order, MONOMIAL family) and calculated by VariableGradientComponent AuxKernel (execute_on = LINEAR)");
  params.addParam<bool>("lumping", false, "True for mass matrix lumping, false otherwise");
  return params;
}

INSMomentumTimeDerivativeDensityVar::INSMomentumTimeDerivativeDensityVar(const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<TimeKernel>>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _jvar2cvar(_nvar),
  _rho(getMaterialProperty<Real>("density_name")),
  _drho_dcvars(coupledComponents("coupled_vars"))
{
  /// Get derivative data
  for (unsigned int i = 0; i < _drho_dcvars.size(); ++i)
  {
    const VariableName iname= getVar("coupled_vars", i)->name();
    if (iname == _var.name())
      paramError("coupled_vars",\
                 "The kernel variable should not be specified in the coupled `coupled_vars` parameter.");

    /// The 1st derivatives
    _drho_dcvars[i] = &getMaterialPropertyDerivative<Real>("density_name", iname);
  }

  /// initializing the jvar2cvar[]
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    _jvar2cvar[i] = _nvar+1;
  }
  /// Mapping jvar and index for coupled_vars
  for (unsigned int i = 0; i < _drho_dcvars.size(); ++i)
  {
    unsigned int cvars = coupled("coupled_vars", i);
    _jvar2cvar[cvars] = i;
  }

  for (unsigned int i = 0; i < _nvar; ++i)
  {
    printf("!!! Kernel:INSMomentumDensityVar: i = %d, _jvar2cvar[i] = %d\n", i, _jvar2cvar[i]);
  }

}

void
INSMomentumTimeDerivativeDensityVar::initialSetup()
{
  validateCoupling<Real>("density_name");
}

Real
INSMomentumTimeDerivativeDensityVar::computeQpResidual()
{
  return _test[_i][_qp] * _u_dot[_qp] * _rho[_qp];
}

Real
INSMomentumTimeDerivativeDensityVar::computeQpJacobian()
{
  return (_du_dot_du[_qp] * _rho[_qp]) * _test[_i][_qp];
}

Real
INSMomentumTimeDerivativeDensityVar::computeQpOffDiagJacobian(unsigned int jvar)
{
  unsigned int jc = _jvar2cvar[jvar];
  if (jc < _nvar)
  {
    return _test[_i][_qp] * _u_dot[_qp] * (*_drho_dcvars[jc])[_qp] * _phi[_j][_qp];
  }else{
    return 0;
  }
}

void
INSMomentumTimeDerivativeDensityVar::computeJacobian()
{
  if (_lumping)
  {
    DenseMatrix<Number> & ke = _assembly.jacobianBlock(_var.number(), _var.number());

    for (_i = 0; _i < _test.size(); _i++)
      for (_j = 0; _j < _phi.size(); _j++)
        for (_qp = 0; _qp < _qrule->n_points(); _qp++)
          ke(_i, _i) += _JxW[_qp] * _coord[_qp] * computeQpJacobian();
  }
  else
    TimeKernel::computeJacobian();
}
