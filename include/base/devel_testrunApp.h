//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef DEVEL_TESTRUNAPP_H
#define DEVEL_TESTRUNAPP_H

#include "MooseApp.h"

class devel_testrunApp;

template <>
InputParameters validParams<devel_testrunApp>();

class devel_testrunApp : public MooseApp
{
public:
  devel_testrunApp(InputParameters parameters);
  virtual ~devel_testrunApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void registerObjectDepends(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void associateSyntaxDepends(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* DEVEL_TESTRUNAPP_H */
