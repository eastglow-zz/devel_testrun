//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef TEST_NEW_MOOSEAPPTESTAPP_H
#define TEST_NEW_MOOSEAPPTESTAPP_H

#include "MooseApp.h"

class test_new_mooseappTestApp;

template <>
InputParameters validParams<test_new_mooseappTestApp>();

class test_new_mooseappTestApp : public MooseApp
{
public:
  test_new_mooseappTestApp(InputParameters parameters);
  virtual ~test_new_mooseappTestApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs = false);
};

#endif /* TEST_NEW_MOOSEAPPTESTAPP_H */
