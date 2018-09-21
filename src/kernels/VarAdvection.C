//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "VarAdvection.h"

registerMooseObject("MooseApp", VarAdvection);

template <>
InputParameters
validParams<VarAdvection>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Strong form of a generic advection term of a variable;  "
                             "R = (v dot grad_var, test)");
  //params.addRequiredParam<RealVectorValue>("velocity", "Velocity vector");
  params.addRequiredCoupledVar("vel_x","x_velocity_component");
  params.addCoupledVar("vel_y","y_velocity_component");
  params.addCoupledVar("vel_z","z_velocity_component");
  return params;
}

VarAdvection::VarAdvection(const InputParameters & parameters)
  : Kernel(parameters),
    _v_x(coupledValue("vel_x")), _v_x_var(coupled("vel_x")),
    _v_y(_mesh.dimension() >= 2 ? coupledValue("vel_y") : _zero), _v_y_var(_mesh.dimension() >= 2 ? coupled("vel_y") : _mesh.dimension()+1),
    _v_z(_mesh.dimension() >= 3 ? coupledValue("vel_z") : _zero), _v_z_var(_mesh.dimension() >= 2 ? coupled("vel_z") : _mesh.dimension()+1),
    _grad_u_vel(coupledGradient("vel_x")),
    _grad_v_vel(coupledGradient("vel_y")),
    _grad_w_vel(coupledGradient("vel_z"))
{
}

Real
VarAdvection::div_u(unsigned int dim)
{
  Real returnval = _grad_u_vel[_qp](0);
  switch (dim)
  {
    case 3:
      returnval += _grad_v_vel[_qp](1);
      returnval += _grad_w_vel[_qp](2);
      break;
    case 2:
      returnval += _grad_v_vel[_qp](1);
      break;
    case 1:
      break;
    default:
      paramError("INSMomentumTractionFormDensityVar::div_u()","dim is out of range");
      break;
  }
  return returnval;
}

Real
VarAdvection::computeQpResidual()
{
  const RealGradient v(_v_x[_qp], _v_y[_qp], _v_z[_qp]);
  // return -_u[_qp] * (_v * _grad_test[_i][_qp]);
  return ( v * _grad_u[_qp] + _u[_qp] * div_u(_mesh.dimension()) ) * _test[_i][_qp];
}

Real
VarAdvection::computeQpJacobian()
{
  const RealGradient v(_v_x[_qp], _v_y[_qp], _v_z[_qp]);
  // return -_phi[_j][_qp] * (_v * _grad_test[_i][_qp]);
  return ( v * _grad_phi[_j][_qp] + _phi[_j][_qp] * div_u(_mesh.dimension()) ) * _test[_i][_qp];
}

Real
VarAdvection::computeQpOffDiagJacobian(unsigned int jvar)
{
  const RealGradient v(jvar == _v_x_var ? _phi[_j][_qp] : 0, jvar == _v_y_var ? _phi[_j][_qp] : 0, jvar == _v_z_var ? _phi[_j][_qp] : 0);
  const RealGradient dvdcvar(jvar == _v_x_var ? 1 : 0, jvar == _v_y_var ? 1 : 0, jvar == _v_z_var ? 1 : 0);
  // return -_u[_qp] * (_v * _grad_test[_i][_qp]);
  return ( v * _grad_u[_qp] + _u[_qp] * (dvdcvar * _grad_phi[_j][_qp]) ) * _test[_i][_qp];
}
