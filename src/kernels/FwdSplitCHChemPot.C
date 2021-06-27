//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "FwdSplitCHChemPot.h"

registerMooseObject("PhaseFieldApp", FwdSplitCHChemPot);

template <>
InputParameters
validParams<FwdSplitCHChemPot>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates a general form of mu_i = A * dFgrad/dc_i + B * dFbulk/dc_i, where mu_i is the variable, c_i is a coupled variable, and A and B are the prefactors");
  params.addParam<Real>("A",1,"The prefacror for the laplacian term, a constant");
  params.addParam<Real>("B",1,"The prefacror for the bulk free energy term, a constant");
  params.addRequiredParam<std::vector<MaterialPropertyName>>("kappa_names","Gradient energy coefficients");
  params.addRequiredCoupledVar("chempot_comp_cname", "ci, where the derivative variable for the chemical potential, mu_i = dFdci");
  params.addRequiredCoupledVar("c_names", "The coupled order parameter name. ci should not be here.");
  return params;
}

FwdSplitCHChemPot::FwdSplitCHChemPot(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _compvar(coupled("chempot_comp_cname")),
  _cvar_names(getParam<std::vector<VariableName>>("c_names")),
  _cvars(coupledComponents("c_names")),
  // _c(coupledValue("c_name")),
  _grad_var(coupledGradient("chempot_comp_cname")),
  // _grad_cvars(coupledGradient("c_names")),
  _A(getParam<Real>("A")),
  _B(getParam<Real>("B")),
  // _kappa(getMaterialProperty<Real>("kappa_names")),
  // _fdw(getMaterialProperty<Real>("fdw_names")),
  _kappa_names(getParam<std::vector<MaterialPropertyName>>("kappa_names"))
{
  // Get the gradients of the coupled variables
  // _grad_var = &coupledGradient("chempot_comp_cname");
  _grad_cvars.resize(_cvar_names.size());
  for(unsigned int i = 0; i < _cvar_names.size(); ++i)
  {
    // const VariableName iname = getVar("c_names", i)->name();
    if (_cvar_names[i] == getVar("chempot_comp_cname",0)->name())
      paramError("c_names entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    // _grad_cvars[i] = &coupledGradient(iname);
    _cvars[i] = coupled("c_names", i);
    _grad_cvars[i] = &coupledGradient("c_names", i);
    // printf("FwdSplitCHChemPot::FwdSplitCHChemPot >> _grad_cvars[%d] loaded\n",i);
  }

  // printf("cL = %d\n", _compvar);
  // printf("cV = %d, cS = %d, wV = %d, wS = %d\n", _cvars[0], _cvars[1], _cvars[2], _cvars[3]);


  // Get kappas
  _kappas.resize(_kappa_names.size());
  for (unsigned int i = 0; i < _kappa_names.size(); ++i)
  {
    // const MaterialPropertyName imname = getVar("kappa_names",i)->name();
    _kappas[i] = &getMaterialPropertyByName<Real>(_kappa_names[i]);
  }

}

void
FwdSplitCHChemPot::initialSetup()
{
  validateCoupling<Real>("chempot_comp_cname");
  validateCoupling<Real>("c_names");
  validateCoupling<Real>("kappa_names");
}

Real
FwdSplitCHChemPot::computeQpResidual()
{
  // printf("FwdSplitCHChemPot::computeQpResidual >> dbg0 \n");
  Real result = _u[_qp] * _test[_i][_qp];
  // printf("FwdSplitCHChemPot::computeQpResidual >> dbg0-1 \n");
  Real gradvar_sq = _grad_var[_qp] * _grad_var[_qp];
  gradvar_sq = 1;
  // printf("FwdSplitCHChemPot::computeQpResidual >> dbg1 \n");
  // printf("_qp = %d, _dfij_dvar = %lf\n", _qp, (*_dfij_dvar[0])[_qp]);
  for (unsigned int i = 0; i < _fij_names.size(); ++i)
  {
    Real gradcvar_sq = (*_grad_cvars[i])[_qp] * (*_grad_cvars[i])[_qp];
    gradcvar_sq = 1;  //for test
    if (gradvar_sq * gradcvar_sq > 0) {
      result += - _B * (*_dfij_dvar[i])[_qp] * _test[_i][_qp];
      // printf("_dfij_dvar = %lf\n", (*_dfij_dvar[i])[_qp]);
    }

  }
  // printf("result = %lf\n", result);
  // printf("FwdSplitCHChemPot::computeQpResidual >> dbg2 \n");


  for (unsigned int i = 0; i < _kappa_names.size(); ++i)
  {
    Real gradcvar_sq = (*_grad_cvars[i])[_qp] * (*_grad_cvars[i])[_qp];
    gradcvar_sq = 1; //for test
    if (gradvar_sq * gradcvar_sq > 0) {
      result += _A * (*_kappas[i])[_qp] * ((*_grad_cvars[i])[_qp] * _grad_test[_i][_qp]);
    }
  }

  return result;
}

Real
FwdSplitCHChemPot::computeQpJacobian()
{
  Real result = -_phi[_j][_qp] * _test[_i][_qp];
  return result;
}

Real
FwdSplitCHChemPot::computeQpOffDiagJacobian(unsigned int jvar)
{
  // Real gradvar_sq = _grad_var[_qp] * _grad_var[_qp];
  // gradvar_sq = 1; //for test
  //
  // Real result = 0;
  // Real sum_d2fij_dvardcvar = 0;
  // Real sum_d2fij_dvar2 = 0;
  //
  // if (jvar == _var)
  // {
  //   if (gradvar_sq > 0)
  //   {
  //     for (unsigned int i = 0 ; i < _fij_names.size(); ++i){
  //       sum_d2fij_dvar2 += (*_d2fij_dvar2[i])[_qp];
  //     }
  //   }
  //   result = -_B * sum_d2fij_dvar2 * _phi[_j][_qp] * _test[_i][_qp];
  // }else{
  //   unsigned int kkk = _nvar + 1;  // Default value: if jvar doesn't match to one of the element of _cvars[]
  //   // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg1, _cvars.size() = %lu \n", _cvars.size());
  //   for (unsigned int i = 0; i < _cvars.size(); ++i)
  //   {
  //     if (jvar == _cvars[i]){
  //       kkk = i;
  //       // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg1, i = %d, k = %d \n", i, k);
  //     }else{
  //       // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg2, no match \n");
  //     }
  //   }
  //
  //   for (unsigned int i = 0; i < _fij_names.size(); ++i)
  //   {
  //     if (kkk <= _nvar) {
  //       // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg3, i = %d, k = %d \n", i, kkk);
  //       sum_d2fij_dvardcvar += (*_d2fij_dvardcvar[i][kkk])[_qp];
  //     }else{
  //       sum_d2fij_dvardcvar = 0;
  //     }
  //     // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg1, _cvars[i] = %d, jvar = %d \n", _cvars[i], jvar);
  //   }
  //
  //   for (unsigned int i = 0; i < _cvar_names.size(); ++i)
  //   {
  //     // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg3, _cvars[i] = %d, jvar = %d \n", _cvars[i], jvar);
  //     if (jvar == _cvars[i])
  //     {
  //       Real gradcvar_sq = (*_grad_cvars[i])[_qp] * (*_grad_cvars[i])[_qp];
  //       gradcvar_sq = 1; //for test
  //       if (gradvar_sq * gradcvar_sq > 0) {
  //         result = -_B * sum_d2fij_dvardcvar * _phi[_j][_qp] * _test[_i][_qp] + _A * (*_kappas[i])[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
  //       }
  //     }
  //     // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg4, _cvars[i] = %d, jvar = %d \n", _cvars[i], jvar);
  //   }
  // }
  // printf("jvar = %d\n", jvar);
  Real result = 0.0;
  unsigned int k = _cvars.size();
  for (unsigned int i = 0; i < _cvars.size(); ++i)
  {
    // printf("_cvars[%d] = %d\n", i, _cvars[i]);
    if(jvar == _cvars[i])
    {
      k = i;
    }
  }
  // printf("k = %d\n", k);

  if (jvar == _compvar)
  {
    Real sum_d2fij_dvar2 = 0;
    for (unsigned int i = 0 ; i < _fij_names.size(); ++i){
      sum_d2fij_dvar2 += (*_d2fij_dvar2[i])[_qp];
    }
    // printf("jvar = %d, sum_d2fij_dvar2 = %lf\n", jvar, sum_d2fij_dvar2);
    result = -_B * sum_d2fij_dvar2 * _phi[_j][_qp] * _test[_i][_qp];
    return result;
  }else if(k < _cvars.size()){
    Real sum_d2fij_dvardcvar = 0;
    for (unsigned int i = 0; i < _fij_names.size(); ++i)
    {
      sum_d2fij_dvardcvar += (*_d2fij_dvardcvar[i][k])[_qp];
    }
    result = -_B * sum_d2fij_dvardcvar * _phi[_j][_qp] * _test[_i][_qp] + _A * (*_kappas[k])[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
    return result;
  }else{
    return 0.0;
  }
}
