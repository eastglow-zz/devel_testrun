

#Forward split method

interwidth = 5 #Target full-interfacial Width
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
    args = 'cL cV'
    constant_names =       'coidxL coidxV'
    constant_expressions = '0      1'
    function = 'coidxL*cL + coidxV*cV'
  [../]
  [./cV_update]
    type = ParsedAux
    variable = cV_constrained
    args = 'cL'
    function = '1 - cL'
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

  [./wL]
    order = FIRST
    family = LAGRANGE
  [../]

  [./wV]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./cL_IC]
    type = FunctionIC
    variable = cL
    function = TheEllipseSharp
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
[]

[Functions]
  [./OneConst]
    type = ConstantFunction
    value = 1
  [../]
  [./TheCircle]
    type = ParsedFunction
    vars = 'x0 y0 r0'
    vals = '50 50 20'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5-0.5*tanh(0.5*${alpha}*(r-r0)/${interwidth})'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  [./TheEllipseSharp]
    type = ParsedFunction
    vars = 'x0 y0 A B'
    vals = '50 50 25 15'
    value = 'r:=sqrt(((x-x0)/A)^2+((y-y0)/B)^2);if(r<=1,1,0)'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  [./FlatSlab]
    type = ParsedFunction
    vars = 'y0'
    vals = '10'
    value = '0.5-0.5*tanh(0.5*${alpha}*(y-y0)/${interwidth})'
  [../]
  [./Background]
    type = LinearCombinationFunction
    functions = 'OneConst TheEllipseSharp'
    w =         '1        -1'
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
    kappa_name = M
    mob_name = One
  [../]
  [./cL_divgradwV_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wV
    kappa_name = M
    mob_name = negOne
  [../]

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
  [./wL_lap_cV_term]
    type = CoupledCrossGradEnergy
    variable = wL
    chempot_comp_cname = 'cL'
    c_names = 'cV'
    kappa_names = 'kappa_LV'
    mobility_name = One
    prefactor = 1.0
  [../]

  [./wL_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fBulk
    args = 'cL cV'
    mob_name = One
  [../]

  # [./wL_doublewell_L_term]
  #   type = CoupledCrossBulkEnergy
  #   variable = wL
  #   chempot_comp_cname = cL
  #   c_names = 'cV'
  #   fbulk_name = fBulk
  #   # args = 'cV'
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
  [./cVdot_constraint_L]
    type = CoefCoupledTimeDerivative
    variable = cV
    v = cL
    coef = 1
  [../]

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
  [./wV_lap_cL_term]
    type = CoupledCrossGradEnergy
    variable = wV
    chempot_comp_cname = 'cV'
    c_names = 'cL'
    kappa_names = kappa_LV
    mobility_name = One
    prefactor = 1.0
  [../]
  [./wV_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wV
    v = cV
    f_name = fBulk
    args = 'cL cV'
    mob_name = One
  [../]
  # [./wV_doublewell_V_term]
  #   type = CoupledCrossBulkEnergy
  #   variable = wV
  #   chempot_comp_cname = cV
  #   c_names = 'cL'
  #   fbulk_name = fBulk
  #   # args = 'cV'
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

[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV M One negOne twh_factor'
    prop_values = '1     1 1   -1     0'
  [../]

  [./kappa_LV]
    type = ParsedMaterial
    f_name = kappa_LV
    material_property_names = 'sig_LV'
    function = '6*sig_LV*${interwidth}/${alpha}'
  [../]

  [./dwh_LV]
    type = ParsedMaterial
    f_name = dwh_LV
    material_property_names = 'sig_LV'
    function = '3*${alpha}*sig_LV/${interwidth}'
  [../]

  [./doublewell_LV]
    type = DerivativeParsedMaterial
    f_name = fLV
    material_property_names = 'dwh_LV'
    args = 'cL cV'
    function = 'dwh_LV*cL^2*cV^2'
    # function = 'dwh_LV*cL*(1-cL)*cV*(1-cV)'
    # function = 'dwh_LV*(1-cL)^2*(1-cV)^2'
    # function = '0.5*dwh_LV*(cL^2*(1-cL)^2 + cV^2*(1-cV)^2)'
  [../]

  [./MLV]
    type = ParsedMaterial
    f_name = MLV
    material_property_names = 'M'
    args = 'cL'
    function = 'if(cL>1e-5,if(cL<1-1e-5, M,0),0)'
  [../]

  [./fBulk]
    type = DerivativeParsedMaterial
    f_name = fBulk
    material_property_names = 'dwh_LV'
    args = 'cL cV'
    # function = '0.5*gmb*(cL*cSc*cL*cSc) + 0.5*gmm*(cL*cV*cL*cV) + 0.5*gmm*(cV*cSc*cV*cSc) + mu*((0.25*cL^4-0.5*cL^2) + (0.25*cV^4-0.5*cV^2) + (0.25*cSc^4-0.5*cSc^2))'
    # function = 'dwh_LV*cL*(1-cL)*cV*(1-cV)'
    function = 'dwh_LV*(cL^2*cV^2)'
    # function = '0.5*gmm*(cL^2*cV^2)'
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
  # petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu          '
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
    dt = 1e-6
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


[Postprocessors]
  [./avg_cL]
    type = AverageNodalVariableValue
    variable = cL
    outputs = console
    execute_on = TIMESTEP_BEGIN
  [../]
[]
