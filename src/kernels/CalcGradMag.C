
//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "CalcGradMag.h"

registerMooseObject("PhaseFieldApp", CalcGradMag);

template <>
InputParameters
validParams<CalcGradMag>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the gradient component of a coupled variable" "The coupled variable should be declared as a Variable, not an AuxVariable.");
  params.addRequiredCoupledVar("v", "The coupled variable from which the laplacian will be taken");
  return params;
}

CalcGradMag::CalcGradMag(const InputParameters & parameters)
  : Kernel(parameters),
  _v_var(coupled("v")),
  _grad_v(coupledGradient("v"))
{
  if (_var.number() == _v_var)
    mooseError("Coupled variable 'v' needs to be different from 'variable' with CoupledGradComponents, "
               "");
}

Real
CalcGradMag::computeQpResidual()
{
  return (_u[_qp] - _grad_v[_qp] * _grad_v[_qp]) * _test[_i][_qp];
}

Real
CalcGradMag::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp];
}

Real
CalcGradMag::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
  {
    return -(2 * _grad_phi[_j][_qp] * _grad_v[_qp]) * _test[_i][_qp];
  }else{
    return 0;
  }
  // return 0;
}
