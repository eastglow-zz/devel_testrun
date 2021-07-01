#include "test_new_mooseappApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<test_new_mooseappApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

test_new_mooseappApp::test_new_mooseappApp(InputParameters parameters) : MooseApp(parameters)
{
  test_new_mooseappApp::registerAll(_factory, _action_factory, _syntax);
}

test_new_mooseappApp::~test_new_mooseappApp() {}

void
test_new_mooseappApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"test_new_mooseappApp"});
  Registry::registerActionsTo(af, {"test_new_mooseappApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
test_new_mooseappApp::registerApps()
{
  registerApp(test_new_mooseappApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
test_new_mooseappApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  test_new_mooseappApp::registerAll(f, af, s);
}
extern "C" void
test_new_mooseappApp__registerApps()
{
  test_new_mooseappApp::registerApps();
}
