//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef DEVEL_TESTRUNTESTAPP_H
#define DEVEL_TESTRUNTESTAPP_H

#include "MooseApp.h"

class devel_testrunTestApp;

template <>
InputParameters validParams<devel_testrunTestApp>();

class devel_testrunTestApp : public MooseApp
{
public:
  devel_testrunTestApp(InputParameters parameters);
  virtual ~devel_testrunTestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* DEVEL_TESTRUNTESTAPP_H */
