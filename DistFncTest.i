

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
[]

[Variables]
  [./dist_zero]
    order = FIRST
    family = LAGRANGE
  [../]

  [./dist]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./ddist_x]
    order = FIRST
    family = MONOMIAL
  [../]
  [./ddist_y]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[ICs]
  [./Circle_dist_zero]
    type = SmoothCircleIC
    variable = dist_zero
    x1 = 50
    y1 = 50
    radius = 10
    int_width = 4
    invalue = 1.0
    outvalue = -1.0
  [../]

  [./Circle_dist_op]
    type = SmoothCircleIC
    variable = dist
    x1 = 50
    y1 = 50
    radius = 10
    int_width = 4
    invalue = 1.0
    outvalue = -1.0
  [../]
[]

[AuxKernels]
  [./get_dpx]
    type = VariableGradientComponent
    variable = ddist_x
    gradient_variable = dist
    component = x
    execute_on = LINEAR
  [../]
  [./get_dpy]
    type = VariableGradientComponent
    variable = ddist_y
    gradient_variable = dist
    component = y
    execute_on = LINEAR
  [../]
[]

[Kernels]
  [./TimeDerivative_dist_zero]
    type = TimeDerivative
    variable = dist_zero
  [../]

  [./TimeDerivative_dist]
    type = TimeDerivative
    variable = dist
  [../]

  [./dist_function]
    type = DistanceFunction
    variable = dist
    bilevel_data = dist_zero
    epsilon = 0.01
  [../]
[]

[Preconditioning]
  #active = ''
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  l_max_its = 20
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          '

  dt = 0.1
  dtmax = 0.1

  # [./Adaptivity]
  #   initial_adaptivity = 3
  #   max_h_level = 3
  #   refine_fraction = 0.95
  #   coarsen_fraction = 0.10
  #   weight_names = 'dist'
  #   weight_values = '1.0'
  # [../]
[]

[Outputs]
  exodus = true
[]
