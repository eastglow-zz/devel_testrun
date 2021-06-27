//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COUPLEDCROSSBULKENERGY_H
#define COUPLEDCROSSBULKENERGY_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"

class CoupledCrossBulkEnergy;

template <>
InputParameters validParams<CoupledCrossBulkEnergy>();

class CoupledCrossBulkEnergy : public DerivativeMaterialInterface<Kernel>
{
public:
  CoupledCrossBulkEnergy(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  unsigned int _compvar;
  std::vector<VariableName> _cvar_names;
  std::vector<unsigned int> _cvars;
  const Real _A;
  const MaterialPropertyName _fb_name;
  const MaterialProperty<Real> & _fb;
  unsigned int _nmat;
  const MaterialProperty<Real> & _dfb_dvar;
  const MaterialProperty<Real> & _d2fb_dvar2;
  std::vector<const MaterialProperty<Real> *> _d2fb_dvardcvar;
};

#endif // COUPLEDCROSSBULKENERGY_H
