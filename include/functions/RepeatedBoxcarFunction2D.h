//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef REAPEATEDBOXCARFUNCTION2D_H
#define REAPEATEDBOXCARFUNCTION2D_H

#include "Function.h"

class RepeatedBoxcarFunction2D;

template <>
InputParameters validParams<RepeatedBoxcarFunction2D>();

/**
 * Class that represents constant function
 */
class RepeatedBoxcarFunction2D : public Function
{
public:
  RepeatedBoxcarFunction2D(const InputParameters & parameters);

  virtual Real value(Real t, const Point & p) override;

protected:
  /// Coordinate shift along x directions
  const Real _xs;
  /// y-coordinate of the surface
  const Real _ys;
  /// The number of bumps
  const unsigned int _nbumps;
  /// Pitch length
  const Real _lpitch;
  /// Bump height
  const Real _hbump;
  /// Diffussive length of the shape
  const Real _ld;
  /// Value above the boundary function
  const Real _above;
  /// Value below the boundary function
  const Real _below;
};

#endif
