//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "dFdGradVarDevel.h"

registerMooseObject("PhaseFieldApp", dFdGradVarDevel);

template <>
InputParameters
validParams<dFdGradVarDevel>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates a general form of dF(grad_var)/dvar = -div((d/dgrad_var) (f(grad_var))");
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addParam<MaterialPropertyName>("fgrad_name","Fgrad","free energy density function in terms of gradient components of the variable, which can be provided by DerivativeParsedMaterial with derivative_order 2");
  params.addCoupledVar("gradient_component_names","Name vector of gradient components of the variable, in x y z order, e.g.) in 2D, dpx dpy, in 3D, dpx dpy dpz, where dpx, dpy, and dpz are defined as AuxVariables(FIRST order, MONOMIAL family) and calculated by VariableGradientComponent AuxKernel (execute_on = LINEAR)");
  //params.addParam<Real>("gradmag_threshold",1e-7,"Threshold value to turn on anisotropy term calculations; grad_mag > thres ? anisotropic calc. : isotropic calc.");
  return params;
}

dFdGradVarDevel::dFdGradVarDevel(const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
  _nvar(_coupled_moose_vars.size()),
  _L(getParam<Real>("prefactor")),
  _fgrad(getMaterialProperty<Real>("fgrad_name")),
  //_gradmag_threshold(getParam<Real>("gradmag_threshold")),
  _dfgrad_darg(_nvar),
  _d2fgrad_darg2(_nvar)
{
  /// Get derivative data
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    MooseVariable * ivar = _coupled_standard_moose_vars[i];
    const VariableName iname = ivar->name();
    if (iname == _var.name())
      paramError("gradient_component_names",\
                 "The kernel variable should not be specified in the coupled `gradient_component_names` parameter.");

    /// The 1st derivatives
    _dfgrad_darg[i] = &getMaterialPropertyDerivative<Real>("fgrad_name", iname);

    /// The 2nd derivatives
    _d2fgrad_darg2[i].resize(_nvar);
    for (unsigned int j = 0; j < _nvar; ++j)
    {
      const VariableName jname = _coupled_moose_vars[j]->name();
      if (jname == _var.name())
        paramError("gradient_component_names",\
                   "The kernel variable should not be specified in the coupled `gradient_component_names` parameter.");
      _d2fgrad_darg2[i][j] = &getMaterialPropertyDerivative<Real>("fgrad_name", iname, jname);
    }
  }
}

void
dFdGradVarDevel::initialSetup()
{
  validateCoupling<Real>("fgrad_name");
}

RealGradient
dFdGradVarDevel::get_dfgrad_darg(unsigned int qp) // This function must be called in computeQp* functions
{
  RealGradient v0(0.0, 0.0, 0.0);
  switch (_nvar) {
    case 1:
      {
        RealGradient v1((*_dfgrad_darg[0])[qp], 0.0, 0.0);
        return v1;
      }
      break;
    case 2:
      {
        RealGradient v2((*_dfgrad_darg[0])[qp], (*_dfgrad_darg[1])[qp], 0.0);
        return v2;
      }
      break;
    case 3:
      {
        RealGradient v3((*_dfgrad_darg[0])[qp], (*_dfgrad_darg[1])[qp], (*_dfgrad_darg[2])[qp]);
        return v3;
      }
      break;
    default:
      return v0;
  }
}

RealGradient
dFdGradVarDevel::get_d2fgrad_darg2(unsigned int i, unsigned int qp)  // This function must be called in computeQp* functions
{
  RealGradient v0(0.0, 0.0, 0.0);
  switch (_nvar) {
    case 1:
      {
        RealGradient v1((*_d2fgrad_darg2[i][0])[qp], 0.0, 0.0);
        return v1;
      }
      break;
    case 2:
      {
        RealGradient v2((*_d2fgrad_darg2[i][0])[qp], (*_d2fgrad_darg2[i][1])[qp], 0.0);
        return v2;
        break;
      }
      break;
    case 3:
      {
        RealGradient v3((*_d2fgrad_darg2[i][0])[qp], (*_d2fgrad_darg2[i][1])[qp], (*_d2fgrad_darg2[i][2])[qp]);
        return v3;
      }
      break;
    default:
      return v0;
  }
}

Real
dFdGradVarDevel::computeQpResidual()
{
  if (_nvar > 0)
  {
    RealGradient dfgrad_dgradvar = get_dfgrad_darg(_qp);
    Real dfgrad_dgradvar_dot_grad_test = dfgrad_dgradvar * _grad_test[_i][_qp];
    return _L * dfgrad_dgradvar_dot_grad_test;
  }else{
    return 0;
  }
}

Real
dFdGradVarDevel::computeQpJacobian()
{
  if (_nvar > 0)
  {
    Real d2fgrad_dgradvar2_dot_grad_phi_dot_grad_test = 0.0;
    for (unsigned int i = 0; i < _nvar; ++i)
    {
      for (unsigned int j = 0; j < _nvar; ++j)
      {
        d2fgrad_dgradvar2_dot_grad_phi_dot_grad_test += \
          _grad_test[_i][_qp](i) * (*_d2fgrad_darg2[i][j])[_qp] * _grad_phi[_j][_qp](j);
      }
    }
    return d2fgrad_dgradvar2_dot_grad_phi_dot_grad_test;
  }else{
    return 0;
  }
}


Real
dFdGradVarDevel::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_nvar > 0)
  {
    // get the coupled variable jvar is referring to
    const unsigned int cvar = mapJvarToCvar(jvar);
    Real d2fgrad_dgradcvar_dcvar_dot_grad_test = get_d2fgrad_darg2(cvar, _qp) * _grad_test[_i][_qp];

    return _L * _phi[_j][_qp] * (d2fgrad_dgradcvar_dcvar_dot_grad_test);
  }else{
    return 0;
  }
}
