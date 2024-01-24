//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "moose_issuesTestApp.h"
#include "moose_issuesApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
moose_issuesTestApp::validParams()
{
  InputParameters params = moose_issuesApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

moose_issuesTestApp::moose_issuesTestApp(InputParameters parameters) : MooseApp(parameters)
{
  moose_issuesTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

moose_issuesTestApp::~moose_issuesTestApp() {}

void
moose_issuesTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  moose_issuesApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"moose_issuesTestApp"});
    Registry::registerActionsTo(af, {"moose_issuesTestApp"});
  }
}

void
moose_issuesTestApp::registerApps()
{
  registerApp(moose_issuesApp);
  registerApp(moose_issuesTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
moose_issuesTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  moose_issuesTestApp::registerAll(f, af, s);
}
extern "C" void
moose_issuesTestApp__registerApps()
{
  moose_issuesTestApp::registerApps();
}
