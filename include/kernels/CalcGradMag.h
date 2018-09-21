//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef CALCGRADMAG_H
#define CALCGRADMAG_H

#include "Kernel.h"

class CalcGradMag;

template <>
InputParameters validParams<CalcGradMag>();

class CalcGradMag : public Kernel
{
public:
  CalcGradMag(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// Smoothing factor of Sgn function
  unsigned int _v_var;
  const VariableGradient & _grad_v;
};

#endif // CALCGRADMAG_H
