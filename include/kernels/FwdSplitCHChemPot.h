//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FWDSPLITCHCHEMPOT_H
#define FWDSPLITCHCHEMPOT_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class FwdSplitCHChemPot;

template <>
InputParameters validParams<FwdSplitCHChemPot>();

class FwdSplitCHChemPot : public DerivativeMaterialInterface<Kernel>
{
public:
  FwdSplitCHChemPot(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  RealGradient get_dM_dgradvar();
  RealGradient get_dM_dgradcvar(unsigned int cvar);
  // RealGradient get_d2M_dgradvar2(unsigned int cvar, unsigned int qp);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  unsigned int _compvar;
  std::vector<VariableName> _cvar_names;
  std::vector<unsigned int> _cvars;
  const VariableGradient & _grad_var;
  std::vector<const VariableGradient *> _grad_cvars;
  const Real _A;
  const Real _B;
  std::vector<MaterialPropertyName> _kappa_names;
  std::vector<const MaterialProperty<Real> *> _kappas;
  std::vector<MaterialPropertyName> _fij_names;
  std::vector<const MaterialProperty<Real> *> _fij;
  unsigned int _nmat;
  std::vector<const MaterialProperty<Real> *> _dfij_dvar;
  std::vector<const MaterialProperty<Real> *> _d2fij_dvar2;
  // std::vector<const MaterialProperty<Real> *> _d2fij_dvardcvar;
  std::vector<std::vector<const MaterialProperty<Real> *>> _d2fij_dvardcvar;

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

#endif // FWDSPLITCHCHEMPOT_H
