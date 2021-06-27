//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef VARADVECTION_H
#define VARADVECTION_H

#include "Kernel.h"

// Forward Declaration
class VarAdvection;

template <>
InputParameters validParams<VarAdvection>();

class VarAdvection : public Kernel
{
public:
  VarAdvection(const InputParameters & parameters);

protected:
  virtual Real div_u(unsigned int dim);
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const VariableValue & _v_x;
  unsigned int _v_x_var;
  const VariableValue & _v_y;
  unsigned int _v_y_var;
  const VariableValue & _v_z;
  unsigned int _v_z_var;

  const VariableGradient & _grad_u_vel;
  const VariableGradient & _grad_v_vel;
  const VariableGradient & _grad_w_vel;
  Real _coef;

};

#endif // VARADVECTION_H
