//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "AllenCahnBounded.h"

registerMooseObject("PhaseFieldApp", AllenCahnBounded);

template <>
InputParameters
validParams<AllenCahnBounded>()
{
  InputParameters params = ACBulk<Real>::validParams();
  params.addClassDescription("Allen-Cahn Kernel that uses a DerivativeMaterial Free Energy with a bounded order parameter");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Base name of the free energy function F defined in a DerivativeParsedMaterial");
  params.addParam<Real>("v_lb",0,"The lower bound value for the constraint");
  params.addParam<Real>("v_ub",1,"The upper bound value for the constraint");
  return params;
}

AllenCahnBounded::AllenCahnBounded(const InputParameters & parameters)
  : ACBulk<Real>(parameters),
    _nvar(_coupled_moose_vars.size()),
    _dFdEta(getMaterialPropertyDerivative<Real>("f_name", _var.name())),
    _d2FdEta2(getMaterialPropertyDerivative<Real>("f_name", _var.name(), _var.name())),
    _d2FdEtadarg(_nvar),
    _val_lb(getParam<Real>("v_lb")),
    _val_ub(getParam<Real>("v_ub"))
{
  // Iterate over all coupled variables
  for (unsigned int i = 0; i < _nvar; ++i)
    _d2FdEtadarg[i] =
        &getMaterialPropertyDerivative<Real>("f_name", _var.name(), _coupled_moose_vars[i]->name());
}

void
AllenCahnBounded::initialSetup()
{
  ACBulk<Real>::initialSetup();
  validateNonlinearCoupling<Real>("f_name");
  validateDerivativeMaterialPropertyBase<Real>("f_name");
}

Real
AllenCahnBounded::computeDFDOP(PFFunctionType type)
{
  switch (type)
  {
    case Residual:
      if ( _u[_qp] < _val_lb || _u[_qp] > _val_ub) {
        return 0;
      } else {
        return _dFdEta[_qp];
      }


    case Jacobian:
      if ( _u[_qp] < _val_lb || _u[_qp] > _val_ub) {
        return 0;
      } else {
        return _d2FdEta2[_qp] * _phi[_j][_qp];
      }
  }

  mooseError("Internal error");
}

Real
AllenCahnBounded::computeQpOffDiagJacobian(unsigned int jvar)
{
  // get the coupled variable jvar is referring to
  const unsigned int cvar = mapJvarToCvar(jvar);
  if ( _u[_qp] < _val_lb || _u[_qp] > _val_ub) {
    return 0;
  } else {
    return ACBulk<Real>::computeQpOffDiagJacobian(jvar) +
           _L[_qp] * (*_d2FdEtadarg[cvar])[_qp] * _phi[_j][_qp] * _test[_i][_qp];
  }
}
