//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef BOUNDED_H
#define BOUNDED_H

#include "Kernel.h"

class Bounded;

template <>
InputParameters validParams<Bounded>();

/**
 * Compute the Allen-Cahn interface term with constant Mobility and Interfacial parameter
 */
class Bounded : public Kernel
{
public:
  Bounded(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  /// Lower bound value
  const Real _val_lb;
  /// Upper bound value
  const Real _val_ub;
};

#endif // BOUNDED_H
