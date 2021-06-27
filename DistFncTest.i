interwidth = 0.28 #Target full-interfacial Width (in mm) - 7-element-width
# interwidth = 0.20 #Target full-interfacial Width (in mm) - 5-element-width
pi = 3.141592
eps = 0.0001

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
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
  [./time]
  [../]
[]

[ICs]
  # [./Circle_dist_zero]
  #   type = SmoothCircleIC
  #   variable = dist_zero
  #   x1 = 50
  #   y1 = 50
  #   radius = 20
  #   int_width = 2
  #   invalue = 1.0
  #   outvalue = -1.0
  # [../]
  #
  # [./Circle_dist_op]
  #   type = SmoothCircleIC
  #   variable = dist
  #   x1 = 50
  #   y1 = 50
  #   radius = 20
  #   int_width = 9
  #   invalue = 1.0
  #   outvalue = -1.0
  # [../]
  [./Box_dist_zero]
    type = BoundingBoxIC
    variable = dist_zero
    x1 = 40
    x2 = 60
    y1 = 40
    y2 = 60
    inside = 1
    outside = -1
  [../]
  [./Box_dist]
    type = BoundingBoxIC
    variable = dist
    x1 = 40
    x2 = 60
    y1 = 40
    y2 = 60
    inside = 1
    outside = -1
  [../]
[]

[AuxKernels]
  [./time]
    type = ParsedAux
    variable = time
    function = t
  [../]
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

  [./smoothing]
    type = ACInterface
    variable = dist
    kappa_name = diffuse_parameter
    mob_name = L
  [../]

  [./cS_ACsmoothing_grad]
    type = ACInterface
    variable = dist
    kappa_name = kappa_VS_ACsmoothing
    mob_name = M
  [../]
  [./cS_ACsmoothing_dw]
    type = AllenCahn
    variable = cS
    f_name = fVS_ACsmoothing
    mob_name = M
  [../]
[]

[Materials]
  [./diffuse_param]
    type = GenericConstantMaterial
    prop_names = 'L diffuse_parameter M'
    prop_values = '1  0.1             1'
  [../]
  [./Mop]
    type = ParsedMaterial
    f_name = Mop
    material_property_names = 'M'
    function = 'if(time < 0, M, 0)'
  []

  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS sig_VS One negOne'
    prop_values = '0.02e-3     0.01e-3    0.02e-3      1   -1'
    #prop_values = '1     1.866025    1      1 1   -1'
  [../]
  [./sigop_VS]
    type = ParsedMaterial
    f_name = sigop_VS
    args = 'time'
    material_property_names = 'sig_VS'
    function = 'if(time < 0, 0.01e-4, sig_VS)'
  [../]
  [./dwh_VS]
    type = ParsedMaterial
    f_name = dwh_VS
    material_property_names = 'sigop_VS'
    function = '4*sigop_VS/${interwidth}'
  [../]
  [./kappa_VS_ACsmoothing]
    type = ParsedMaterial
    f_name = kappa_VS_ACsmoothing
    material_property_names = 'sigop_VS'
    function = '2*sigop_VS*4*${interwidth}/(${pi})^2'
  [../]
  [./doublewell_ACsmoothing]
    type = DerivativeParsedMaterial
    f_name = fVS_ACsmoothing
    material_property_names = 'dwh_VS ABScS(dist) ABScV(dist)'
    args = 'dist'
    # function = '0.5*dwh_VS*(sqrt((1-cS)^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = '2*dwh_VS*ABScV*ABScS'
    derivative_order = 2
  [../]
  [./abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV
    args = 'dist'
    # function = '(sqrt(cV^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9/. + (${eps})^2) - ${eps})'
    function = 'if(1-dist >= 0, 1-dist, 0.5*(1-dist)*(1-dist + 2*${eps})/${eps})'
    derivative_order = 2
  [../]
  [./abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS
    args = 'dist'
    # function = '(sqrt(cS^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9. + (${eps})^2) - ${eps})'
    function = 'if(dist >= 0, dist, 0.5*dist*(dist + 2*${eps})/${eps})'
    derivative_order = 2
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
  solve_type = NEWTON
  scheme = explicit-euler

  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  # petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu          '
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  # petsc_options_value = 'lu superlu_dist'
  petsc_options_iname = '-pc_type -ksp_type'
  petsc_options_value = 'bjacobi  bcgs'

  dt = 0.1
  dtmax = 0.1

  [./Adaptivity]
    initial_adaptivity = 4
    max_h_level = 4
    refine_fraction = 0.95
    coarsen_fraction = 0.10
    weight_names = 'dist'
    weight_values = '1.0'
  [../]
[]

[Outputs]
  exodus = true
[]
