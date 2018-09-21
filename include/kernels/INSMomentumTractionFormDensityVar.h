//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef INSMOMENTUMTRACTIONFORMDENSITYVAR_H
#define INSMOMENTUMTRACTIONFORMDENSITYVAR_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

// Forward Declarations
class INSMomentumTractionFormDensityVar;

template <>
InputParameters validParams<INSMomentumTractionFormDensityVar>();

/**
 * This class computes density variation term
 * contributions for the 'traction' form of the governing equations..
 */
class INSMomentumTractionFormDensityVar : public DerivativeMaterialInterface<Kernel>
{
public:
  INSMomentumTractionFormDensityVar(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  virtual Real div_u(unsigned int dim);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const unsigned int _nvar;
  const Real _L;
  std::vector<unsigned int> _jvar2cvar;
  std::vector<unsigned int> _cvars;

  /// Mobility Material data; 0th order derivative from Material data
  const MaterialProperty<Real> & _rho;
  /// Mobility Material data; 1st order derivatives over the coupled variables from Material data
  std::vector<const MaterialProperty<Real> *> _drho_dcvars;

  const VariableValue & _u_vel;
  const VariableValue & _v_vel;
  const VariableValue & _w_vel;
  const VariableGradient & _grad_u_vel;
  const VariableGradient & _grad_v_vel;
  const VariableGradient & _grad_w_vel;
  int _component;
};

#endif // INSMOMENTUMTRACTIONFORMDENSITYVAR_H
