
//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "DistanceFunction.h"

registerMooseObject("PhaseFieldApp", DistanceFunction);

template <>
InputParameters
validParams<DistanceFunction>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the distance function from the initial bilevel structure" "");
  params.addRequiredCoupledVar("bilevel_data", "The coupled variable which provides the bilevel data");
  params.addParam<Real>("epsilon",0.01,"The smoothing factor for the Sgn function");
  return params;
}

DistanceFunction::DistanceFunction(const InputParameters & parameters)
  : Kernel(parameters),
  _v_var(coupled("bilevel_data")),
  _v(coupledValue("bilevel_data")),
  _eps(getParam<Real>("epsilon"))
{
  if (_var.number() == _v_var)
    mooseError("Coupled variable 'bilevel_data' needs to be different from 'variable' with DistanceFunction, "
               "");
}

Real
DistanceFunction::computeQpResidual()
{
  Real mysgn = _v[_qp]/sqrt(_v[_qp] * _v[_qp] + _eps * _eps);
  return mysgn * (sqrt(_grad_u[_qp] * _grad_u[_qp]) - 1.0) * _test[_i][_qp];
}

Real
DistanceFunction::computeQpJacobian()
{
  Real gradmag = sqrt( _grad_u[_qp] * _grad_u[_qp]  + _eps * _eps);
  Real mysgn = _v[_qp]/(sqrt(_v[_qp] * _v[_qp] + _eps * _eps));

  if (gradmag > 0) {
    return mysgn * (_grad_u[_qp] * _grad_phi[_j][_qp]) / gradmag * _test[_i][_qp];
  } else {
    return 0;
  }
  //return mysgn * (_grad_u[_qp] * _grad_phi[_j][_qp]) / gradmag * _test[_i][_qp];
}

Real
DistanceFunction::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real dmysgn_dv = (_eps * _eps)/sqrt(_v[_qp] * _v[_qp] + _eps * _eps)/(_v[_qp] * _v[_qp] + _eps * _eps) * _phi[_j][_qp];
  if (jvar == _v_var)
    return dmysgn_dv * (sqrt(_grad_u[_qp] * _grad_u[_qp]) - 1) * _test[_i][_qp];
  return 0.0;

  // return 0.0;
}
