//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "test_new_mooseappTestApp.h"
#include "test_new_mooseappApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<test_new_mooseappTestApp>()
{
  InputParameters params = validParams<test_new_mooseappApp>();
  return params;
}

test_new_mooseappTestApp::test_new_mooseappTestApp(InputParameters parameters) : MooseApp(parameters)
{
  test_new_mooseappTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

test_new_mooseappTestApp::~test_new_mooseappTestApp() {}

void
test_new_mooseappTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  test_new_mooseappApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"test_new_mooseappTestApp"});
    Registry::registerActionsTo(af, {"test_new_mooseappTestApp"});
  }
}

void
test_new_mooseappTestApp::registerApps()
{
  registerApp(test_new_mooseappApp);
  registerApp(test_new_mooseappTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
test_new_mooseappTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  test_new_mooseappTestApp::registerAll(f, af, s);
}
extern "C" void
test_new_mooseappTestApp__registerApps()
{
  test_new_mooseappTestApp::registerApps();
}
