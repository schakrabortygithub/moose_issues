#include "moose_issuesApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
moose_issuesApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

moose_issuesApp::moose_issuesApp(InputParameters parameters) : MooseApp(parameters)
{
  moose_issuesApp::registerAll(_factory, _action_factory, _syntax);
}

moose_issuesApp::~moose_issuesApp() {}

void 
moose_issuesApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<moose_issuesApp>(f, af, s);
  Registry::registerObjectsTo(f, {"moose_issuesApp"});
  Registry::registerActionsTo(af, {"moose_issuesApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
moose_issuesApp::registerApps()
{
  registerApp(moose_issuesApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
moose_issuesApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  moose_issuesApp::registerAll(f, af, s);
}
extern "C" void
moose_issuesApp__registerApps()
{
  moose_issuesApp::registerApps();
}
