interwidth = 0.28 #Target full-interfacial Width (in mm) - 7-element-width
# interwidth = 0.20 #Target full-interfacial Width (in mm) - 5-element-width
pi = 3.141592
eps = 0.0001
delta = 0.05

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 12
  ny = 8
  # nx = 200
  # ny = 200
  xmax = 7.6      # dx(=0.04) * nx * 2^(max_h_level)
  ymax = 5.12    # dy(=0.04) * ny * 2^(max_h_level)
  #type = FileMesh
  #file = notch.msh
  elem_type = QUAD4
  # uniform_refine = 3
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
  [./peq]
    order = FIRST
    family = MONOMIAL
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
  # [./Box_dist_zero]
  #   type = BoundingBoxIC
  #   variable = dist_zero
  #   x1 = 40
  #   x2 = 60
  #   y1 = 40
  #   y2 = 60
  #   inside = 1
  #   outside = -1
  # [../]
  # [./Box_dist]
  #   type = BoundingBoxIC
  #   variable = dist
  #   x1 = 40
  #   x2 = 60
  #   y1 = 40
  #   y2 = 60
  #   inside = 1
  #   outside = -1
  # [../]
  [./Image_dist_zero]
    type = FunctionIC
    variable = dist_zero
    # function = FlatSlab
    # function = TheSurface
    function = bilevel
    # function = boxcar_from_image
  [../]
  [./Image_dist]
    type = FunctionIC
    variable = dist
    # function = FlatSlab
    # function = TheSurface
    function = bilevel_dist
    # function = boxcar_from_image
  [../]
[]

[Functions]
  [./boxcar_from_image]
    type = ImageFunction
    # file_base = sharklet_images_stack/shkstack
    file = './boxcar.png'
    # file_suffix = png
    # file_range = '0 255'
    component = 0
    scale = 0.00392156862
  [../]
  [./One]
    type = ParsedFunction
    value = 1
  [../]
  [./bilevel]
    type = LinearCombinationFunction
    functions = 'One boxcar_from_image'
    w =         '-1  2'
  [../]
  [./bilevel_dist]
    type = LinearCombinationFunction
    functions = 'bilevel'
    w =         '${delta}'
  [../]
[]

[AuxKernels]
  [./time]
    type = FunctionAux
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
  [./Equil_p_from_material]
    type = MaterialRealAux
    variable = peq
    property = equil_phi
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
    mob_name = Lop
    epsilon = 0.0001
  [../]

  [./smoothing]
    type = ACInterface
    variable = dist
    kappa_name = diffuse_parameter
    mob_name = Lop
  [../]

  [./dist_ACsmoothing_grad]
    type = ACInterface
    variable = dist
    kappa_name = kappa_VS_ACsmoothing
    mob_name = Mop
  [../]
  [./dist_ACsmoothing_dw]
    type = AllenCahn
    variable = dist
    f_name = fVS_ACsmoothing
    mob_name = Mop
  [../]

  [./dist_zero_ACsmoothing_grad]
    type = ACInterface
    variable = dist_zero
    kappa_name = kappa_VS_ACsmoothing
    mob_name = Mop
  [../]
  [./dist_zero_ACsmoothing_dw]
    type = AllenCahn
    variable = dist_zero
    f_name = fVS_ACsmoothing_d0
    mob_name = Mop
  [../]

[]

[Materials]
  [./diffuse_param]
    type = GenericConstantMaterial
    prop_names = 'L diffuse_parameter M'
    prop_values = '1  0.005            1e5'
  [../]
  [./Lop]
    type = ParsedMaterial
    f_name = Lop
    material_property_names = 'L'
    args = 'time'
    function = 'if(time >= 0, L, 0)'
  []
  [./Mop]
    type = ParsedMaterial
    f_name = Mop
    material_property_names = 'M'
    args = 'time'
    function = 'if(time < 0, M, 0)'
  []
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
    function = '2*dwh_VS*ABScV*ABScS*${delta}'
    derivative_order = 2
  [../]
  [./abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV
    args = 'dist'
    # function = '(sqrt(cV^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9/. + (${eps})^2) - ${eps})'
    function = 'if(${delta}-dist >= 0, ${delta}-dist, 0.5*(${delta}-dist)*(${delta}-dist + 2*${eps})/${eps})'
    derivative_order = 2
  [../]
  [./abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS
    args = 'dist'
    # function = '(sqrt(cS^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9. + (${eps})^2) - ${eps})'
    # function = 'if(1+dist >= 0, 1+dist, 0.5*(1+dist)*(1+dist + 2*${eps})/${eps})'
    function = 'if(${delta}+dist >= 0, ${delta}+dist, 0.5*(${delta}+dist)*(${delta}+dist + 2*${eps})/${eps})'
    derivative_order = 2
  [../]

  [./d0_doublewell_ACsmoothing]
    type = DerivativeParsedMaterial
    f_name = fVS_ACsmoothing_d0
    material_property_names = 'dwh_VS ABScS_d0(dist_zero) ABScV_d0(dist_zero)'
    args = 'dist_zero'
    # function = '0.5*dwh_VS*(sqrt((1-cS)^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = '2*dwh_VS*ABScV_d0*ABScS_d0'
    derivative_order = 2
  [../]
  [./d0_abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV_d0
    args = 'dist_zero'
    # function = '(sqrt(cV^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9/. + (${eps})^2) - ${eps})'
    function = 'if(1-dist_zero >= 0, 1-dist_zero, 0.5*(1-dist_zero)*(1-dist_zero + 2*${eps})/${eps})'
    derivative_order = 2
  [../]
  [./d0_abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS_d0
    args = 'dist_zero'
    # function = '(sqrt(cS^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9. + (${eps})^2) - ${eps})'
    # function = 'if(1+dist >= 0, 1+dist, 0.5*(1+dist)*(1+dist + 2*${eps})/${eps})'
    function = 'if(1+dist_zero >= 0, 1+dist_zero, 0.5*(1+dist_zero)*(1+dist_zero + 2*${eps})/${eps})'
    derivative_order = 2
  [../]

  [./Equil_phi]
    type = ParsedMaterial
    f_name = equil_phi
    args = 'dist'
    function = 'if(dist > ${interwidth}/2 , 1 , if(dist <= ${interwidth}/2, if(dist >= -${interwidth}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth}), 0), 0))'
    outputs = exodus
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
  scheme = bdf2
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

  dt = 0.01
  dtmax = 0.01

  [./Adaptivity]
    initial_adaptivity = 5
    max_h_level = 5
    refine_fraction = 0.99
    coarsen_fraction = 0.001
    weight_names =  'dist'
    weight_values = '1'
  [../]
  start_time = -0.1
[]

[Outputs]
  exodus = true
  sync_times = '0'
[]
