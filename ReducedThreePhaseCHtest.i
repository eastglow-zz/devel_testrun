

#Forward split method

interwidth = 9 #Target full-interfacial Width
alpha = 5.8889  # 2*ln(0.95/0.05)

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
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
  [./calc_cV]
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
    variable = calc_cV
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
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5-0.5*tanh(0.5*${alpha}*(r-r0)/${interwidth})'
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
    kappa_name = M
    mob_name = Two
  [../]
  [./cL_divgradwS_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wS
    kappa_name = M
    mob_name = One
  [../]

  # R_wL part
  [./wL_neg_wL_term]
    type = MassEigenKernel
    variable = wL
    eigen = false
  [../]
  [./wL_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cL
    kappa_name = kappa_LV
    mob_name = One
  [../]
  [./wL_lap_cS_LV_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cS
    kappa_name = kappa_LV
    mob_name = One
  [../]
  [./wL_lap_cS_LS_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cS
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wL_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fLV
    args = 'cL cS'
    mob_name = One
  [../]
  [./wL_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wL
    v = cS
    f_name = fLS
    args = 'cL cS'
    mob_name = One
  [../]

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

  # R_wS part
  [./wS_neg_wS_term]
    type = MassEigenKernel
    variable = wS
    eigen = false
  [../]
  [./wS_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cS
    kappa_name = kappa_VS
    mob_name = One
  [../]
  [./wS_lap_cL_LS_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cL
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wS_lap_cL_VS_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cL
    kappa_name = kappa_VS
    mob_name = One
  [../]
  [./wS_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cS
    f_name = fLS
    args = 'cL cS'
    mob_name = One
  [../]
  [./wS_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cS
    f_name = fVS
    args = 'cL cS'
    mob_name = One
  [../]

  # R_cS part
  [./cS_timederivative]
    type = TimeDerivative
    variable = cS
  [../]

  [./cV_itself]
    type = MassEigenKernel
    variable = cV
    eigen = false
  [../]
  [./cV_calc]
    type = CoupledForce
    variable = cV
    v = calc_cV
    coef = -1
  [../]

[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS sig_VS M One negOne Two negTwo'
    prop_values = '1     1      1      1 1   -1     2   -2'
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

  [./doublewell_LV]
    type = DerivativeParsedMaterial
    f_name = fLV
    material_property_names = 'dwh_LV'
    args = 'cL cS'
    function = 'dwh_LV*cL^2*(1-cL-cS)^2'
  [../]

  [./doublewell_LS]
    type = DerivativeParsedMaterial
    f_name = fLS
    material_property_names = 'dwh_LS'
    args = 'cL cS'
    function = 'dwh_LS*cL^2*cS^2'
  [../]

  [./doublewell_VS]
    type = DerivativeParsedMaterial
    f_name = fVS
    material_property_names = 'dwh_VS'
    args = 'cL cS'
    function = 'dwh_VS*(1-cL-cS)^2*cS^2'
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  #  type = FDP
  #  full = true
  [../]
[]


[Executioner]
  type = Transient
  solve_type = PJFNK
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
    dt = 1e-6
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  #end_time = 20.0
  #end_time = 2000.0
  # adaptive mesh to resolve an interface
  [./Adaptivity]
    initial_adaptivity = 2
    max_h_level = 2
    refine_fraction = 0.95
    coarsen_fraction = 0.10
    weight_names =  'cL cV cS'
    weight_values = '1  1  1'

  [../]
[]

[Outputs]
  exodus = true
[]
