
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

[GlobalParams]
  #Variable coupling and naiming
  u = v_x
  v = v_y
  #w = v_z
  p = p

  #Stabilization Parameters
  supg = true
  #supg = false
  pspg = true
  alpha = 1e0

  #Problem coefficients
  #gravity = '0 0 0'
  gravity = '0 -9.81e-3 0'

  #Weak form customization
  convective_term = true
  #convective_term = false
  integrate_p_by_parts = true
  transient_term = true
  laplace = true
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

  [./wLget] #chemical potential of Liquid phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./wVget] #chemical potential of Vapor phase
    order = FIRST
    family = LAGRANGE
  [../]

  [./wSget] #chemical potential of Solid phase - used for calculating interfacial force
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

  [./dwLx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dwLy]
    order = FIRST
    family = MONOMIAL
  [../]

  [./dwVx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dwVy]
    order = FIRST
    family = MONOMIAL
  [../]

  [./dwSx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dwSy]
    order = FIRST
    family = MONOMIAL
  [../]

  [./Fs_x]  # interfacial force, x-component
    order = FIRST
    family = MONOMIAL
  [../]

  [./Fs_y]  # interfacial force, y-component
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

  [./calc_dwLx]
    type = VariableGradientComponent
    variable = dwLx
    gradient_variable = wL
    component = x
  [../]
  [./calc_dwLy]
    type = VariableGradientComponent
    variable = dwLy
    gradient_variable = wL
    component = y
  [../]

  [./calc_dwVx]
    type = VariableGradientComponent
    variable = dwVx
    gradient_variable = wV
    component = x
  [../]
  [./calc_dwVy]
    type = VariableGradientComponent
    variable = dwVy
    gradient_variable = wV
    component = y
  [../]

  [./calc_dwSx]
    type = VariableGradientComponent
    variable = dwSx
    gradient_variable = wS
    component = x
  [../]
  [./calc_dwSy]
    type = VariableGradientComponent
    variable = dwSy
    gradient_variable = wS
    component = y
  [../]

  [./calc_Fs_x]
    type = ParsedAux
    variable = Fs_x
    args = 'cL cV cS dwLx dwVx dwSx'
    #function = 'val:=((${ML}-cL)*dwLx + (${MV}-cV)*dwVx + (${MS}-cS)*dwSx)/(${ML}+${MV}+${MS});if((cL)*(1-cL) > 0, val, 0)'
    function = 'val:=((-cL)*dwLx + (-cV)*dwVx + (-cS)*dwSx);if((cL-0.01)*(0.99-cL) >= 0, val, 0)'
    #function = '(-cL)*dwLx + (-cV)*dwVx + (-cS)*dwSx'
    #execute_on = LINEAR
    execute_on = TIMESTEP_BEGIN
  [../]

  [./calc_Fs_y]
    type = ParsedAux
    variable = Fs_y
    args = 'cL cV cS dwLy dwVy dwSy'
    #function = 'val:=((${ML}-cL)*dwLy + (${MV}-cV)*dwVy + (${MS}-cS)*dwSy)/(${ML}+${MV}+${MS});if((cL)*(1-cL) > 0, val, 0)'
    function = 'val:=((-cL)*dwLy + (-cV)*dwVy + (-cS)*dwSy);if((cL-0.01)*(0.99-cL) >= 0, val, 0)'
    #function = '(-cL)*dwLy + (-cV)*dwVy + (-cS)*dwSy'
    #execute_on = LINEAR
    execute_on = TIMESTEP_BEGIN
  [../]

  [./time]
    type = FunctionAux
    variable = time
    function = t
  [../]
[]

[Variables]
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

  [./v_x] # x-velocity
    order = FIRST
    family = LAGRANGE
  [../]

  [./v_y] # y-velocity
    order = FIRST
    family = LAGRANGE
  [../]

  [./p] # pressure
    order = FIRST
    family = LAGRANGE
  [../]

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
    function = TheSurface
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

  [./wS_zero]
    type = ConstantIC
    variable = wS
    value = 0
  [../]

  [./vel_x_IC]
    type = ConstantIC
    variable = v_x
    value = 0.0
  [../]

  [./vel_y_IC]
    type = ConstantIC
    variable = v_y
    value = 0.0
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
  [./v_x_wall]
    type = DirichletBC
    boundary = 'bottom'
    #boundary = 'bottom left right'
    variable = v_x
    value = 0
  [../]
  [./v_y_wall]
    type = DirichletBC
    boundary = 'bottom'
    #boundary = 'bottom left right'
    variable = v_y
    value = 0
  [../]
[]

[Kernels]
  # Chamical potential date from the subapp
  [./wLitself]
    type = MassEigenKernel
    variable = wL
    eigen = false
  [../]
  [./wLget]
    type = CoupledForce
    variable = wL
    v = wLget
    coef = -1
  [../]
  [./wVitself]
    type = MassEigenKernel
    variable = wV
    eigen = false
  [../]
  [./wVget]
    type = CoupledForce
    variable = wV
    v = wVget
    coef = -1
  [../]
  [./wSitself]
    type = MassEigenKernel
    variable = wS
    eigen = false
  [../]
  [./wSget]
    type = CoupledForce
    variable = wS
    v = wSget
    coef = -1
  [../]

  # Multi-phase-Cahn-Hilliard equation part
  # R_cL part
  [./cL_timederivative_term]
    type = TimeDerivative
    variable = cL
  [../]
  [./cL_advection]
    type = ConservativeAdvectionVfield
    variable = cL
    vel_x = v_x
    vel_y = v_y
  [../]
  [./cL_divgradwL_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wL
    kappa_name = mpL
    mob_name = One
  [../]
  [./cL_divgradwV_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wV
    kappa_name = mLV
    mob_name = negOne
  [../]
  [./cL_divgradwS_term]
    type = SimpleCoupledACInterface
    variable = cL
    v = wS
    kappa_name = mLS
    mob_name = negOne
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
  #   kappa_name = mLV
  #   mob_name = One
  # [../]
  # [./cV_divgradwV_term]
  #   type = SimpleCoupledACInterface
  #   variable = cV
  #   v = wL
  #   kappa_name = mLV
  #   mob_name = negOne
  # [../]

  # Calc. cV from the constraint; cL + cV + cS = 1
  # [./cV_itself]
  #   type = MassEigenKernel
  #   variable = cV
  #   eigen = false
  # [../]
  # [./cV_constraint]
  #   type = CoupledForce
  #   variable = cV
  #   v = cV_constrained
  #   coef = -1
  # [../]
  [./cV_timederivative_term]
    type = TimeDerivative
    variable = cV
  [../]
  [./cVdot_constraint_L]
    type = CoefCoupledTimeDerivative
    variable = cV
    v = cL
    coef = 1
  [../]
  [./cVdot_constraint_S]
    type = CoefCoupledTimeDerivative
    variable = cV
    v = cS
    coef = 1
  [../]

  # R_cS part
  [./cS_timederivative]
    type = TimeDerivative
    variable = cS
  [../]
  #No-advection because this kernels just for the initial relaxation
  [./cS_divgradwS_term]
    type = SimpleCoupledACInterface
    variable = cS
    v = wS
    kappa_name = mpS
    mob_name = One
  [../]
  [./cS_divgradwL_term]
    type = SimpleCoupledACInterface
    variable = cS
    v = wL
    kappa_name = mLS
    mob_name = negOne
  [../]
  [./cS_divgradwV_term]
    type = SimpleCoupledACInterface
    variable = cS
    v = wV
    kappa_name = mVS
    mob_name = negOne
  [../]

  #Incompressible Navier-Stokes equation part
  [./calc_pressure]
    type = INSMass
    variable = p
    mu_name = mu
    rho_name = rho
  [../]

  [./x_momentum]
    type = INSMomentumLaplaceForm
    variable = v_x
    component = 0
    mu_name = mu
    rho_name = rho_op
  [../]
  [./y_momentum]
    type = INSMomentumLaplaceForm
    variable = v_y
    component = 1
    mu_name = mu
    rho_name = rho_op
  [../]

  [./TimeDerivative_vx]
    type = INSMomentumTimeDerivative
    variable = v_x
    rho_name = rho
  [../]
  [./TimeDerivative_vy]
    type = INSMomentumTimeDerivative
    variable = v_y
    rho_name = rho
  [../]

  [./Interfacial_force_x]
    type = CoupledForce
    variable = v_x
    v = Fs_x  #provided by ParsedAux kernel
    coef = 0
  [../]

  [./Interfacial_force_y]
    type = CoupledForce
    variable = v_y
    v = Fs_y  #provided by ParsedAux kernel
    coef = 0
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

  [./dynamic_viscosity]
    type = DerivativeParsedMaterial
    f_name = mu
    args = 'cS cL cV time'
    constant_names =       'mu_S     mu_L     mu_V'
    constant_expressions = '1.002e-3 1.002e-6 0.018e-6'  # dynamic viscosity of solid should be huge (ideally infinity)
    function = 'if(cS > 1, 1, max(cS,0))*mu_S + if(cL > 1, 1, max(cL,0))*mu_L + if(cV > 1, 1, max(cV,0))*mu_V'
    #outputs = exodus
  [../]

  [./massdensity]
    type = DerivativeParsedMaterial
    f_name = rho
    args = 'cS cL cV'
    constant_names =       'rho_S rho_L rho_V'
    constant_expressions = '1e-3  1e-3  1.1839e-6'
    function = 'if(cS > 1, 1, max(cS,0))*rho_S + if(cL > 1, 1, max(cL,0))*rho_L + if(cV > 1, 1, max(cV,0))*rho_V'
    #outputs = exodus
  [../]

  [./massdensity_op]
    type = DerivativeParsedMaterial
    f_name = rho_op
    args = 'cS cL cV time'
    constant_names =       'rho_S rho_L rho_V'
    constant_expressions = '1e-3  1e-3  1.1839e-6'
    function = 'if(time >= ${rlx_time},if(cS > 1, 1, max(cS,0))*rho_S + if(cL > 1, 1, max(cL,0))*rho_L + if(cV > 1, 1, max(cV,0))*rho_V, 1e-3)'
    #outputs = exodus
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

  # petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 30
  l_tol = 2e-5
  nl_max_its = 20
  nl_rel_tol = 2e-8
  nl_abs_tol = 2e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-6
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 20
    iteration_window = 5
  [../]
  #dtmax = 1
  #end_time = 20.0
  end_time = 170.0

  # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 3
  #   max_h_level = 3
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.001
  #   weight_names =  'cL cV cS v_x v_y p'
  #   weight_values = '1  1  1  1   1   1'
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

# Master app
[MultiApps]
  [./w_calc]
    type = FullSolveMultiApp
    app_type = devel_testrunApp
    execute_on = TIMESTEP_BEGIN
    positions = '0 0 0'
    input_files = INS_MPCH_coupled_w_part.i
  [../]
[]

[Transfers]
  [./send_cL_to_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = to_multiapp
    multi_app = w_calc
    source_variable = cL  # This cL is defined in this input file.
    variable = cL  # This cL is defined in INS_MPCH_coupled_w_part.i
    execute_on = SAME_AS_MULTIAPP
  [../]
  [./send_cV_to_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = to_multiapp
    multi_app = w_calc
    source_variable = cV  # This cV is defined in this input file.
    variable = cV  # This cV is defined in INS_MPCH_coupled_w_part.i
    execute_on = SAME_AS_MULTIAPP
  [../]
  [./send_cS_to_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = to_multiapp
    multi_app = w_calc
    source_variable = cS  # This cL is defined in this input file.
    variable = cS  # This cS is defined in INS_MPCH_coupled_w_part.i
    execute_on = SAME_AS_MULTIAPP
  [../]

  [./get_wL_from_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = w_calc
    source_variable = wL  # This wL is defined in INS_MPCH_coupled_w_part.i
    variable = wLget  # This wL is defined in this input file
    execute_on = SAME_AS_MULTIAPP
  [../]
  [./get_wV_from_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = w_calc
    source_variable = wV  # This wV is defined in INS_MPCH_coupled_w_part.i
    variable = wVget  # This wV is defined in this input file
    execute_on = SAME_AS_MULTIAPP
  [../]
  [./get_wS_from_the_subapp]
    type = MultiAppNearestNodeTransfer
    direction = from_multiapp
    multi_app = w_calc
    source_variable = wS  # This wS is defined in INS_MPCH_coupled_w_part.i
    variable = wSget  # This wS is defined in this input file
    execute_on = SAME_AS_MULTIAPP
  [../]
[]
