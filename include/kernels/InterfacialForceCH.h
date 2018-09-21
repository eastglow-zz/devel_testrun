//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef INTERFACIALFORCECH_H
#define INTERFACIALFORCECH_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class InterfacialForceCH;

template <>
InputParameters validParams<InterfacialForceCH>();

class InterfacialForceCH : public DerivativeMaterialInterface<Kernel>
{
public:
  InterfacialForceCH(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const unsigned int _nvar;
  std::vector<unsigned int> _jvar2cvar;
  std::vector<unsigned int> _c_var;
  std::vector<const VariableValue *> _c;
  std::vector<unsigned int> _w_var;
  std::vector<const VariableGradient *> _grad_w;
  /// Desired component
  int _component;
  const Real _L;
  const MaterialProperty<Real> & _M;
  // const unsigned int _act_var_num;
};

#endif // INTERFACIALFORCECH_H
