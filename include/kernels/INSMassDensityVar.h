//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef INSMASSDENSITYVAR_H
#define INSMASSDENSITYVAR_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

// Forward Declarations
class INSMassDensityVar;

template <>
InputParameters validParams<INSMassDensityVar>();

/**
 * This class computes density variation term
 * contributions for the 'traction' form of the governing equations..
 */
class INSMassDensityVar : public DerivativeMaterialInterface<Kernel>
{
public:
  INSMassDensityVar(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const unsigned int _nvar;
  const Real _L;
  std::vector<unsigned int> _jvar2cvar;
  std::vector<unsigned int> _jvar2velvar;
  std::vector<unsigned int> _cvars;

  /// Density Material data; 0th order derivative from Material data
  const MaterialProperty<Real> & _rho;
  /// Density Material data; 1st order derivatives over the coupled variables from Material data
  std::vector<const MaterialProperty<Real> *> _drho_dcvars;
  /// Density Material data; 2ndt order derivatives over the coupled variables from Material data
  std::vector<std::vector<const MaterialProperty<Real> *>> _d2rho_dcvars2;

  std::vector<const VariableValue *> _cdots;
  std::vector<const VariableGradient *> _cgrads;
  std::vector<const VariableValue *> _cdots_du;

  const unsigned int _u_vel_var_number;
  const unsigned int _v_vel_var_number;
  const unsigned int _w_vel_var_number;
  const VariableValue & _u_vel;
  const VariableValue & _v_vel;
  const VariableValue & _w_vel;
};

#endif // INSMASSDENSITYVAR_H
