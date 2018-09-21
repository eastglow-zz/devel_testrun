# As of 7th Aug 2018, This input file has bad convergence.

#Forward split method

# Units:
#  Length: mm
#  Time: ms
#  Mass: g

interwidth = 0.16 #Target full-interfacial Width (in mm) - 4-element-width
pi = 3.141592
eps = 0.01

ML0 = 0.1
MV0 = 0.1
MS0 = 0.1

rlx_time = 0.01

[Mesh]
  type = GeneratedMesh
  dim = 2
  # nx = 25
  # ny = 25
  nx = 200
  ny = 200
  xmax = 8
  ymax = 8
  #type = FileMesh
  #file = notch.msh
[]

[AuxVariables]
  [./cL] #phase field of Liquid phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./cV] #phase field of Vapor phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./cS] #phase field of Solid phase
    order = FIRST
    family = LAGRANGE
  [../]

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

  [./time]
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

  [./time]
    type = FunctionAux
    variable = time
    function = t
  [../]
[]

[Variables]
  [./wL] #chemical potential of Liquid phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./wV] #chemical potential of Vapor phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./wS] #chemical potential of Solid phase - used for calculating interfacial force
    order = FIRST
    family = LAGRANGE
  [../]

  [./cLop] #phase field of Liquid phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./cVop] #phase field of Vapor phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./cSop] #phase field of Solid phase
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
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
    vals = '4  5  1'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);if(abs(r-r0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(r-r0)/${interwidth}), if(r-r0 <= -0.5*${interwidth}, 1, 0))'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  # [./FlatSlab]
  #   type = ParsedFunction
  #   vars = 'y0'
  #   vals = '1'
  #   value = 'if(abs(y-y0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(y-y0)/${interwidth}), if(y-y0 <= -0.5*${interwidth}, 1, 0))'
  # [../]
  [./TheSurface]
    type = RepeatedBoxcarFunction2D
    xs = 0.25
    ys = 0.5
    nbumps = 8
    pitch_length = 1
    bump_height = 0.5
    diffusive_length = 0.0001
    above_value = 0
    below_value = 1
  [../]
  [./Background]
    type = LinearCombinationFunction
    functions = 'OneConst TheCircle TheSurface'
    w =         '1        -1        -1'
  [../]
[]

[BCs]
[]

[Kernels]
  [./cLop_itself]
    type = MassEigenKernel
    variable = cLop
    eigen = false
  [../]
  [./cL_fromMaster]
    type = CoupledForce
    variable = cLop
    v = cL
    coef = -1
  [../]

  [./cVop_itself]
    type = MassEigenKernel
    variable = cVop
    eigen = false
  [../]
  [./cV_fromMaster]
    type = CoupledForce
    variable = cVop
    v = cV
    coef = -1
  [../]

  [./cSop_itself]
    type = MassEigenKernel
    variable = cSop
    eigen = false
  [../]
  [./cS_fromMaster]
    type = CoupledForce
    variable = cSop
    v = cS
    coef = -1
  [../]

  # Chemical potential equation parts
  # R_wL part
  [./wL_neg_wL_term]
    type = MassEigenKernel
    variable = wL
    eigen = false
  [../]
  [./wL_lap_cV_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cVop
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wL_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cSop
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wL_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wL
    v = cLop
    f_name = fLV_LO
    args = 'cLop cVop'
    mob_name = One
  [../]
  [./wL_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wL
    v = cLop
    f_name = fLS_LO
    args = 'cLop cSop'
    mob_name = One
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
    v = cLop
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wV_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wV
    v = cSop
    kappa_name = kappa_VS
    mob_name = negOne
  [../]
  [./wV_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wV
    v = cVop
    f_name = fLV_LO
    args = 'cLop cVop'
    mob_name = One
  [../]
  [./wV_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wV
    v = cVop
    f_name = fVS_LO
    args = 'cVop cSop'
    mob_name = One
  [../]

  # R_wS part
  [./wS_neg_wS_term]
    type = MassEigenKernel
    variable = wS
    eigen = false
  [../]
  [./wS_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cLop
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wS_lap_cV_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cVop
    kappa_name = kappa_VS
    mob_name = negOne
  [../]
  [./wS_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cSop
    f_name = fLS_LO
    args = 'cLop cSop'
    mob_name = One
  [../]
  [./wS_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cSop
    f_name = fVS_LO
    args = 'cVop cSop'
    mob_name = One
  [../]
[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS sig_VS One negOne'
    prop_values = '1     1.5    1      1   -1'
    #prop_values = '1     1.866025    1      1 1   -1'
  [../]

  [./sigop_LV]
    type = ParsedMaterial
    f_name = sigop_LV
    args = 'time'
    material_property_names = 'sig_LV'
    function = 'if(time < ${rlx_time}, 0.01, sig_LV)'
  [../]
  [./sigop_LS]
    type = ParsedMaterial
    f_name = sigop_LS
    args = 'time'
    material_property_names = 'sig_LS'
    function = 'if(time < ${rlx_time}, 0.01, sig_LS)'
  [../]
  [./sigop_VS]
    type = ParsedMaterial
    f_name = sigop_VS
    args = 'time'
    material_property_names = 'sig_VS'
    function = 'if(time < ${rlx_time}, 0.01, sig_VS)'
  [../]

  [./Operation_mobility_L]
    type = ParsedMaterial
    f_name = ML
    function = '${ML0}'
  [../]
  [./Operation_mobility_V]
    type = ParsedMaterial
    f_name = MV
    function = '${MV0}'
  [../]
  [./Operation_mobility_S]
    type = ParsedMaterial
    f_name = MS
    args = 'time'
    function = 'if(time < ${rlx_time}, ${MS0}, 0)'
  [../]

  [./Mutual_mobilities_LV]
    type = ParsedMaterial
    f_name = mLV
    material_property_names = 'ML MV MS'
    function = 'ML*MV/(ML+MV+MS)'
  [../]

  [./Mutual_mobilities_LS]
    type = ParsedMaterial
    f_name = mLS
    material_property_names = 'ML MV MS'
    function = 'ML*MS/(ML+MV+MS)'
  [../]

  [./Mutual_mobilities_VS]
    type = ParsedMaterial
    f_name = mVS
    material_property_names = 'ML MV MS'
    function = 'MV*MS/(ML+MV+MS)'
  [../]

  [./Self_mobilities_L]
    type = ParsedMaterial
    f_name = mpL
    material_property_names = 'ML MV MS'
    function = 'ML - ML*ML/(ML+MV+MS)'
  [../]

  [./Self_mobilities_V]
    type = ParsedMaterial
    f_name = mpV
    material_property_names = 'ML MV MS'
    function = 'MV - MV*MV/(ML+MV+MS)'
  [../]

  [./Self_mobilities_S]
    type = ParsedMaterial
    f_name = mpS
    material_property_names = 'ML MV MS'
    function = 'MS - MS*MS/(ML+MV+MS)'
  [../]

  [./kappa_LV]
    type = ParsedMaterial
    f_name = kappa_LV
    material_property_names = 'sigop_LV'
    function = 'sigop_LV*4*${interwidth}/(${pi})^2'
  [../]

  [./kappa_LS]
    type = ParsedMaterial
    f_name = kappa_LS
    material_property_names = 'sigop_LS'
    function = 'sigop_LS*4*${interwidth}/(${pi})^2'
  [../]

  [./kappa_VS]
    type = ParsedMaterial
    f_name = kappa_VS
    material_property_names = 'sigop_VS'
    function = 'sigop_VS*4*${interwidth}/(${pi})^2'
  [../]

  [./dwh_LV]
    type = ParsedMaterial
    f_name = dwh_LV
    material_property_names = 'sigop_LV'
    function = '4*sigop_LV/${interwidth}'
  [../]

  [./dwh_LS]
    type = ParsedMaterial
    f_name = dwh_LS
    material_property_names = 'sigop_LS'
    function = '4*sigop_LS/${interwidth}'
  [../]

  [./dwh_VS]
    type = ParsedMaterial
    f_name = dwh_VS
    material_property_names = 'sigop_VS'
    function = '4*sigop_VS/${interwidth}'
  [../]

  [./doublewell_LVtw]
    type = DerivativeParsedMaterial
    f_name = fLV_LO
    material_property_names = 'dwh_LV'
    args = 'cLop cVop'
    function = 'dwh_LV*(sqrt(cLop^2+(${eps})^2)-${eps})*(sqrt(cVop^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_LStw]
    type = DerivativeParsedMaterial
    f_name = fLS_LO
    material_property_names = 'dwh_LS'
    args = 'cLop cSop'
    function = 'dwh_LS*(sqrt(cLop^2+(${eps})^2)-${eps})*(sqrt(cSop^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_VStw]
    type = DerivativeParsedMaterial
    f_name = fVS_LO
    material_property_names = 'dwh_VS'
    args = 'cVop cSop'
    function = 'dwh_VS*(sqrt(cVop^2+(${eps})^2)-${eps})*(sqrt(cSop^2+(${eps})^2)-${eps})'
    #outputs = exodus
    derivative_order = 2
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
  type = Steady
  solve_type = PJFNK
  # scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu          '
  #petsc_options_iname = '-pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      1'

  # petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = 'bjacobi  ilu          4'

  # l_max_its = 30
  # l_tol = 2e-5
  # nl_max_its = 20
  # nl_rel_tol = 2e-8
  # nl_abs_tol = 2e-8

  # [./TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 1e-6
  #   cutback_factor = 0.8
  #   growth_factor = 1.5
  #   optimal_iterations = 20
  #   iteration_window = 5
  # [../]
  #dtmax = 1
  #end_time = 20.0
  #end_time = 170.0

  # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 3
  #   max_h_level = 3
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.001
  #   weight_names =  'wL wV wS'
  #   weight_values = '1  1  1'
  #
  # [../]
[]

[Debug]
  #show_var_residual = true
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #interval = 20
[]
