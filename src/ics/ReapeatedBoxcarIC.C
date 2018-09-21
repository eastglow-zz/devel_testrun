//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "RepeatedBoxcarIC.h"
#include "MooseMesh.h"

registerMooseObject("PhaseFieldApp", RepeatedBoxcarIC);

template <>
InputParameters
validParams<RepeatedBoxcarIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addClassDescription("Specify variable values above and below y-coordinate of the shape curve"
                             "shape curve: superposition of (bump_height/2)*(tanh((x-i*L-xs))-tanh((x-(i+1)*L-xs))) over i index");
  params.addRequiredParam<Real>("xs", "Bump starting along x-axis");
  params.addRequiredParam<Real>("ys", "y-coordinate of the surface");
  params.addRequiredParam<unsigned int>("nbumps", "The number of bumps");
  params.addRequiredParam<Real>("pitch_length", "Pitch length of the repeated pattern");
  params.addRequiredParam<Real>("bump_height", "Bump height of the repeated pattern");
  params.addRequiredParam<Real>("diffusive_length", "Diffusive length of tahn function; tanh(r/ld)");
  params.addRequiredParam<Real>("above_value", "Field value to be assigned where y > y_shape");
  params.addRequiredParam<Real>("below_value", "Field value to be assigned where y <= y_shape");

  return params;
}

RepeatedBoxcarIC::RepeatedBoxcarIC(const InputParameters & parameters)
  : InitialCondition(parameters),
    _xs(getParam<Real>("xs")),
    _ys(getParam<Real>("ys")),
    _nbumps(getParam<unsigned int>("nbumps")),
    _lpitch(getParam<Real>("pitch_length")),
    _hbump(getParam<Real>("bump_height")),
    _ld(getParam<Real>("diffusive_length")),
    _above(getParam<Real>("above_value")),
    _below(getParam<Real>("below_value"))
{
}

Real
RepeatedBoxcarIC::value(const Point & p)
{
  Real value = _above;

  Real yref = 0.0;
  for (unsigned int i = 0; i < _nbumps; ++i)
  {
    yref += _hbump * 0.5 * (tanh((p(0) - _lpitch * i - _xs)/_ld) - tanh((p(0) - _lpitch * (i + 0.5) - _xs)/_ld));
  }
  if ( p(1) > yref + _ys )
  {
    value = _above;
  }else{
    value = _below;
  }

  return value;
}
