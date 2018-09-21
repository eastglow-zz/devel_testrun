[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100.0
  ymax = 100.0
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
  [./w]    #mu
    order = FIRST
    family = LAGRANGE
  [../]
  [./phi_int] #electrostatic potential
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = c
    f_name = fbulk
    kappa_name = kappa_c
    w = w
    args = 'phi_int'
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]

  [./diff]
    type = CoefDiffusion
    coef = 66.6667
    variable = phi_int
  [../]
  [./phi_int_comp]
    type = CoupledForce
    variable = phi_int
    v = c
    coef = -1
  [../]

  # [./phi_int_comp0]
  #   type = CoupledForce
  #   variable = phi_int
  #   v = c0
  #   coef = 1
  # [../]
  [./phi_int_avgc]
    type = BodyForce
    variable = phi_int
    postprocessor = avg_c
    # coef = 1
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./c0_05]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./c0_0.5]
    type = ConstantIC
    variable = c0_05
    value = 0.5
  [../]
  [./init_c]
    type = FunctionIC
    function = init_c
    variable = c
  [../]
  # [./phi_int_func]
  #   type = FunctionIC
  #   variable = phi_int
  #   function = phi_int_function
  # [../]
  # [./phi_ext_func]
  #   type = FunctionIC
  #   variable = phi_ext
  #   function = phi_ext_function
  # [../]
[]

[Functions]
  [./init_c]
    type = ParsedFunction
    value = '0.5 + 0.04*( cos(0.2*x)*cos(0.11*y) + cos(0.13*x)*cos(0.087*y) + cos(0.025*x-0.015*y)*cos(0.07*x-0.02*y))'
    # value = '0.5+0.04*(cos(0.2*x)*cos(0.11*y)+cos(0.13*x)*cos(0.087*y) + cos(0.025*x-0.05*y)*cos(0.07*x-0.02*y))'
  [../]

  [./phi_ext_function]
    type = ParsedFunction
    vars = 'A      B     C'
    vals = '0.0002 -0.01 0.02'
    value = 'A*x*y + B*x + C*y'
  [../]

  [./phi_ext_x]  #negative partial phi_ext partial x
    type = ParsedFunction
    vars = 'A      B'
    vals = '0.0002 -0.01'
    value = '-A*y - B'
  [../]

  [./phi_ext_y]  #negative partial phi_ext partial y
    type = ParsedFunction
    vars = 'A      C'
    vals = '0.0002 0.02'
    value = '-A*x -C'
  [../]

  [./bc_top]
    type = LinearCombinationFunction
    functions = 'phi_ext_x phi_ext_y'
    w =         '0          1'   #out normal vector of top boundary
  [../]
  [./bc_bottom]
    type = LinearCombinationFunction
    functions = 'phi_ext_x phi_ext_y'
    w =         '0          -1'  #out normal vector of bottom boundary
  [../]
  [./bc_left]
    type = LinearCombinationFunction
    functions = 'phi_ext_x phi_ext_y'
    w =         '-1        0'    #out normal vector of left boundary
  [../]
  [./bc_right]
    type = LinearCombinationFunction
    functions = 'phi_ext_x phi_ext_y'
    w =         '1       0'      #out normal vector of right boundary
  [../]
[]

[AuxVariables]
  # [./FEdensity]
  #   order = FIRST
  #   family = MONOMIAL
  # [../]
[]

[AuxKernels]
  # [./local_energy]
  #   type = TotalFreeEnergy
  #   variable = local_energy
  #   f_name = fbulk
  #   interfacial_vars = c
  #   kappa_names = kappa_c
  #   execute_on = timestep_end
  # [../]
[]

[MeshModifiers]
  [./interior_nodeset]
    type = BoundingBoxNodeSet
    new_boundary = node1
    bottom_left = '0 50 0'
    top_right = '0 50 0'
  [../]
[]

[BCs]
  [./noshift]
    type = DirichletBC
    variable = phi_int
    boundary = node1
    value = 0
  [../]
  [./w_Neumann]
    type = NeumannBC
    variable = w
    boundary = 'top bottom left right'
    value = 0
  [../]
  [./phi_top]
    type = FunctionNeumannBC
    function = bc_top
    variable = phi_int
    boundary = top
  [../]
  [./phi_bottom]
    type = FunctionNeumannBC
    function = bc_bottom
    variable = phi_int
    boundary = bottom
  [../]
  [./phi_left]
    type = FunctionNeumannBC
    function = bc_left
    variable = phi_int
    boundary = left
  [../]
  [./phi_right]
    type = FunctionNeumannBC
    function = bc_right
    variable = phi_int
    boundary = right
  [../]
[]

[Materials]
  [./constant]
    type = GenericConstantMaterial
    prop_names  = 'kappa_c ca   cb epsilon  k   M0  w0 c0'
    prop_values = '2.0     0.3 0.7  20     0.3  10  5 0.5'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    f_name = M
    material_property_names = 'M0'
    function = 'M0/(1+c^2)'
    args = 'c'
  [../]
  [./fbulk]
    type = DerivativeParsedMaterial
    f_name = fbulk
    material_property_names = 'w0 ca cb k phi_ext c0'
    args = 'c phi_int'
    function = 'w0*(c-ca)^2*(c-cb)^2 + 0.5*(phi_int+phi_ext)*k*(c-c0)'
    enable_jit = true
    derivative_order = 2
  [../]
  [./phi_ext]
    type = GenericFunctionMaterial
    prop_names = phi_ext
    prop_values = phi_ext_function
    outputs = exodus
  [../]
  [./phi_tot]
    type = ParsedMaterial
    f_name = phi_tot
    args = 'phi_int'
    material_property_names = 'phi_ext'
    function = 'phi_int+phi_ext'
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./avg_c]
    type = AverageNodalVariableValue
    variable = c
    outputs = console
    execute_on = TIMESTEP_BEGIN
  [../]
  # # [./total_solute]
  # #   type = ElementIntegralVariablePostprocessor
  # #   variable = c
  # # [../]
  # [./total_free_energy]
  #   type = ElementIntegralVariablePostprocessor
  #   variable = local_energy
  # [../]
  # [./Total_FE]
  #   type = ElementIntegralMaterialProperty
  #   mat_prop = f_density
  # [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  # solve_type = NEWTON
  scheme = bdf2

  # petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu'
  # petsc_options_iname = '-pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm      1'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  # l_max_its = 20
  # # l_tol = 1e-4
  # nl_max_its = 30
  # nl_rel_tol = 1e-6
  # nl_abs_tol = 1e-9

  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 30
  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-9
  [./TimeStepper]
    type = IterationAdaptiveDT
    # dt = 1e-2
    dt = 1e-5
    # growth_factor = 1.2
    # cutback_factor = 0.9
    cutback_factor = 0.5
    growth_factor = 1.8
  [../]
  dtmax = 5
  # [./Adaptivity]
  #   refine_fraction = 0.9
  #   coarsen_fraction = 0.1
  #   max_h_level = 2
  #   # weight_names = c
  #   # weight_values = 1
  # [../]
  end_time = 400
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
  print_perf_log = true
  sync_times = '5 10 20 50 100 200 400'
  # interval = 10
[]
