
//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "CoupledGradComponent.h"

registerMooseObject("PhaseFieldApp", CoupledGradComponent);

template <>
InputParameters
validParams<CoupledGradComponent>()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the gradient component of a coupled variable" "The coupled variable should be declared as a Variable, not an AuxVariable.");
  params.addRequiredCoupledVar("arg", "The coupled variable from which the gradient will be taken");
  params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  return params;
}

CoupledGradComponent::CoupledGradComponent(const InputParameters & parameters)
  : Kernel(parameters),
  _v_var(coupled("arg")),
  _v(coupledValue("arg")),
  _grad_v(coupledGradient("arg")),
  _component(getParam<MooseEnum>("component"))
{
  if (_var.number() == _v_var)
    mooseError("Coupled variable 'arg' needs to be different from 'variable' with CoupledGradComponents, "
               "");
}

Real
CoupledGradComponent::computeQpResidual()
{
  return (_u[_qp] - _grad_v[_qp](_component)) * _test[_i][_qp];
}

Real
CoupledGradComponent::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp];
}

Real
CoupledGradComponent::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
  {
    return -_grad_phi[_j][_qp](_component) * _test[_i][_qp];
  }else{
    return 0;
  }
  // return 0;
}
