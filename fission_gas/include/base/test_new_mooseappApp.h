//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef TEST_NEW_MOOSEAPPAPP_H
#define TEST_NEW_MOOSEAPPAPP_H

#include "MooseApp.h"

class test_new_mooseappApp;

template <>
InputParameters validParams<test_new_mooseappApp>();

class test_new_mooseappApp : public MooseApp
{
public:
  test_new_mooseappApp(InputParameters parameters);
  virtual ~test_new_mooseappApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s);
};

#endif /* TEST_NEW_MOOSEAPPAPP_H */
