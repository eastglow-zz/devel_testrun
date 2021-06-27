

#Forward split method

interwidth = 5 #Target full-interfacial Width
interwidth_i = 5 #Target full-interfacial Width
# alpha = 9.1902397003  # 2*ln(0.99/0.01)
alpha = 5.8888779583  # 2*ln(0.95/0.05)

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
  #type = FileMesh
  #file = notch.msh
[]

[AuxVariables]
  [./ColorField]
    order = FIRST
    family = LAGRANGE
  [../]
  [./cV_constrained]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./Coloring]
    type = ParsedAux
    variable = ColorField
    args = 'cL cV cS'
    constant_names =       'coidxL coidxV coidxS'
    constant_expressions = '0      1      2'
    function = 'coidxL*cL + coidxV*cV + coidxS*cS'
  [../]
  [./cV_update]
    type = ParsedAux
    variable = cV_constrained
    args = 'cL cS'
    function = '1 - cL - cS'
  [../]
[]

[Variables]
  [./cL]
    order = FIRST
    family = LAGRANGE
  [../]

  [./cV]
    order = FIRST
    family = LAGRANGE
  [../]

  [./cS]
    order = FIRST
    family = LAGRANGE
  [../]

  [./wL]
    order = FIRST
    family = LAGRANGE
  [../]

  [./wV]
    order = FIRST
    family = LAGRANGE
  [../]

  [./wS]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./cL_IC]
    type = FunctionIC
    variable = cL
    function = TheCircle
  [../]
  [./cS_IC]
    type = FunctionIC
    variable = cS
    function = FlatSlab
  [../]
  [./cV_IC]
    type = FunctionIC
    variable = cV
    function = Background
  [../]
  # [./cL_testIC]
  #   type = BoundingBoxIC
  #   variable = cL
  #   x1 = 30
  #   x2 = 70
  #   y1 = 30
  #   y2 = 70
  #   inside = 1
  #   outside = 0
  # [../]
  # [./cV_testIC]
  #   type = BoundingBoxIC
  #   variable = cV
  #   x1 = 30
  #   x2 = 70
  #   y1 = 30
  #   y2 = 70
  #   inside = 0
  #   outside = 1
  # [../]
  # [./Cs_testIC]
  #   type = ConstantIC
  #   variable = cS
  #   value = 0
  # [../]
  [./wL_zero]
    type = ConstantIC
    variable = wL
    value = 0
  [../]
  [./wV_zero]
    type = ConstantIC
    variable = wV
    value = 0
  [../]
  [./wS_zero]
    type = ConstantIC
    variable = wS
    value = 0
  [../]
[]

[Functions]
  [./OneConst]
    type = ConstantFunction
    value = 1
  [../]
  [./TheCircle]
    type = ParsedFunction
    vars = 'x0 y0 r0'
    vals = '50 30 20'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5-0.5*tanh(0.5*${alpha}*(r-r0)/${interwidth_i})'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  [./FlatSlab]
    type = ParsedFunction
    vars = 'y0'
    vals = '10'
    value = '0.5-0.5*tanh(0.5*${alpha}*(y-y0)/${interwidth_i})'
  [../]
  [./Background]
    type = LinearCombinationFunction
    functions = 'OneConst TheCircle FlatSlab'
    w =         '1        -1        -1'
  [../]
[]

[Kernels]
  # R_cL part
  [./cL_timederivative_term]
    type = TimeDerivative
    variable = cL
  [../]
  [./cL_divgradwL_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wL
    kappa_name = ML
    mob_name = One
  [../]
  # [./cL_divgradwV_term]
  #   type = SimpleCoupledACInterface
  #   variable = cL
  #   v = wV
  #   kappa_name = M
  #   mob_name = negOne
  # [../]
  # [./cL_divgradwS_term]
  #   type = SimpleCoupledACInterface
  #   variable = cL
  #   v = wS
  #   kappa_name = M
  #   mob_name = negOne
  # [../]

  # R_wL part
  [./wL_neg_wL_term]
    type = MassEigenKernel
    variable = wL
    eigen = false
  [../]
  # [./wL_lap_cV_term]
  #   type = SimpleCoupledACInterface
  #   variable = wL
  #   v = cV
  #   kappa_name = kappa_LV
  #   mob_name = negOne
  # [../]
  # [./wL_lap_cS_term]
  #   type = SimpleCoupledACInterface
  #   variable = wL
  #   v = cS
  #   kappa_name = kappa_LS
  #   mob_name = negOne
  # [../]
  # [./wL_GradEterm]
  #   type = CoupledCrossGradEnergy
  #   variable = wL
  #   chempot_comp_cname = 'cL'
  #   c_names =     'cV       cS'
  #   kappa_names = 'kappa_LV kappa_LS'
  #   mobility_name = One
  #   prefactor = 1.0
  # [../]
  [./wL_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cL
    kappa_name = eps_Sig_L
    mob_name = One
  [../]
  [./wL_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cS
    kappa_name = eps_Sig_S
    mob_name = One
  [../]
  [./wL_doublewell_L_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fDW
    args = 'cL cV cS'
    mob_name = Sinv_L
  [../]
  [./wL_doublewell_V_term]
    type = CoupledAllenCahn
    variable = wL
    v = cV
    f_name = fDW
    args = 'cL cV cS'
    mob_name = Sinv_V
  [../]
  # [./wL_doublewell_S_term]
  #   type = CoupledAllenCahn
  #   variable = wL
  #   v = cS
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = Sinv_S
  # [../]
  # [./wL_doublewell_LS_term]
  #   type = CoupledAllenCahn
  #   variable = wL
  #   v = cS
  #   f_name = fLS_tw
  #   args = 'cL cS cV'
  #   mob_name = One
  # [../]

  # [./wL]
  #   type = FwdSplitCHChemPot
  #   variable = wL
  #   chempot_comp_cname = cL
  #   c_names = 'cV cS'
  #   kappa_names = 'kappa_LV kappa_LS'
  #   fij_names = 'fLV fLS'
  #   prefactor_dw_term = 1
  #   prefactor_lap_term = 1
  # [../]

  # R_cV part
  # [./cV_timederivative_term]
  #   type = TimeDerivative
  #   variable = cV
  # [../]
  # [./cV_divgradwL_term]
  #   type = SimpleCoupledACInterface
  #   variable = cV
  #   v = wV
  #   kappa_name = M
  #   mob_name = One
  # [../]
  # [./cV_divgradwV_term]
  #   type = SimpleCoupledACInterface
  #   variable = cV
  #   v = wL
  #   kappa_name = M
  #   mob_name = negOne
  # [../]
  # [./cV_itself]
  #   type = MassEigenKernel
  #   variable = cV
  #   eigen = false
  # [../]
  # [./cV_constraint]
  #   type = CoupledForce
  #   variable = cV
  #   v = cV_constrained
  #   coef = -1
  # [../]

  [./cV_timederivative_term]
    type = TimeDerivative
    variable = cV
  [../]
  [./cV_divgradwV_term]
    type = SimpleCoupledACInterface
    variable = cV
    v = wV
    kappa_name = MV
    mob_name = One
  [../]
  # [./cVdot_constraint_L]
  #   type = CoefCoupledTimeDerivative
  #   variable = cV
  #   v = cL
  #   coef = 1
  # [../]
  # [./cVdot_constraint_S]
  #   type = CoefCoupledTimeDerivative
  #   variable = cV
  #   v = cS
  #   coef = 1
  # [../]

  # R_wV part
  [./wV_neg_wV_term]
    type = MassEigenKernel
    variable = wV
    eigen = false
  [../]
  # [./wV_lap_cL_term]
  #   type = SimpleCoupledACInterface
  #   variable = wV
  #   v = cL
  #   kappa_name = kappa_LV
  #   mob_name = negOne
  # [../]
  # [./wV_lap_cS_term]
  #   type = SimpleCoupledACInterface
  #   variable = wV
  #   v = cS
  #   kappa_name = kappa_VS
  #   mob_name = negOne
  # [../]
  # [./wV_GradEterm]
  #   type = CoupledCrossGradEnergy
  #   variable = wV
  #   chempot_comp_cname = 'cV'
  #   c_names =     'cL       cS'
  #   kappa_names = 'kappa_LV kappa_VS'
  #   mobility_name = One
  #   prefactor = 1.0
  # [../]
  # [./wV_lap_cV_term]
  #   type = SimpleCoupledACInterface
  #   variable = wV
  #   v = cV
  #   kappa_name = eps_Sig_V
  #   mob_name = One
  # [../]
  # [./wV_doublewell_V_term]
  #   type = CoupledAllenCahn
  #   variable = wV
  #   v = cV
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = S_LS
  # [../]
  # [./wV_doublewell_L_term]
  #   type = CoupledAllenCahn
  #   variable = wV
  #   v = cL
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = Sinv_L
  # [../]
  # [./wV_doublewell_S_term]
  #   type = CoupledAllenCahn
  #   variable = wV
  #   v = cS
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = Sinv_S
  # [../]
  # [./wV_doublewell_VS_term]
  #   type = CoupledAllenCahn
  #   variable = wV
  #   v = cV
  #   f_name = fVS_tw
  #   args = 'cV cS cL'
  #   mob_name = One
  # [../]
  # [./wV_compute]
  #   type = FwdSplitCHChemPot
  #   variable = wV
  #   chempot_comp_cname = cV
  #   c_names = 'cL cS'
  #   kappa_names = 'kappa_LV kappa_VS'
  #   fij_names = 'fLV fVS'
  #   prefactor_dw_term = 1
  #   prefactor_lap_term = 1
  # [../]

  # R_cS part
  [./cS_timederivative]
    type = TimeDerivative
    variable = cS
  [../]

  # [./wS_compute]
  [./wS_neg_wS_term]
    type = MassEigenKernel
    variable = wS
    eigen = false
  [../]
  # [./wS_lap_cL_term]
  #   type = SimpleCoupledACInterface
  #   variable = wS
  #   v = cL
  #   kappa_name = kappa_LS
  #   mob_name = negOne
  # [../]
  # [./wS_lap_cV_term]
  #   type = SimpleCoupledACInterface
  #   variable = wS
  #   v = cV
  #   kappa_name = kappa_VS
  #   mob_name = negOne
  # [../]
  # [./wS_GradEterm]
  #   type = CoupledCrossGradEnergy
  #   variable = wS
  #   chempot_comp_cname = 'cS'
  #   c_names =     'cL       cV'
  #   kappa_names = 'kappa_LS kappa_VS'
  #   mobility_name = One
  #   prefactor = 1.0
  # [../]
  # [./wS_lap_cS_term]
  #   type = SimpleCoupledACInterface
  #   variable = wS
  #   v = cS
  #   kappa_name = eps_Sig_S
  #   mob_name = One
  # [../]
  # [./wS_doublewell_S_term]
  #   type = CoupledAllenCahn
  #   variable = wS
  #   v = cS
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = S_LV
  # [../]
  # [./wS_doublewell_L_term]
  #   type = CoupledAllenCahn
  #   variable = wS
  #   v = cL
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = Sinv_L
  # [../]
  # [./wS_doublewell_V_term]
  #   type = CoupledAllenCahn
  #   variable = wS
  #   v = cV
  #   f_name = fDW
  #   args = 'cL cV cS'
  #   mob_name = Sinv_V
  # [../]
  # [./wS_doublewell_VS_term]
  #   type = CoupledAllenCahn
  #   variable = wS
  #   v = cS
  #   f_name = fVS_tw
  #   args = 'cV cS'
  #   mob_name = One
  # [../]
  #   type = FwdSplitCHChemPot
  #   variable = wS
  #   chempot_comp_cname = cS
  #   c_names = 'cL cV'
  #   kappa_names = 'kappa_LS kappa_VS'
  #   fij_names = 'fLS fVS'
  #   prefactor_dw_term = 1
  #   prefactor_lap_term = 1
  # [../]

[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS sig_VS M   One negOne twh_factor Two e'
    prop_values = '1     0.5    1      0.1 1   -1     0          2   3'
    # prop_values = '1     0.134  1      1 1   -1     1'
  [../]

  [./kappa_LV]
    type = ParsedMaterial
    f_name = kappa_LV
    material_property_names = 'sig_LV'
    function = '6*sig_LV*${interwidth}/${alpha}'
  [../]

  [./kappa_LS]
    type = ParsedMaterial
    f_name = kappa_LS
    material_property_names = 'sig_LS'
    function = '6*sig_LS*${interwidth}/${alpha}'
  [../]

  [./kappa_VS]
    type = ParsedMaterial
    f_name = kappa_VS
    material_property_names = 'sig_VS'
    function = '6*sig_VS*${interwidth}/${alpha}'
  [../]

  [./kappa_L]
    type = ParsedMaterial
    f_name = kappa_L
    material_property_names = 'Sfac_L'
    function = '6*${interwidth}/${alpha} * (-Sfac_L)'
  [../]

  [./kappa_V]
    type = ParsedMaterial
    f_name = kappa_V
    material_property_names = 'Sfac_V'
    function = '6*${interwidth}/${alpha} * (-Sfac_V)'
  [../]

  [./kappa_S]
    type = ParsedMaterial
    f_name = kappa_S
    material_property_names = 'Sfac_S'
    function = '6*${interwidth}/${alpha} * (-Sfac_S)'
  [../]

  [./dwh_LV]
    type = ParsedMaterial
    f_name = dwh_LV
    material_property_names = 'sig_LV'
    function = '3*${alpha}*sig_LV/${interwidth}'
  [../]

  [./dwh_LS]
    type = ParsedMaterial
    f_name = dwh_LS
    material_property_names = 'sig_LS'
    function = '3*${alpha}*sig_LS/${interwidth}'
  [../]

  [./dwh_VS]
    type = ParsedMaterial
    f_name = dwh_VS
    material_property_names = 'sig_VS'
    function = '3*${alpha}*sig_VS/${interwidth}'
  [../]

  [./Sfac_L]
    type = ParsedMaterial
    f_name = Sfac_L
    material_property_names = 'sig_LV sig_LS sig_VS'
    function = 'sig_VS - sig_LV - sig_LS'
  [../]

  [./Sfac_V]
    type = ParsedMaterial
    f_name = Sfac_V
    material_property_names = 'sig_LV sig_LS sig_VS'
    function = 'sig_LS - sig_LV - sig_VS'
  [../]

  [./Sfac_S]
    type = ParsedMaterial
    f_name = Sfac_S
    material_property_names = 'sig_LV sig_LS sig_VS'
    function = 'sig_LV - sig_LS - sig_VS'
  [../]

  [./doublewell_LVtw]
    type = DerivativeParsedMaterial
    f_name = fLV_tw
    material_property_names = 'dwh_LV twh_factor'
    args = 'cL cV cS'
    function = 'dwh_LV*cL^2*cV^2 + twh_factor*dwh_LV*cL^2*cV^2*cS^2'
  [../]

  [./doublewell_LStw]
    type = DerivativeParsedMaterial
    f_name = fLS_tw
    material_property_names = 'dwh_LS twh_factor dwh_LV'
    args = 'cL cV cS'
    function = 'dwh_LS*cL^2*cS^2 + twh_factor*dwh_LV*cL^2*cV^2*cS^2'
  [../]

  [./doublewell_VStw]
    type = DerivativeParsedMaterial
    f_name = fVS_tw
    material_property_names = 'dwh_VS twh_factor dwh_LV'
    args = 'cL cV cS'
    function = 'dwh_VS*cV^2*cS^2 + twh_factor*dwh_LV*cL^2*cV^2*cS^2'
  [../]

  [./doublewell_LV]
    type = DerivativeParsedMaterial
    f_name = fLV
    material_property_names = 'sig_LV'
    args = 'cL cV'
    function = 'sig_LV*cL^2*cV^2'
    # function = 'dwh_LV*cL*(1-cL)*cV*(1-cV)'
    # function = 'dwh_LV*(1-cL)^2*(1-cV)^2'
    # function = '0.5*dwh_LV*(cL^2*(1-cL)^2 + cV^2*(1-cV)^2)'
  [../]

  [./doublewell_LS]
    type = DerivativeParsedMaterial
    f_name = fLS
    material_property_names = 'sig_LS'
    args = 'cL cS'
    function = 'sig_LS*cL^2*cS^2'
    # function = 'dwh_LS*cL*(1-cL)*cS*(1-cS)'
    # function = 'dwh_LS*(1-cL)^2*(1-cS)^2'
    # function = '0.5*dwh_LS*(cL^2*(1-cL)^2 + cS^2*(1-cS)^2)'
  [../]

  [./doublewell_VS]
    type = DerivativeParsedMaterial
    f_name = fVS
    material_property_names = 'sig_VS'
    args = 'cV cS'
    function = 'sig_VS*cV^2*cS^2'
    # function = 'dwh_VS*cV*(1-cV)*cS*(1-cS)'
    # function = 'dwh_VS*(1-cV)^2*(1-cS)^2'
    # function = '0.5*dwh_VS*(cV^2*(1-cV)^2 + cS^2*(1-cS)^2)'
  [../]

  [./triple_height]
    type = ParsedMaterial
    f_name = Lambda
    # material_property_names = 'dwh_LV dwh_LS dwh_VS'
    # function = 'max(dwh_LV,max(dwh_LS,dwh_VS))'
    material_property_names = 'sig_LV sig_LS sig_VS'
    function = 'max(sig_LV, max(sig_LS,sig_VS))'
  [../]

  [./doublewell_f0]
    type = DerivativeParsedMaterial
    f_name = f0
    material_property_names = 'Sfac_L Sfac_V Sfac_S fLV(cL,cV) fLS(cL,cS) fVS(cV,cS)'
    args = 'cL cV cS'
    function = 'fLV + fLS + fVS - cL*cV*cS*(Sfac_L*cL + Sfac_V*cV + Sfac_S*cS)'
  [../]

  [./doublewell_ptriple]
    type = DerivativeParsedMaterial
    f_name = ptriple
    material_property_names = 'Lambda'
    args = 'cL cV cS'
    function = '0 * Lambda * cL^2 * cV^2 * cS^2'
  [../]

  [./doublewell_all]
    type = DerivativeParsedMaterial
    f_name = fDW
    material_property_names = 'f0(cL,cV,cS) ptriple(cL,cV,cS)'
    args = 'cL cV cS'
    function = 'f0 + ptriple'
  [../]

  [./MLV]
    type = ParsedMaterial
    f_name = MLV
    material_property_names = 'M'
    args = 'cL'
    function = 'if(cL>1e-5,if(cL<1-1e-5, M,0),0)'
  [../]

  [./ML]
    type = ParsedMaterial
    f_name = ML
    material_property_names = 'M Sfac_L'
    function = '-M/Sfac_L'
  [../]

  [./MV]
    type = ParsedMaterial
    f_name = MV
    material_property_names = 'M Sfac_V'
    function = '-M/Sfac_V'
  [../]

  [./S_T]
    type = ParsedMaterial
    f_name = S_T
    material_property_names = 'Sfac_L Sfac_V'
    function = '-Sfac_L*Sfac_V/(Sfac_L + Sfac_V)'
  [../]

  [./S_VS]
    type = ParsedMaterial
    f_name = S_VS
    material_property_names = 'S_T e Sfac_V Sfac_S'
    function = '(4 * S_T / e) * (-1/Sfac_V - 1/Sfac_S)'
  [../]

  [./S_LS]
    type = ParsedMaterial
    f_name = S_LS
    material_property_names = 'S_T e Sfac_L Sfac_S'
    function = '(4 * S_T / e) * (-1/Sfac_L - 1/Sfac_S)'
  [../]

  [./S_LV]
    type = ParsedMaterial
    f_name = S_LV
    material_property_names = 'S_T e Sfac_L Sfac_V'
    function = '(4 * S_T / e) * (-1/Sfac_L -1/Sfac_V)'
  [../]

  [./Sinv_L]
    type = ParsedMaterial
    f_name = Sinv_L
    material_property_names = 'S_T e Sfac_L'
    function = '(12 / e) * (1 + S_T/Sfac_L)'
  [../]

  [./Sinv_V]
    type = ParsedMaterial
    f_name = Sinv_V
    material_property_names = 'S_T e Sfac_V'
    function = '(12 * S_T / e) * 1/Sfac_V'
  [../]

  # [./Sinv_S]
  #   type = ParsedMaterial
  #   f_name = Sinv_S
  #   material_property_names = 'S_T e Sfac_S'
  #   function = '(4 * S_T / e) * 1/Sfac_S'
  # [../]

  [./eps_Sig_L]
    type = ParsedMaterial
    f_name = eps_Sig_L
    material_property_names = 'e Sfac_L'
    function = '-(3/4) * e * Sfac_L'
  [../]

  # [./eps_Sig_V]
  #   type = ParsedMaterial
  #   f_name = eps_Sig_V
  #   material_property_names = 'e Sfac_V'
  #   function = '-(3/4) * e * Sfac_V'
  # [../]

  [./eps_Sig_S]
    type = ParsedMaterial
    f_name = eps_Sig_S
    material_property_names = 'e S_T'
    function = '-(3/4) * e * S_T'
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  #  type = FDP
  #  full = true
  # Use with solve_type = NEWTON in Executioner block
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = 'bjacobi  gmres     30'  # default is 30, the higher the higher resolution but the slower
  [../]
[]


[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu          '
  #petsc_options_iname = '-pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      1'

  #petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  #petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 50
  l_tol = 1e-5
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  dtmax = 1
  #end_time = 20.0
  #end_time = 2000.0

  # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 2
  #   max_h_level = 2
  #   refine_fraction = 0.95
  #   coarsen_fraction = 0.10
  #   weight_names =  'cL cV cS'
  #   weight_values = '1  1  1'
  #
  # [../]
[]

[Outputs]
  exodus = true
  # interval = 20
[]
