//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "FwdSplitCH.h"

registerMooseObject("PhaseFieldApp", FwdSplitCH);

template <>
InputParameters
validParams<FwdSplitCH>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates a general form of div(M(var, gradvar)grad(mu))");
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addParam<MaterialPropertyName>("mob_name","M","Mobility as a function of variable and gradient of variable, which can be provided by DerivativeParsedMaterial with derivative_order 2");
  params.addRequiredCoupledVar("mu_name", "Chemical potential field name");
  params.addCoupledVar("var_grad_components","Name of gradient components of the variable, in x y z order, e.g.) in 2D, dpx dpy, in 3D, dpx dpy dpz, where dpx, dpy, and dpz are defined as AuxVariables(FIRST order, MONOMIAL family) and calculated by VariableGradientComponent AuxKernel (execute_on = LINEAR)");
  params.addCoupledVar("coupled_vars", "Names of the coupled variables");
  params.addCoupledVar("coupled_var_grad_components","Namesgradient components of the coupled variablesl; Please keep the order corresponding to the coupled variable list.");
  //params.addParam<Real>("gradmag_threshold",1e-7,"Threshold value to turn on anisotropy term calculations; grad_mag > thres ? anisotropic calc. : isotropic calc.");
  return params;
}

FwdSplitCH::FwdSplitCH(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _v_var(coupled("mu_name")),
  _mu(coupledValue("mu_name")),
  _grad_mu(coupledGradient("mu_name")),
  _gradvars(coupledComponents("var_grad_components")),
  _cvars(coupledComponents("coupled_vars")),
  _gradcvars(coupledComponents("coupled_var_grad_components")),
  _L(getParam<Real>("prefactor")),
  _M(getMaterialProperty<Real>("mob_name")),
  _dM_dvar(getMaterialPropertyDerivative<Real>("mob_name", _var.name())),
  _dM_dgradvar(coupledComponents("var_grad_components")),
  _dM_dcvars(coupledComponents("coupled_vars")),
  _dM_dgradcvars(coupledComponents("coupled_var_grad_components"))
  // _d2M_dgradvar2(_nvar)
{
  // printf("!!! Kernel:FwdSplitCH: _nvar = %d \n", _nvar);
  // printf("!!! Kernel:FwdSplitCH: _gradvars.size() = %lu \n", _gradvars.size());
  // printf("!!! Kernel:FwdSplitCH: _cvars.size() = %lu \n", _cvars.size());
  // printf("!!! Kernel:FwdSplitCH: _gradcvars.size() = %lu \n", _gradcvars.size());

  /// Get derivative data:
  /// _dM_dgradvar
  for (unsigned int i = 0; i < _dM_dgradvar.size(); ++i)
  {
    const VariableName iname = getVar("var_grad_components", i)->name();
    if (iname == _var.name())
      paramError("var_grad_components entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    /// The 1st derivatives
    _dM_dgradvar[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
  }

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

  /// _dM_dgradcvars
  for (unsigned int i = 0; i < _dM_dgradcvars.size(); ++i)
  {
    const VariableName iname = getVar("coupled_var_grad_components", i)->name();
    if (iname == _var.name())
      paramError("coupled_var_grad_components entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    /// The 1st derivatives
    _dM_dgradcvars[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
  }

  /// Getting variable positions
  for (unsigned int i = 0; i < _gradvars.size(); ++i)
  {
    _gradvars[i] = coupled("var_grad_components", i);
    // printf("!!! Kernel:FwdSplitCH: _gradvars[%d] = %d \n", i, _gradvars[i]);
    // _cvarclass[_gradvars[i]] = 1;
    /// Idendifying axis indices of the gradient components
    // _iaxis[_gradvars[i]] = i % _mesh.dimension();
  }
  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    _cvars[i] = coupled("coupled_vars", i);
    // _cvarclass[_cvars[i]] = 2;
  }
  for (unsigned int i = 0; i < _gradcvars.size(); ++i)
  {
    _gradcvars[i] = coupled("coupled_var_grad_components", i);
    // _cvarclass[_cgradvars[i]] = 3;
    /// Idendifying axis indices of the gradient components
    // _iaxis[_cgradvars[i]] = i % _mesh.dimension();
  }
  // for (unsigned int i = 0; i < _cvars.size(); ++i)
  // {
  //   printf("!!! Kernel:FwdSplitCH: _cvars[%d] = %d \n", i, _cvars[i]);
  //   // _cvarclass[_cvars[i]] = 2;
  // }
  // for (unsigned int i = 0; i < _gradcvars.size(); ++i)
  // {
  //   printf("!!! Kernel:FwdSplitCH: _cgradvars[%d] = %d \n", i, _gradcvars[i]);
  //   // _cvarclass[_cgradvars[i]] = 3;
  //   /// Idendifying axis indices of the gradient components
  //   // _iaxis[_cgradvars[i]] = i % _mesh.dimension();
  // }
}

void
FwdSplitCH::initialSetup()
{
  validateCoupling<Real>("mu_name");
  validateCoupling<Real>("var_grad_components");
  validateCoupling<Real>("coupled_vars");
  validateCoupling<Real>("coupled_var_grad_components");
}

RealGradient
FwdSplitCH::get_dM_dgradvar() // This function must be called in computeQp* functions
{
  RealGradient v0(0.0, 0.0, 0.0);
  switch (_mesh.dimension()) {
    case 1:
      {
        RealGradient v1((*_dM_dgradvar[0])[_qp], 0.0, 0.0);
        return v1;
      }
      break;
    case 2:
      {
        RealGradient v2((*_dM_dgradvar[0])[_qp], (*_dM_dgradvar[1])[_qp], 0.0);
        return v2;
      }
      break;
    case 3:
      {
        RealGradient v3((*_dM_dgradvar[0])[_qp], (*_dM_dgradvar[1])[_qp], (*_dM_dgradvar[2])[_qp]);
        return v3;
      }
      break;
    default:
      return v0;
  }
}

RealGradient
FwdSplitCH::get_dM_dgradcvar(unsigned int icvar) // This function must be called in computeQp* functions
{
  /// icvar: position in coupled_vars
  /// ix: position of x component of the coupled_var_grad_components
  unsigned int ix = icvar * _mesh.dimension();
  RealGradient v0(0.0, 0.0, 0.0);
  switch (_mesh.dimension()) {
    case 1:
      {
        RealGradient v1((*_dM_dgradcvars[ix+0])[_qp], 0.0, 0.0);
        return v1;
      }
      break;
    case 2:
      {
        RealGradient v2((*_dM_dgradcvars[ix+0])[_qp], (*_dM_dgradcvars[ix+1])[_qp], 0.0);
        return v2;
      }
      break;
    case 3:
      {
        RealGradient v3((*_dM_dgradcvars[ix+0])[_qp], (*_dM_dgradcvars[ix+1])[_qp], (*_dM_dgradcvars[ix+2])[_qp]);
        return v3;
      }
      break;
    default:
      return v0;
  }
}

Real
FwdSplitCH::computeQpResidual()
{
  return _L * _M[_qp] * _grad_mu[_qp] * _grad_test[_i][_qp];
}

Real
FwdSplitCH::computeQpJacobian()
{
  if ( _dM_dgradvar.size() > 0 )
  {
    return _L * (_dM_dvar[_qp] * _phi[_j][_qp] + get_dM_dgradvar() * _grad_phi[_j][_qp]) * (_grad_mu[_qp] * _grad_test[_i][_qp]);
  }else{
    return _L * (_dM_dvar[_qp] * _phi[_j][_qp]) * (_grad_mu[_qp] * _grad_test[_i][_qp]);
  }
}


Real
FwdSplitCH::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real returnval = 0.0;
  // printf("!!! Kernel:FwdSplitCH:Jod: jvar = %d\n", jvar);
  if (jvar == _v_var)  // mu_name-related term
  {
    // printf("!!! Kernel:FwdSplitCH:Jod:_mu_term: _v_var = %d\n", _v_var);
    returnval = _L * _M[_qp] * (_grad_phi[_j][_qp] * _grad_test[_i][_qp]);
  }else{
    returnval = 0.0;
  }

  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    if (jvar == _cvars[i])
    {
      // printf("!!! Kernel:FwdSplitCH:Jod: jvar = %d, _cvars[%d] = %d\n", jvar, i, _cvars[i]);
      returnval = _L * ((*_dM_dcvars[i])[_qp] * _phi[_j][_qp]) * (_grad_mu[_qp] * _grad_test[_i][_qp]);
    }else{
      returnval = 0.0;
    }
  }

  for (unsigned int i = 0; i < _gradcvars.size(); ++i)
  {
    unsigned int icomp = i % _mesh.dimension();
    if (jvar == _gradcvars[i])
    {
      // printf("!!! Kernel:FwdSplitCH:Jod: jvar = %d, _gradcvars[%d] = %d, icomp = %d\n", jvar, i, _gradcvars[i], icomp);
      returnval = _L * ((*_dM_dgradcvars[i])[_qp] * _grad_phi[_j][_qp](icomp)) * (_grad_mu[_qp] * _grad_test[_i][_qp]);
    }else{
      returnval = 0.0;
    }
  }

  return returnval;
}
