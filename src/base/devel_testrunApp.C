#include "devel_testrunApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<devel_testrunApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

devel_testrunApp::devel_testrunApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  devel_testrunApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  devel_testrunApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  devel_testrunApp::registerExecFlags(_factory);
}

devel_testrunApp::~devel_testrunApp() {}

void
devel_testrunApp::registerApps()
{
  registerApp(devel_testrunApp);
}

void
devel_testrunApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"devel_testrunApp"});
}

void
devel_testrunApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"devel_testrunApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
devel_testrunApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
devel_testrunApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
devel_testrunApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
devel_testrunApp__registerApps()
{
  devel_testrunApp::registerApps();
}

extern "C" void
devel_testrunApp__registerObjects(Factory & factory)
{
  devel_testrunApp::registerObjects(factory);
}

extern "C" void
devel_testrunApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  devel_testrunApp::associateSyntax(syntax, action_factory);
}

extern "C" void
devel_testrunApp__registerExecFlags(Factory & factory)
{
  devel_testrunApp::registerExecFlags(factory);
}
