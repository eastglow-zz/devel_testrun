//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "FwdSplitCH1.h"

registerMooseObject("PhaseFieldApp", FwdSplitCH1);

template <>
InputParameters
validParams<FwdSplitCH1>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates a general form of div(M(var, gradvar)grad(mu))");
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addParam<MaterialPropertyName>("mob_name","M","Mobility as a function of variable and gradient of variable, which can be provided by DerivativeParsedMaterial with derivative_order 2");
  params.addRequiredCoupledVar("mu_name", "Chemical potential field name");
  params.addCoupledVar("coupled_vars", "Names of the coupled variables");
  //params.addParam<Real>("gradmag_threshold",1e-7,"Threshold value to turn on anisotropy term calculations; grad_mag > thres ? anisotropic calc. : isotropic calc.");
  return params;
}

FwdSplitCH1::FwdSplitCH1(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _v_var(coupled("mu_name")),
  _mu(coupledValue("mu_name")),
  _grad_mu(coupledGradient("mu_name")),
  _jvar2cvar(_nvar+1),
  _cvars(coupledComponents("coupled_vars")),
  _L(getParam<Real>("prefactor")),
  _M(getMaterialProperty<Real>("mob_name")),
  _dM_dcvars(coupledComponents("coupled_vars"))
  // _d2M_dgradvar2(_nvar)
{
  //printf("!!! Kernel:FwdSplitCH: _nvar = %d \n", _nvar);
  //printf("!!! Kernel:FwdSplitCH: _gradvars.size() = %lu \n", _jvar2cvar.size());
  // printf("!!! Kernel:FwdSplitCH: _cvars.size() = %lu \n", _cvars.size());
  // printf("!!! Kernel:FwdSplitCH: _gradcvars.size() = %lu \n", _gradcvars.size());

  /// Get derivative data:

  /// _dM_dcvars
  for (unsigned int i = 0; i < _dM_dcvars.size(); ++i)
  {
    const VariableName iname = getVar("coupled_vars", i)->name();
    if (iname == _var.name())
      paramError("coupled_vars entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    /// The 1st derivatives
    _dM_dcvars[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
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
    //printf("!!! Kernel:FwdSplitCH: _cvars[%d] = %d\n", i, _cvars[i]);
    printf("!!! Kernel:FwdSplitCH: _cvars[%d] = %d, _jvar2cvar[%d] = %d \n", i, _cvars[i], _cvars[i], _jvar2cvar[_cvars[i]]);
  }
}

void
FwdSplitCH1::initialSetup()
{
  validateCoupling<Real>("mu_name");
  validateCoupling<Real>("coupled_vars");
}

Real
FwdSplitCH1::computeQpResidual()
{
  return _L * _M[_qp] * _grad_mu[_qp] * _grad_test[_i][_qp];
}

Real
FwdSplitCH1::computeQpJacobian()
{
  return 0;
}

Real
FwdSplitCH1::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real returnval = 0.0;
  // printf("!!! Kernel:FwdSplitCH:Jod: jvar = %d\n", jvar);
  if (jvar == _v_var)  // mu_name-related term
  {
    // printf("!!! Kernel:FwdSplitCH:Jod:_mu_term: _v_var = %d\n", _v_var);
    returnval = _L * _M[_qp] * (_grad_phi[_j][_qp] * _grad_test[_i][_qp]);
  }else if (_jvar2cvar[jvar] < _nvar){
    returnval = _L * ((*_dM_dcvars[_jvar2cvar[jvar]])[_qp] * _phi[_j][_qp]) * (_grad_mu[_qp] * _grad_test[_i][_qp]);
  }else{
    returnval = 0.0;
  }
  return returnval;
}
