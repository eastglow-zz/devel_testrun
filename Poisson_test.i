
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
[]

[Variables]
  [./c] #composition
    order = FIRST
    family = LAGRANGE
  [../]

  [./phi_int] #electrostatic potential
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./phi_ext]
    order = FIRST
    family = LAGRANGE
  [../]

  # [./c] #composition
  #   order = FIRST
  #   family = LAGRANGE
  # [../]
[]

[ICs]
  [./c_func_ic]
    type = FunctionIC
    variable = c
    # function = c_ic_function
    function = delta_function
  [../]
  # [./phi_int_zero]
  #   type = ConstantIC
  #   variable = phi_int
  #   value = 0
  # [../]
  [./phi_int_func]
    type = FunctionIC
    variable = phi_int
    function = phi_int_function
  [../]
  [./phi_ext_func]
    type = FunctionIC
    variable = phi_ext
    function = phi_ext_function
  [../]
[]

[Functions]
  [./c_ic_function]
    type = ParsedFunction
    value = '0.04*( cos(0.2*x)*cos(0.11*y) + cos(0.13*x)*cos(0.87*y) + cos(0.025*x-0.015*y)*cos(0.07*x-0.02*y))'
  [../]

  [./delta_function]
    type = ParsedFunction
    value = 'exp(-((x-50-10)^2+(y-50)^2))-exp(-((x-50+10)^2+(y-50)^2))'
  [../]

  [./phi_ext_function]
    type = ParsedFunction
    vars = 'A      B     C'
    vals = '0.0002 -0.01 0.02'
    # value = 'A*x*y + B*x + C*y'
    value = 0
  [../]
  [./OneConst]
    type = ConstantFunction
    value = 1
  [../]

  [./phi_int_function]
    type = LinearCombinationFunction
    # functions = 'OneConst TheCircle TheSurface'
    functions = 'OneConst phi_ext_function'
    w =         '0        -1'
  [../]
[]

[BCs]
  # [./phi_int_zero_normal_component]
  #   type = NeumannBC
  #   variable = phi_int
  #   boundary = 'top bottom left right'
  #   value = 0
  # [../]
  # [./phi_int_dirichlet]
  #   type = DirichletBC
  #   variable = phi_int
  #   value = 0
  #   boundary = 'top bottom left right'
  # [../]
[../]

[Kernels]
  [./c_time_derivative]
    type = TimeDerivative
    variable = c
  [../]


  [./phi_int_lap_phi_tot]
    type = CoefLaplacian
    variable = phi_int
    basefield_var = phi_ext
    M = epsilon_over_k
    prefactor = 1
  [../]

  [./phi_int_comp]
    type = CoupledForce
    variable = phi_int
    v = c
    coef = -0.015
  [../]

  # [./phi_int_TimeDerivative]
  #   type = TimeDerivative
  #   variable = phi_int
  # [../]

[]

[Materials]
  [./Constant_materials]
    type = GenericConstantMaterial
    prop_names =  'k   epsilon One negOne'
    prop_values = '0.3 20      1   -1'
  [../]

  [./epsilon_over_k]
    type = ParsedMaterial
    material_property_names = 'k epsilon'
    f_name = epsilon_over_k
    function = 'epsilon/k'
    outputs = exodus
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
  # petsc_options_value = 'asm      lu          '
  # petsc_options_iname = '-pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm      1'

  # petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 30
  l_tol = 2e-5
  nl_max_its = 20
  nl_rel_tol = 2e-8
  nl_abs_tol = 2e-8
  # line_search = 'none'

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e5
    cutback_factor = 0.5
    growth_factor = 1.8
    # optimal_iterations = 20
    # iteration_window = 5
  [../]
  #dtmax = 0.5
  #end_time = 20.0
  # start_time = -0.01
  start_time = 0.0
  #end_time = 170.0

  steady_state_detection = true
  steady_state_tolerance = 1e-08

  # # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 3
  #   max_h_level = 3
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.001
  #   weight_names =  'cL cV cS wL wV wS v_x v_y p'
  #   weight_values = '1  1  1  1  1  1  1   1   1'
  #
  # [../]


  # type = Steady

[]

[Debug]
  #show_var_residual = true
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #interval = 20
[]

[Problem]
  # kernel_coverage_check = false
[]
