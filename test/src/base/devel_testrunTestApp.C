//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "devel_testrunTestApp.h"
#include "devel_testrunApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<devel_testrunTestApp>()
{
  InputParameters params = validParams<devel_testrunApp>();
  return params;
}

devel_testrunTestApp::devel_testrunTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  devel_testrunApp::registerObjectDepends(_factory);
  devel_testrunApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  devel_testrunApp::associateSyntaxDepends(_syntax, _action_factory);
  devel_testrunApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  devel_testrunApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    devel_testrunTestApp::registerObjects(_factory);
    devel_testrunTestApp::associateSyntax(_syntax, _action_factory);
    devel_testrunTestApp::registerExecFlags(_factory);
  }
}

devel_testrunTestApp::~devel_testrunTestApp() {}

void
devel_testrunTestApp::registerApps()
{
  registerApp(devel_testrunApp);
  registerApp(devel_testrunTestApp);
}

void
devel_testrunTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
devel_testrunTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
devel_testrunTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
devel_testrunTestApp__registerApps()
{
  devel_testrunTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
devel_testrunTestApp__registerObjects(Factory & factory)
{
  devel_testrunTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
devel_testrunTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  devel_testrunTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
devel_testrunTestApp__registerExecFlags(Factory & factory)
{
  devel_testrunTestApp::registerExecFlags(factory);
}
