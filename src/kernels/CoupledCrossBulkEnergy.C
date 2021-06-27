//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "CoupledCrossBulkEnergy.h"

registerMooseObject("PhaseFieldApp", CoupledCrossBulkEnergy);

template <>
InputParameters
validParams<CoupledCrossBulkEnergy>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("A kernel for d(fbulk)/d(chempot_var) for the forward split method of Cahn-Hilliard eqn solver. The variable is mu_i, the chemical potential of ith component.");
  params.addParam<Real>("A",1,"The prefacror for the bulk free energy term, a constant");
  params.addRequiredCoupledVar("chempot_comp_cname", "ci, where the derivative variable for the chemical potential, mu_i = dFdci");
  params.addRequiredCoupledVar("c_names", "The coupled order parameter name. ci should not be here.");
  params.addParam<MaterialPropertyName>("fbulk_name","fBulk","The name of the bulk free energy density function, a function of ci and cnames");
  return params;
}

CoupledCrossBulkEnergy::CoupledCrossBulkEnergy(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _compvar(coupled("chempot_comp_cname")),
  _cvar_names(getParam<std::vector<VariableName>>("c_names")),
  _cvars(coupledComponents("c_names")),
  _A(getParam<Real>("A")),
  _fb(getMaterialProperty<Real>("fbulk_name")),
  _dfb_dvar(getMaterialPropertyDerivative<Real>("fbulk_name", "chempot_comp_cname")),
  _d2fb_dvar2(getMaterialPropertyDerivative<Real>("fbulk_name", "chempot_comp_cname", "chempot_comp_cname")),
  _d2fb_dvardcvar(coupledComponents("c_names"))
{
  for(unsigned int i = 0; i < _cvar_names.size(); ++i)
  {
    // const VariableName iname = getVar("c_names", i)->name();
    if (_cvar_names[i] == getVar("chempot_comp_cname",0)->name())
      paramError("c_names entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    _cvars[i] = coupled("c_names", i);

    _d2fb_dvardcvar[i] = &getMaterialPropertyDerivative<Real>("fbulk_name","chempot_comp_cname",_cvar_names[i]);
  }

}

void
CoupledCrossBulkEnergy::initialSetup()
{
  validateCoupling<Real>("chempot_comp_cname");
  validateCoupling<Real>("c_names");
  validateNonlinearCoupling<Real>("fbulk_name");
}

Real
CoupledCrossBulkEnergy::computeQpResidual()
{
  return _A * _dfb_dvar[_qp] * _test[_i][_qp];
}

Real
CoupledCrossBulkEnergy::computeQpJacobian()
{
  return 0.0;
}

Real
CoupledCrossBulkEnergy::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real result = 0.0;
  unsigned int k = _cvars.size();
  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    // printf("_cvars[%d] = %d, jvar = %d\n", i, _cvars[i], jvar);
    if(jvar == _cvars[i])
    {
      k = i;
    }
  }
  // printf("k = %d\n", k);

  if (jvar == _compvar)
  {
    return _A * _d2fb_dvar2[_qp] * _phi[_j][_qp] * _test[_i][_qp];
  }else if(k < _cvars.size()){
    return _A * (*_d2fb_dvardcvar[k])[_qp] * _phi[_j][_qp] * _test[_i][_qp];
    // return 0.0;
  }else{
    return 0.0;
  }
}
