//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FWDSPLITCH1_H
#define FWDSPLITCH1_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class FwdSplitCH1;

template <>
InputParameters validParams<FwdSplitCH1>();

class FwdSplitCH1 : public DerivativeMaterialInterface<Kernel>
{
public:
  FwdSplitCH1(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  // RealGradient get_d2M_dgradvar2(unsigned int cvar, unsigned int qp);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const unsigned int _nvar;
  unsigned int _v_var;
  const VariableValue & _mu;
  const VariableGradient & _grad_mu;
  std::vector<unsigned int> _jvar2cvar;
  std::vector<unsigned int> _cvars;
  const Real _L;
  /// Mobility Material data; 0th order derivative from Material data
  const MaterialProperty<Real> & _M;
  /// Mobility Material data; 1st order derivatives over the coupled variables from Material data
  std::vector<const MaterialProperty<Real> *> _dM_dcvars;
};

#endif // FWDSPLITCH1_H
