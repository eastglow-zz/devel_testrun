//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COEFLAPLACIAN_H
#define COEFLAPLACIAN_H

#include "Kernel.h"

class CoefLaplacian;

template <>
InputParameters validParams<CoefLaplacian>();

/**
 * Compute the Allen-Cahn interface term with constant Mobility and Interfacial parameter
 */
class CoefLaplacian : public Kernel
{
public:
  CoefLaplacian(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// Mobility
  const Real _L;
  const MaterialProperty<Real> & _M;
  unsigned int _bf_var;
  const VariableValue & _bf;
  const VariableGradient & _grad_bf;
};

#endif // COEFLAPLACIAN_H
