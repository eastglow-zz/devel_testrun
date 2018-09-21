
//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "InterfacialForceCH.h"

registerMooseObject("PhaseFieldApp", InterfacialForceCH);

template <>
InputParameters
validParams<InterfacialForceCH>()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the interfacial force term coupled with Cahn-Hilliard equation" "Weak form: R = (sum(c_i * grad_mu_i),  testfunction)");
  params.addRequiredCoupledVar("orderparam_vars", "Order parameters to be coupled");
  params.addRequiredCoupledVar("chempot_vars", "Chemical potentialss to be coupled");
  params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  params.addParam<Real>("prefactor", 1.0, "Prefactor for convenience");
  params.addParam<MaterialPropertyName>("mask_name","M","A bilevel data with 0 and 1; The mask will vanish this kernel where the value of the mask is zero");
  // params.addParam<unsigned int>("act_var_num",0,"Fs is calculated only within the 'solve_var' interface.");
  return params;
}

InterfacialForceCH::InterfacialForceCH(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _jvar2cvar(_nvar + 1),
  _c_var(coupledComponents("orderparam_vars")),
  _c(coupledComponents("orderparam_vars")),
  _w_var(coupledComponents("chempot_vars")),
  _grad_w(coupledComponents("chempot_vars")),
  _component(getParam<MooseEnum>("component")),
  _L(getParam<Real>("prefactor")),
  _M(getMaterialProperty<Real>("mask_name"))
  // _act_var_num(getParam<unsigned int>("act_var_num"))
{
  // if (_act_var_num >= _c_var.size())
  //   mooseError(" '_act_var_num' should be less than %d"
  //              "", _c_var.size());
  if (_c_var.size() != _w_var.size())
    mooseError("'orderparam_vars' and 'chempot_vars' should have the same number of variables"
               "");

  for (unsigned int i = 0; i < _c_var.size(); ++i)
  {
    _c_var[i] = coupled("orderparam_vars", i);
    _c[i] = &coupledValue("orderparam_vars", i);
    _w_var[i] = coupled("chempot_vars", i);
    _grad_w[i] = &coupledGradient("chempot_vars", i);

    // printf("!!! Kernel:InterfacialForceCH: _c_var[%d] = %d \n", i, _c_var[i]);
    // printf("!!! Kernel:InterfacialForceCH: _w_var[%d] = %d \n", i, _w_var[i]);
    _jvar2cvar[_c_var[i]] = i;
    _jvar2cvar[_w_var[i]] = i;

    if (_var.number() == _c_var[i])
      mooseError("Coupled variable 'orderpar_vars' needs to be different from 'variable' with InterfacialForceCH, "
                 "");
    if (_var.number() == _w_var[i])
      mooseError("Coupled variable 'chempot_vars' needs to be different from 'variable' with InterfacialForceCH, "
                 "");
  }

  for (unsigned int i = 0; i < _nvar+1; i++)
  {
    // printf("!!! Kernel:InterfacialForceCH: _jvar2cvar[%d] = %d \n", i, _jvar2cvar[i]);
  }
}

Real
InterfacialForceCH::computeQpResidual()
{
  Real returnval = 0.0;
  // if ((*_c[_act_var_num])[_qp] > 0 && (*_c[_act_var_num])[_qp] < 1)
  // {
    for (unsigned int i = 0; i < _c_var.size(); ++i)
    {
      returnval += (*_c[i])[_qp] * (*_grad_w[i])[_qp](_component);
    }
  // }
  return _L * returnval * _test[_i][_qp] * _M[_qp];
}

Real
InterfacialForceCH::computeQpJacobian()
{
  return 0;
}

Real
InterfacialForceCH::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real returnval = 0.0;
  if (jvar < _nvar)
  {
    // printf("!!! Kernel:InterfacialForceCH: Jod: jvar = %d \n", jvar);
    // if ((*_c[_act_var_num])[_qp] > 0 && (*_c[_act_var_num])[_qp] < 1)
    // {
      if (jvar == _c_var[_jvar2cvar[jvar]])
      {

        returnval = _L * _phi[_j][_qp] * (*_grad_w[_jvar2cvar[jvar]])[_qp](_component) * _test[_i][_qp];
      }
      if (jvar == _w_var[_jvar2cvar[jvar]])
      {
        returnval = _L * (*_c[_jvar2cvar[jvar]])[_qp] * _grad_phi[_j][_qp](_component) * _test[_i][_qp];
      }
    // }
  }
  return returnval * _M[_qp];
}
