//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FWDSPLITCH_H
#define FWDSPLITCH_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class FwdSplitCH;

template <>
InputParameters validParams<FwdSplitCH>();

class FwdSplitCH : public DerivativeMaterialInterface<Kernel>
{
public:
  FwdSplitCH(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  RealGradient get_dM_dgradvar();
  RealGradient get_dM_dgradcvar(unsigned int cvar);
  // RealGradient get_d2M_dgradvar2(unsigned int cvar, unsigned int qp);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  unsigned int _v_var;
  const VariableValue & _mu;
  const VariableGradient & _grad_mu;
  std::vector<unsigned int> _gradvars;
  std::vector<unsigned int> _cvars;
  std::vector<unsigned int> _gradcvars;
  const Real _L;
  /// Mobility Material data; 0th order derivative from Material data
  const MaterialProperty<Real> & _M;
  /// Mobility Material data; 1st order derivative over the variable from Material data
  const MaterialProperty<Real> & _dM_dvar;
  /// Mobility Material data; 1st order derivatives over the gradient variable from Material data
  std::vector<const MaterialProperty<Real> *> _dM_dgradvar;
  /// Mobility Material data; 1st order derivatives over the coupled variables from Material data
  std::vector<const MaterialProperty<Real> *> _dM_dcvars;
  /// Mobility as a function of var and grad_var ; 1st order derivatives over the gradients of coupled variables from Material data
  std::vector<const MaterialProperty<Real> *> _dM_dgradcvars;
  /// Mobility as a function of var and grad_var ; 2nd order derivatives over the gradient variable from Material data
  // std::vector<std::vector<const MaterialProperty<Real> *>> _d2M_dgradvar2;

};

#endif // FWDSPLITCH_H
