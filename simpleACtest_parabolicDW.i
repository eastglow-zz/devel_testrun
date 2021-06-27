[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
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
  # # Confinement that make sure 0 <= p <= 1
  # [./p_bounded]
  #   type = Bounded
  #   variable = p
  #   v_lb = 0
  #   v_ub = 1
  # [../]

  # p variable kernels
  [./pdot]
    type = TimeDerivative
    variable = p
  [../]

  [./w_cooupling]
    type = ACInterface
    # type = ACInterfaceBounded
    variable = p
    mob_name = L
    kappa_name = kappa_p
    # v_lb = 0
    # v_ub = 1
  [../]

  [./doublewell]
    type = AllenCahn
    # type = AllenCahnBounded
    variable = p
    f_name = f_dw
    mob_name = L
    # v_lb = 0
    # v_ub = 1
  [../]
[]

[Materials]
  [./doublewell_density_function]
    type = DerivativeParsedMaterial
    f_name = f_dw
    args = 'p'
    constant_names = 'height'
    constant_expressions = '1'
    material_property_names = 'ABSp(p) ABSpcomp(p)'
    # function = 'height*p^2*(1-p)^2'
    # function = 'height*p*(1-p)'
    function = 'height * ABSp * ABSpcomp'
    derivative_order = 2
  [../]
  [./abs_p]
    type = DerivativeParsedMaterial
    f_name = ABSp
    args = 'p'
    constant_names = 'e'
    constant_expressions = '0.001'
    function = 'if(p >= 0, p, 0.5*p*(p + 2*e)/e)'
    # function = 'sqrt(p^2 + e^2) - e'
    derivative_order = 2
  [../]
  [./abs_pcompliment]
    type = DerivativeParsedMaterial
    f_name = ABSpcomp
    args = 'p'
    constant_names = 'e'
    constant_expressions = '0.001'
    function = 'if(1 - p >= 0, 1 - p, 0.5*(1-p)*((1-p) + 2*e)/e)'
    # function = 'sqrt((1-p)^2 + e^2) - e'
    derivative_order = 2
  [../]
  [./constants]
    type = GenericConstantMaterial
    prop_names =  'kappa_p L'
    prop_values = '2      1'
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
  dtmax = 1.0
  end_time = 30
[]

[Outputs]
  exodus = true
[]
