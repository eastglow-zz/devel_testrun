//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COUPLEDGRADCOMPONENT_H
#define COUPLEDGRADCOMPONENT_H

#include "Kernel.h"

class CoupledGradComponent;

template <>
InputParameters validParams<CoupledGradComponent>();

class CoupledGradComponent : public Kernel
{
public:
  CoupledGradComponent(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// Smoothing factor of Sgn function
  unsigned int _v_var;
  const VariableValue & _v;
  const VariableGradient & _grad_v;
  /// Desired component
  int _component;
};

#endif // COUPLEDGRADCOMPONENT_H
