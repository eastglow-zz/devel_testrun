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
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./dpx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dpy]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./get_dpx]
    type = VariableGradientComponent
    variable = dpx
    gradient_variable = p
    component = x
    execute_on = LINEAR
  [../]
  [./get_dpy]
    type = VariableGradientComponent
    variable = dpy
    gradient_variable = p
    component = y
    execute_on = LINEAR
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
  [./w_constantIC]
    type = ConstantIC
    variable = w
    value = 0.0
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
    type = CoupledForce
    variable = p
    v = w
    coef = 1
  [../]

  [./doublewell]
    type = AllenCahn
    variable = p
    f_name = f_dw
    mob_name = L
  [../]

  # w variable kernels
  [./w_itself]
    type = MassEigenKernel
    variable = w
    eigen = false
  [../]
  [./neg_delFinterface_delp]
    type = dFdGradCoupledVarDevel
    variable = w
    fgrad_name = f_grad
    gradient_component_names = 'dpx dpy'
    prefactor = -1
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
  [./grad_density_function]
    type = DerivativeParsedMaterial
    f_name = f_grad
    args = 'dpx dpy'
    constant_names = 'kappa'
    constant_expressions = '10'
    function = '0.5*kappa*(dpx^2 + dpy^2)'
    outputs = exodus
  [../]
  [./mob_name]
    type = ParsedMaterial
    f_name = L
    function = '1'
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
