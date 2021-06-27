//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef ALLENCAHNBOUNDED_H
#define ALLENCAHNBOUNDED_H

#include "ACBulk.h"

// Forward Declarations
class AllenCahnBounded;

template <>
InputParameters validParams<AllenCahnBounded>();

/**
 * AllenCahn uses the Free Energy function and derivatives
 * provided by a DerivativeParsedMaterial to computer the
 * residual for the bulk part of the Allen-Cahn equation.
 */
class AllenCahnBounded : public ACBulk<Real>
{
public:
  AllenCahnBounded(const InputParameters & parameters);

  virtual void initialSetup();

protected:
  virtual Real computeDFDOP(PFFunctionType type);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  const MaterialProperty<Real> & _dFdEta;
  const MaterialProperty<Real> & _d2FdEta2;

  std::vector<const MaterialProperty<Real> *> _d2FdEtadarg;

  /// Lower bound value
  const Real _val_lb;
  /// Upper bound value
  const Real _val_ub;
};

#endif // ALLENCAHN_H
