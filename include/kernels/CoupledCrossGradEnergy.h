//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COUPLEDCROSSGRADENERGY_H
#define COUPLEDCROSSGRADENERGY_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class CoupledCrossGradEnergy;

template <>
InputParameters validParams<CoupledCrossGradEnergy>();

class CoupledCrossGradEnergy : public DerivativeMaterialInterface<Kernel>
{
public:
  CoupledCrossGradEnergy(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  // RealGradient get_d2M_dgradvar2(unsigned int cvar, unsigned int qp);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  unsigned int _compvar;
  const VariableValue & _compval;
  const VariableGradient & _grad_compval;
  std::vector<VariableName> _cvar_names;
  std::vector<unsigned int> _cvars;
  std::vector<const VariableValue *> _cvals;
  std::vector<const VariableGradient *> _grad_cvals;
  MaterialPropertyName _M_name;
  const MaterialProperty<Real> & _M;
  const Real _A;
  std::vector<MaterialPropertyName> _kappa_names;
  std::vector<const MaterialProperty<Real> *> _kappas;

  // const VariableValue & _mu;
  // const VariableGradient & _grad_mu;
  // std::vector<unsigned int> _gradvars;
  //
  // std::vector<unsigned int> _gradcvars;
  // const Real _L;
  // /// Mobility Material data; 0th order derivative from Material data
  // const MaterialProperty<Real> & _M;
  // /// Mobility Material data; 1st order derivative over the variable from Material data
  // const MaterialProperty<Real> & _dM_dvar;
  // /// Mobility Material data; 1st order derivatives over the gradient variable from Material data
  // std::vector<const MaterialProperty<Real> *> _dM_dgradvar;
  // /// Mobility Material data; 1st order derivatives over the coupled variables from Material data
  // std::vector<const MaterialProperty<Real> *> _dM_dcvars;
  // /// Mobility as a function of var and grad_var ; 1st order derivatives over the gradients of coupled variables from Material data
  // std::vector<const MaterialProperty<Real> *> _dM_dgradcvars;
  // /// Mobility as a function of var and grad_var ; 2nd order derivatives over the gradient variable from Material data
  // // std::vector<std::vector<const MaterialProperty<Real> *>> _d2M_dgradvar2;

};

#endif // COUPLEDCROSSGRADENERGY_H
