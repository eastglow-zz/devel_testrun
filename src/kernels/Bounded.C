//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Bounded.h"

registerMooseObject("PhaseFieldApp", Bounded);

template <>
InputParameters
validParams<Bounded>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription(
      "This kernel enforces the variable value is bounded within the range: [v_lb, v_ub]");
  params.addParam<Real>("v_lb",0,"The lower bound value for the constraint");
  params.addParam<Real>("v_ub",1,"The upper bound value for the constraint");
  return params;
}

Bounded::Bounded(const InputParameters & parameters)
  : Kernel(parameters),
    _val_lb(getParam<Real>("v_lb")),
    _val_ub(getParam<Real>("v_ub"))
{
}

Real
Bounded::computeQpResidual()
{
  Real returnval = 0.0;
  if( _u[_qp] < _val_lb ) {
    returnval = _u[_qp] - _val_lb;
  } else if ( _u[_qp] >_val_ub) {
    returnval = _u[_qp] - _val_ub;
  }
  return returnval * _test[_i][_qp];
}

Real
Bounded::computeQpJacobian()
{
  Real returnval = 0;
  if( _u[_qp] < _val_lb || _u[_qp] >_val_ub) {
    returnval = 1;
  }
  return returnval * _test[_i][_qp];
}
