//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef REAPEATEDBOXCARIC_H
#define REAPEATEDBOXCARIC_H

#include "InitialCondition.h"

// Forward Declarations
class RepeatedBoxcarIC;

template <>
InputParameters validParams<RepeatedBoxcarIC>();

/**
 * RepeatedBoxcarEquilProfileIC allows setting the initial condition of a value of a field inside and outside
 * multiple bounding boxes. Each box is axis-aligned and is specified by passing in the x,y,z
 * coordinates of opposite corners. Separate values for each box may be supplied.
 */
class RepeatedBoxcarIC : public InitialCondition
{
public:
  RepeatedBoxcarIC(const InputParameters & parameters);

  virtual Real value(const Point & p) override;

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

#endif // REAPEATEDBOXCARIC_H
