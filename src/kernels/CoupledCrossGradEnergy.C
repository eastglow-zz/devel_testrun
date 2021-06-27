//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html



#include "CoupledCrossGradEnergy.h"

registerMooseObject("PhaseFieldApp", CoupledCrossGradEnergy);

template <>
InputParameters
validParams<CoupledCrossGradEnergy>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates a general form of M * mu_i = M * A * dFgrad/dc_i, where mu_i is the variable, c_i is a coupled variable, M is the mobility from Material, and A is the prefactor");
  params.addParam<Real>("prefactor",1,"The prefacror, a constant Real value");
  params.addRequiredParam<MaterialPropertyName>("mobility_name", "mobility material name");
  params.addRequiredParam<std::vector<MaterialPropertyName>>("kappa_names", "Gradient energy coefficients (order sensitive)");
  params.addRequiredCoupledVar("chempot_comp_cname", "ci, where the derivative variable for the chemical potential, mu_i = dFdci");
  params.addRequiredCoupledVar("c_names", "The coupled order parameter name. ci should not be here. (order sensitive)");
  return params;
}

CoupledCrossGradEnergy::CoupledCrossGradEnergy(const InputParameters & parameters)
  : DerivativeMaterialInterface<Kernel>(parameters),
  _nvar(_fe_problem.getNonlinearSystemBase().nVariables()),
  _compvar(coupled("chempot_comp_cname")),
  _compval(coupledValue("chempot_comp_cname")),
  _grad_compval(coupledGradient("chempot_comp_cname")),
  _cvar_names(getParam<std::vector<VariableName>>("c_names")),
  _cvars(coupledComponents("c_names")),
  _cvals(coupledComponents("c_names")),
  _M(getMaterialProperty<Real>("mobility_name")),
  _A(getParam<Real>("prefactor")),
  _kappa_names(getParam<std::vector<MaterialPropertyName>>("kappa_names"))
{
  // Get the gradients of the coupled variables
  // _grad_compval = &coupledGradient("chempot_comp_cname");
  _grad_cvals.resize(_cvar_names.size());
  for(unsigned int l = 0; l < _cvar_names.size(); ++l)
  {
    // const VariableName iname = getVar("c_names", i)->name();
    if (_cvar_names[l] == getVar("chempot_comp_cname",0)->name())
      paramError("c_names entry error",\
                 "The kernel variable should not be specified in the coupled parameter.");

    // _grad_cvals[i] = &coupledGradient(iname);
    _cvars[l] = coupled("c_names", l);
    _cvals[l] = &coupledValue("c_names", l);
    _grad_cvals[l] = &coupledGradient("c_names", l);
    // printf("FwdSplitCHChemPot::FwdSplitCHChemPot >> _grad_cvals[%d] loaded\n",i);
  }

  // printf("cL = %d\n", _compvar);
  // printf("cV = %d, cS = %d, wV = %d, wS = %d\n", _cvars[0], _cvars[1], _cvars[2], _cvars[3]);


  // Get kappas
  _kappas.resize(_kappa_names.size());
  for (unsigned int l = 0; l < _kappa_names.size(); ++l)
  {
    // const MaterialPropertyName imname = getVar("kappa_names",i)->name();
    _kappas[l] = &getMaterialPropertyByName<Real>(_kappa_names[l]);
  }

}

void
CoupledCrossGradEnergy::initialSetup()
{
  validateCoupling<Real>("chempot_comp_cname");
  validateCoupling<Real>("c_names");
  validateCoupling<Real>("kappa_names");
}

Real
CoupledCrossGradEnergy::computeQpResidual()
{
  // Real term1 = -_u[_qp] * _test[_i][_qp];
  Real term1 = 0.0;
  Real term2 = 0.0;
  Real term3 = 0.0;

  // term2 and term3: loop over _cvars[i]
  for(unsigned int l = 0; l < _cvar_names.size(); ++l)
  {
    term2 += -(_compval[_qp] * (*_grad_cvals[l])[_qp] * (*_grad_cvals[l])[_qp] - (*_cvals[l])[_qp] * _grad_compval[_qp] * (*_grad_cvals[l])[_qp]) * _test[_i][_qp] * (*_kappas[l])[_qp];
    term3 += ((*_cvals[l])[_qp] * (*_cvals[l])[_qp] * _grad_compval[_qp] - _compval[_qp] * (*_cvals[l])[_qp] * (*_grad_cvals[l])[_qp]) * _grad_test[_i][_qp] * (*_kappas[l])[_qp];
  }

  return _A * _M[_qp] * (term1 + term2 + term3);
}

Real
CoupledCrossGradEnergy::computeQpJacobian()
{
  // return -_A * _M[_qp] * _phi[_j][_qp] * _test[_i][_qp];
  return 0.0;
}

Real
CoupledCrossGradEnergy::computeQpOffDiagJacobian(unsigned int jvar)
{
  // Real gradvar_sq = _grad_compval[_qp] * _grad_compval[_qp];
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
  //       Real gradcvar_sq = (*_grad_cvals[i])[_qp] * (*_grad_cvals[i])[_qp];
  //       gradcvar_sq = 1; //for test
  //       if (gradvar_sq * gradcvar_sq > 0) {
  //         result = -_B * sum_d2fij_dvardcvar * _phi[_j][_qp] * _test[_i][_qp] + _A * (*_kappas[i])[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
  //       }
  //     }
  //     // printf("FwdSplitCHChemPot::computeQpOffDiagJacobian >> dbg4, _cvars[i] = %d, jvar = %d \n", _cvars[i], jvar);
  //   }
  // }
  // printf("jvar = %d\n", jvar);

  // Map jvar to l, the index of _cvars
  unsigned int j = _cvars.size(); // Initialize j so that it can have 'out-of-range' value initially.
  for (unsigned int l = 0; l < _cvars.size(); ++l)
  {
    // printf("_cvars[%d] = %d\n", l, _cvars[l]);
    if(jvar == _cvars[l])
    {
      j = l;
    }
  }
  // printf("k = %d\n", j);

  if (jvar == _compvar)
  {
    Real term1 = 0.0;
    Real term2 = 0.0;
    Real term3 = 0.0;
    Real term4 = 0.0;
    Real term5 = 0.0;
    Real termAll = 0.0;
    for (unsigned int l = 0; l < _cvars.size(); ++l)
    {
      term1 += -_phi[_j][_qp] * (*_grad_cvals[l])[_qp] * (*_grad_cvals[l])[_qp] * _test[_i][_qp] * (*_kappas[l])[_qp];
      term2 += 0.0;
      term3 += (*_cvals[l])[_qp] * _grad_phi[_j][_qp] * (*_grad_cvals[l])[_qp] * _test[_i][_qp] * (*_kappas[l])[_qp];
      term4 += (*_cvals[l])[_qp] * (*_cvals[l])[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp] * (*_kappas[l])[_qp];
      term5 += _phi[_j][_qp] * (*_cvals[l])[_qp] * (*_grad_cvals[l])[_qp] * _grad_test[_i][_qp] * (*_kappas[l])[_qp];
    }
    termAll = _A * _M[_qp] * (term1 + term2 + term3 + term4 + term5);

    return termAll;

  }else if(j < _cvars.size()){
    Real term1 = 0.0;
    Real term2 = 0.0;
    Real term3 = 0.0;
    Real term4 = 0.0;
    Real term5 = 0.0;
    Real term6 = 0.0;
    Real termAll = 0.0;

    term1 = -2.0 * _compval[_qp] * (*_grad_cvals[j])[_qp] * _grad_phi[_j][_qp] * _test[_i][_qp];
    term2 = _phi[_j][_qp] * _grad_compval[_qp] * (*_grad_cvals[j])[_qp] * _test[_i][_qp];
    term3 = (*_cvals[j])[_qp] * _grad_compval[_qp] * _grad_phi[_j][_qp] * _test[_i][_qp];
    term4 = 2.0 * _phi[_j][_qp] * (*_cvals[j])[_qp] * _grad_compval[_qp] * _grad_test[_i][_qp];
    term5 = -_compval[_qp] * _phi[_j][_qp] * (*_grad_cvals[j])[_qp] * _grad_test[_i][_qp];
    term6 = -_compval[_qp] * (*_cvals[j])[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
    termAll = _A * _M[_qp] * (*_kappas[j])[_qp] * (term1 + term2 + term3 + term4 + term5 + term6);

    return termAll;

  }else{
    return 0.0;
  }
}
