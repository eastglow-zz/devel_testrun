

#Forward split method

interwidth = 4 #Target full-interfacial Width
pi = 3.141592
eps = 0.01

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
  [./cV_constrained]
    order = FIRST
    family = LAGRANGE
  [../]

  [./dcLx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dcLy]
    order = FIRST
    family = MONOMIAL
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
  [./calc_dcLx]
    type = VariableGradientComponent
    variable = dcLx
    gradient_variable = cL
    component = x
  [../]
  [./calc_dcLy]
    type = VariableGradientComponent
    variable = dcLy
    gradient_variable = cL
    component = y
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
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);if(abs(r-r0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(r-r0)/${interwidth}), if(r-r0 <= -0.5*${interwidth}, 1, 0))'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  [./FlatSlab]
    type = ParsedFunction
    vars = 'y0'
    vals = '10'
    value = 'if(abs(y-y0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(y-y0)/${interwidth}), if(y-y0 <= -0.5*${interwidth}, 1, 0))'
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
  [./wL_lap_cV_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cV
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wL_lap_cS_term]
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
    f_name = fLV_LO
    args = 'cL cV'
    mob_name = One
  [../]
  [./wL_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fLS_LO
    args = 'cL cS'
    mob_name = One
  [../]

  #R_cV part
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

  # Calc. cV from the constraint; cL + cV + cS = 1
  [./cV_itself]
    type = MassEigenKernel
    variable = cV
    eigen = false
  [../]
  [./cV_constraint]
    type = CoupledForce
    variable = cV
    v = cV_constrained
    coef = -1
  [../]

  # R_wV part
  [./wV_neg_wV_term]
    type = MassEigenKernel
    variable = wV
    eigen = false
  [../]
  [./wV_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wV
    v = cL
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wV_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wV
    v = cS
    kappa_name = kappa_VS
    mob_name = negOne
  [../]
  [./wV_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wV
    v = cV
    f_name = fLV_LO
    args = 'cL cV'
    mob_name = One
  [../]
  [./wV_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wV
    v = cV
    f_name = fVS_LO
    args = 'cV cS'
    mob_name = One
  [../]

  # R_cS part
  [./cS_timederivative]
    type = TimeDerivative
    variable = cS
  [../]

[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS      sig_VS M One negOne'
    prop_values = '1     1    1      1 1   -1'
  [../]

  [./kappa_LV]
    type = ParsedMaterial
    f_name = kappa_LV
    material_property_names = 'sig_LV'
    function = 'sig_LV*4*${interwidth}/(${pi})^2'
  [../]

  [./kappa_LS]
    type = ParsedMaterial
    f_name = kappa_LS
    material_property_names = 'sig_LS'
    function = 'sig_LS*4*${interwidth}/(${pi})^2'
  [../]

  [./kappa_VS]
    type = ParsedMaterial
    f_name = kappa_VS
    material_property_names = 'sig_VS'
    function = 'sig_VS*4*${interwidth}/(${pi})^2'
  [../]

  [./dwh_LV]
    type = ParsedMaterial
    f_name = dwh_LV
    material_property_names = 'sig_LV'
    function = '2*sig_LV/${interwidth}'
  [../]

  [./dwh_LS]
    type = ParsedMaterial
    f_name = dwh_LS
    material_property_names = 'sig_LS'
    function = '2*sig_LS/${interwidth}'
  [../]

  [./dwh_VS]
    type = ParsedMaterial
    f_name = dwh_VS
    material_property_names = 'sig_VS'
    function = '2*sig_VS/${interwidth}'
  [../]

  [./doublewell_LVtw]
    type = DerivativeParsedMaterial
    f_name = fLV_LO
    material_property_names = 'dwh_LV'
    args = 'cL cV'
    function = 'dwh_LV*(sqrt(cL^2+(${eps})^2)-${eps})*(sqrt(cV^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_LStw]
    type = DerivativeParsedMaterial
    f_name = fLS_LO
    material_property_names = 'dwh_LS'
    args = 'cL cS'
    function = 'dwh_LS*(sqrt(cL^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_VStw]
    type = DerivativeParsedMaterial
    f_name = fVS_LO
    material_property_names = 'dwh_VS'
    args = 'cV cS'
    function = 'dwh_VS*(sqrt(cV^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./triple_well]
    type = DerivativeParsedMaterial
    f_name = ftriple
    constant_names = 'triple_height'
    constant_expressions = '25'
    material_property_names = 'dwh_LV dwh_LS dwh_VS'
    args = 'cL cV cS'
    function = 'triple_height*max(dwh_LV,max(dwh_LS,dwh_VS))*(sqrt(cL^2+(${eps})^2)-${eps})*(sqrt(cV^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    derivative_order = 2
    #outputs = exodus
  [../]

  [./MLV]
    type = ParsedMaterial
    f_name = MLV
    material_property_names = 'M'
    args = 'dcLx dcLy'
    function = 'if(sqrt(dcLx^2+dcLy^2)> 1e-5,M,0)'
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
  l_tol = 2e-5
  nl_max_its = 20
  nl_rel_tol = 2e-8
  nl_abs_tol = 2e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-6
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  #dtmax = 1
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

[Debug]
  #show_var_residual = true
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #interval = 20
[]
