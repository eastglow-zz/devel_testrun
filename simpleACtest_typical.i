[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmax = 100
  ymax = 100
[]

[Variables]
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./p_circleIC]
    type = SmoothCircleIC
    variable = p
    x1 = 50
    y1 = 50
    radius = 20
    int_width = 2
    invalue = 1
    outvalue = 0
  [../]
[]

[BCs]
  #no-flux BC
[]

[Kernels]
  # p variable kernels
  [./pdot]
    type = TimeDerivative
    variable = p
  [../]

  [./w_cooupling]
    type = ACInterface
    variable = p
    mob_name = L
    kappa_name = kappa_p
  [../]

  [./doublewell]
    type = AllenCahn
    variable = p
    f_name = f_dw
    mob_name = L
  [../]
[]

[Materials]
  [./doublewell_density_function]
    type = DerivativeParsedMaterial
    f_name = f_dw
    args = 'p'
    constant_names = 'height'
    constant_expressions = '1'
    function = 'height*p^2*(1-p)^2'
    derivative_order = 2
  [../]
  [./constants]
    type = GenericConstantMaterial
    prop_names =  'kappa_p L'
    prop_values = '10      1'
  [../]
[]

[Preconditioning]
  #active = ''
  [./pw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  # petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu'
  # petsc_options_iname = '-pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm      1'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'


  l_max_its = 20
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.003
    #growth_factor = 1.2
    #cutback_factor = 0.8
    #optimal_iterations = 4
    #iteration_window = 4
  [../]
  dtmax = 0.3
  end_time = 30
[]

[Outputs]
  exodus = true
[]
