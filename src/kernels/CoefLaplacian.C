//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoefLaplacian.h"

registerMooseObject("PhaseFieldApp", CoefLaplacian);

template <>
InputParameters
validParams<CoefLaplacian>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription(
      "Laplacian multiplied by constant and function provided by Material; prefactor * grad dot (M(x,y,z)*grad(var + basefield))");
  params.addParam<MaterialPropertyName>("M", "prefactor_mat", "The kappa used with the kernel");
  params.addParam<Real>("prefactor",1,"The prefacror used with the kernel, a constant");
  params.addCoupledVar("basefield_var", "Name of the basefield variable");
  return params;
}

CoefLaplacian::CoefLaplacian(const InputParameters & parameters)
  : Kernel(parameters),
    _L(getParam<Real>("prefactor")),
    _M(getMaterialProperty<Real>("M")),
    _bf_var(coupled("basefield_var")),
    _bf(coupledValue("basefield_var")),
    _grad_bf(coupledGradient("basefield_var"))
{
}

Real
CoefLaplacian::computeQpResidual()
{
  return -(_grad_u[_qp] + _grad_bf[_qp]) * _M[_qp] * _L * _grad_test[_i][_qp];
}

Real
CoefLaplacian::computeQpJacobian()
{
  return -_grad_phi[_j][_qp] * _M[_qp] * _L * _grad_test[_i][_qp];
}

Real
CoefLaplacian::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _bf_var)
  {
    return -_grad_phi[_j][_qp] * _M[_qp] * _L * _grad_test[_i][_qp];
  }else{
    return 0;
  }
}
