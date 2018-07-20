//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef DEDGRADVARDEVEL_H
#define DEDGRADVARDEVEL_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

class dFdGradVarDevel;

template <>
InputParameters validParams<dFdGradVarDevel>();

class dFdGradVarDevel : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  dFdGradVarDevel(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  RealGradient get_dfgrad_darg(unsigned int qp);
  RealGradient get_d2fgrad_darg2(unsigned int cvar, unsigned int qp);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  /// Constant prefactor just for a convenience
  const Real _L;
  /// Free energy density in terms of gradient components of the coupled variables; 0th order derivative from Material data
  const MaterialProperty<Real> & _fgrad;
  /// Free energy density in terms of gradient components of the coupled variables; 1st order derivatives from Material data
  std::vector<const MaterialProperty<Real> *> _dfgrad_darg;
  /// Free energy density in terms of gradient components of the coupled variables; 2nd order derivatives from Material data
  std::vector<std::vector<const MaterialProperty<Real> *>> _d2fgrad_darg2;
};

#endif // DEDGRADVARDEVEL_H
