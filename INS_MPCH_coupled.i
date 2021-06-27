

#Forward split method

# Units:
#  Length: mm
#  Time: ms
#  Mass: g

interwidth = 0.36 #Target full-interfacial Width (in mm) - 9-element-width
pi = 3.141592
eps = 0.01

ML0 = 100.0
MV0 = 100.0
MS0 = 100000.0

# rlx_time = 0.001

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 25
  # nx = 200
  # ny = 200
  xmax = 16
  ymax = 8
  #type = FileMesh
  #file = notch.msh
  elem_type = QUAD8
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
  # pspg = false
  alpha = 1e0

  #Problem coefficients
  #gravity = '0 0 0'
  gravity = '0 -9.81e-3 0'

  #Weak form customization
  convective_term = true
  #convective_term = false
  integrate_p_by_parts = true
  transient_term = true
  laplace = false
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

  [./time]
  [../]

  [./height]
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
  #
  # [./calc_Fs_x]
  #   type = ParsedAux
  #   variable = Fs_x
  #   args = 'cL cV cS dwLx dwVx dwSx'
  #   #function = 'val:=((${ML}-cL)*dwLx + (${MV}-cV)*dwVx + (${MS}-cS)*dwSx)/(${ML}+${MV}+${MS});if((cL)*(1-cL) > 0, val, 0)'
  #   function = 'val:=((-cL)*dwLx + (-cV)*dwVx + (-cS)*dwSx);if((cL-0.1)*(0.9-cL) >= 0, val, 0)'
  #   # function = '(-cL)*dwLx + (-cV)*dwVx + (-cS)*dwSx'
  #   #execute_on = LINEAR
  #   execute_on = TIMESTEP_BEGIN
  # [../]
  #
  # [./calc_Fs_y]
  #   type = ParsedAux
  #   variable = Fs_y
  #   args = 'cL cV cS dwLy dwVy dwSy'
  #   #function = 'val:=((${ML}-cL)*dwLy + (${MV}-cV)*dwVy + (${MS}-cS)*dwSy)/(${ML}+${MV}+${MS});if((cL)*(1-cL) > 0, val, 0)'
  #   function = 'val:=((-cL)*dwLy + (-cV)*dwVy + (-cS)*dwSy);if((cL-0.1)*(0.9-cL) >= 0, val, 0)'
  #   #function = '(-cL)*dwLy + (-cV)*dwVy + (-cS)*dwSy'
  #   #execute_on = LINEAR
  #   execute_on = TIMESTEP_BEGIN
  # [../]

  [./time]
    type = FunctionAux
    variable = time
    function = t
  [../]
  [./height]
    type = FunctionAux
    variable = height
    function = y
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

  [./v_x] # x-velocity
    order = SECOND
    family = LAGRANGE
  [../]

  [./v_y] # y-velocity
    order = SECOND
    family = LAGRANGE
  [../]

  [./p] # pressure
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
    # function = FlatSlab
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
    vals = '8  2.5  1'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);if(abs(r-r0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(r-r0)/${interwidth}), if(r-r0 <= -0.5*${interwidth}, 1, 0))'
    #value = 'r:=sqrt((x-x0)^2+(y-y0)^2),0.5-0.5*tanh(0.5*5.8889*(r-r0)/0.5)'
  [../]
  [./FlatSlab]
    type = ParsedFunction
    vars = 'y0'
    vals = '1'
    value = 'if(abs(y-y0) <= 0.5*${interwidth}, 0.5-0.5*sin(${pi}*(y-y0)/${interwidth}), if(y-y0 <= -0.5*${interwidth}, 1, 0))'
  [../]
  [./TheSurface]
    type = RepeatedBoxcarFunction2D
    xs = 0.25
    ys = 0.25
    nbumps = 16
    pitch_length = 1
    bump_height = 0.75
    diffusive_length = 0.0001
    above_value = 0
    below_value = 1
  [../]
  [./Background]
    type = LinearCombinationFunction
    functions = 'OneConst TheCircle TheSurface'
    # functions = 'OneConst TheCircle FlatSlab'
    w =         '1        -1        -1'
  [../]
[]

[BCs]
  [./cL_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = cL
    value = 0
  [../]
  [./cV_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = cV
    value = 0
  [../]
  [./cS_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = cS
    value = 0
  [../]
  [./wL_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = wL
    value = 0
  [../]
  [./wV_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = wV
    value = 0
  [../]
  [./wS_symmetry]
    type = NeumannBC
    boundary = 'left right'
    variable = wS
    value = 0
  [../]
  [./v_x_wall]
    type = DirichletBC
    # boundary = 'bottom'
    boundary = 'bottom left right'
    variable = v_x
    value = 0
  [../]
  # [./v_x_symmetry]
  #   type = NeumannBC
  #   boundary = 'left'
  #   variable = v_x
  #   value = 0
  # [../]

  [./v_y_wall]
    type = DirichletBC
    # boundary = 'bottom'
    boundary = 'bottom left right'
    variable = v_y
    value = 0
  [../]

  # [./v_x_others]
  #   type = INSMomentumNoBCBCTractionForm
  #   boundary = 'left right top'
  #   variable = v_x
  #   component = 0
  # [../]
  #
  # [./v_y_others]
  #   type = INSMomentumNoBCBCTractionForm
  #   boundary = 'left right top'
  #   variable = v_y
  #   component = 1
  # [../]
  [./v_y_symmetry]
    type = NeumannBC
    boundary = 'left'
    variable = v_y
    value = 0
  [../]
  # [./p_wall]
  #   type = DirichletBC
  #   boundary = 'bottom'
  #   #boundary = 'bottom left right'
  #   variable = p
  #   value = 0
  # [../]

  # [./p_symmetry]
  #   type = NeumannBC
  #   boundary = 'left'
  #   variable = p
  #   value = 0
  # [../]
[]

[Kernels]
  # Multi-phase-Cahn-Hilliard equation part
  # R_cL part
  [./cL_timederivative_term]
    type = TimeDerivative
    variable = cL
  [../]
  [./cL_advection]
    # type = ConservativeAdvectionVfield
    type = VarAdvection
    variable = cL
    vel_x = v_x
    vel_y = v_y
  [../]
  [./cL_divgradwL_term]
    type = FwdSplitCH
    variable = cL
    mu_name = wL
    mob_name = mpL
    # var_grad_components = 'dcLx dcLy'
    prefactor = 1
  [../]
  [./cL_divgradwV_term]
    type = FwdSplitCH
    variable = cL
    mu_name = wV
    # var_grad_components = 'dcLx dcLy'
    # coupled_var_grad_components = 'dcVx dcVy'
    mob_name = mLV
    prefactor = -1
  [../]
  [./cL_divgradwS_term]
    type = FwdSplitCH
    variable = cL
    mu_name = wS
    # var_grad_components = 'dcLx dcLy'
    # coupled_var_grad_components = 'dcSx dcSy'
    mob_name = mLS
    prefactor = -1
  [../]

  # R_wL part
  [./wL_neg_wL_term]
    type = MassEigenKernel
    variable = wL
    eigen = false
  [../]
  [./wL_lap_cV_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cV
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wL_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wL
    v = cS
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wL_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fLV_LO
    args = 'cL cV'
    mob_name = One
  [../]
  [./wL_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wL
    v = cL
    f_name = fLS_LO
    args = 'cL cS'
    mob_name = One
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

  # R_wV part
  [./wV_neg_wV_term]
    type = MassEigenKernel
    variable = wV
    eigen = false
  [../]
  [./wV_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wV
    v = cL
    kappa_name = kappa_LV
    mob_name = negOne
  [../]
  [./wV_lap_cS_term]
    type = SimpleCoupledACInterface
    variable = wV
    v = cS
    kappa_name = kappa_VS
    mob_name = negOne
  [../]
  [./wV_doublewell_LV_term]
    type = CoupledAllenCahn
    variable = wV
    v = cV
    f_name = fLV_LO
    args = 'cL cV'
    mob_name = One
  [../]
  [./wV_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wV
    v = cV
    f_name = fVS_LO
    args = 'cV cS'
    mob_name = One
  [../]

  # R_cS part (just for initial relaxation using Allen-Cahn smoothing)
  [./cS_timederivative]
    type = TimeDerivative
    variable = cS
  [../]
  [./cS_ACsmoothing_grad]
    type = ACInterface
    variable = cS
    kappa_name = kappa_VS
    mob_name = MS
  [../]
  [./cS_ACsmoothing_dw]
    type = AllenCahn
    variable = cS
    f_name = fVS_ACsmoothing
    mob_name = MS
  [../]
  #No-advection because this kernels just for the initial relaxation
  # [./cS_divgradwS_term]
  #   type = FwdSplitCH
  #   variable = cS
  #   mu_name = wS
  #   mob_name = mpS
  #   # var_grad_components = 'dcSx dcSy'
  #   prefactor = 1
  # [../]
  # [./cS_divgradwL_term]
  #   type = FwdSplitCH
  #   variable = cS
  #   mu_name = wL
  #   # var_grad_components = 'dcSx dcSy'
  #   # coupled_var_grad_components = 'dcLx dcLy'
  #   mob_name = mLS
  #   prefactor = -1
  # [../]
  # [./cS_divgradwV_term]
  #   type = FwdSplitCH
  #   variable = cS
  #   mu_name = wV
  #   # var_grad_components = 'dcSx dcSy'
  #   # coupled_var_grad_components = 'dcVx dcVy'
  #   mob_name = mVS
  #   prefactor = -1
  # [../]
  #
  # R_wS part
  [./wS_neg_wS_term]
    type = MassEigenKernel
    variable = wS
    eigen = false
  [../]
  [./wS_lap_cL_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cL
    kappa_name = kappa_LS
    mob_name = negOne
  [../]
  [./wS_lap_cV_term]
    type = SimpleCoupledACInterface
    variable = wS
    v = cV
    kappa_name = kappa_VS
    mob_name = negOne
  [../]
  [./wS_doublewell_LS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cS
    f_name = fLS_LO
    args = 'cL cS'
    mob_name = One
  [../]
  [./wS_doublewell_VS_term]
    type = CoupledAllenCahn
    variable = wS
    v = cS
    f_name = fVS_LO
    args = 'cV cS'
    mob_name = One
  [../]

  #Incompressible Navier-Stokes equation part
  [./calc_pressure]
    type = INSMass
    variable = p
    mu_name = mu
    rho_name = rho_op
  [../]
  # [./pressure_term_with_variable_density]
  #   type = INSMassDensityVar
  #   variable = p
  #   density_name = rho_op
  #   coupled_vars = 'cL cV cS'
  #   prefactor = 1
  # [../]

  [./x_momentum]
    type = INSMomentumTractionForm
    variable = v_x
    component = 0
    mu_name = mu
    rho_name = rho_op
  [../]

  [./y_momentum]
    type = INSMomentumTractionForm
    variable = v_y
    component = 1
    mu_name = mu
    rho_name = rho_op
  [../]

  [./TimeDerivative_vx]
    type = INSMomentumTimeDerivative
    variable = v_x
    rho_name = rho_op
  [../]
  [./TimeDerivative_vy]
    type = INSMomentumTimeDerivative
    variable = v_y
    rho_name = rho_op
  [../]

  # [./TimeDerivative_vx]
  #   type = INSMomentumTimeDerivativeDensityVar
  #   variable = v_x
  #   density_name = rho_op
  #   coupled_vars = 'cL cV cS'
  # [../]
  # [./TimeDerivative_vy]
  #   type = INSMomentumTimeDerivativeDensityVar
  #   variable = v_y
  #   density_name = rho_op
  #   coupled_vars = 'cL cV cS'
  # [../]

  # [./Interfacial_force_x]
  #   type = InterfacialForceCH
  #   variable = v_x
  #   orderparam_vars = 'cL cV cS'
  #   chempot_vars = 'wL wV wS'
  #   component = x
  #   prefactor = -1e-3
  #   mask_name = forcemasking
  # [../]
  #
  # [./Interfacial_force_y]
  #   type = InterfacialForceCH
  #   variable = v_y
  #   orderparam_vars = 'cL cV cS'
  #   chempot_vars = 'wL wV wS'
  #   component = y
  #   prefactor = -1e-3
  #   mask_name = forcemasking
  # [../]

  [./Interfacial_force_x]  #alternative form
    type = InterfacialForceCH
    variable = v_x
    orderparam_vars = 'wL wV wS'
    chempot_vars = 'cL cV cS'
    component = x
    # prefactor = 0.01
    prefactor = -1
    # mask_name = forcemasking
    mask_name = One
  [../]

  [./Interfacial_force_y]
    type = InterfacialForceCH
    variable = v_y
    orderparam_vars = 'wL wV wS'
    chempot_vars = 'cL cV cS'
    component = y
    # prefactor = 0.01
    prefactor = -1
    # mask_name = forcemasking
    mask_name = One
  [../]
[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names = 'sig_LV sig_LS sig_VS One negOne'
    prop_values = '0.02e-3     0.01e-3    0.02e-3      1   -1'
    #prop_values = '1     1.866025    1      1 1   -1'
  [../]

  [./sigop_LV]
    type = ParsedMaterial
    f_name = sigop_LV
    args = 'time'
    material_property_names = 'sig_LV'
    function = 'if(time < 0, 0.01e-3, sig_LV)'
  [../]
  [./sigop_LS]
    type = ParsedMaterial
    f_name = sigop_LS
    args = 'time'
    material_property_names = 'sig_LS'
    function = 'if(time < 0, 0.01e-3, sig_LS)'
  [../]
  [./sigop_VS]
    type = ParsedMaterial
    f_name = sigop_VS
    args = 'time'
    material_property_names = 'sig_VS'
    function = 'if(time < 0, 0.01e-3, sig_VS)'
  [../]

  [./Operation_mobility_L]
    type = ParsedMaterial
    f_name = ML
    # args = 'dcLx dcLy'
    # function = 'if(sqrt(dcLx^2 + dcLy^2) > 1e-8, ${ML0}, 0)'
    args = 'time'
    function = 'if(time >= 0, ${ML0}, 0)'
  [../]
  [./Operation_mobility_V]
    type = ParsedMaterial
    f_name = MV
    # args = 'dcVx dcVy'
    # function = 'if(sqrt(dcVx^2 + dcVy^2) > 1e-8, ${MV0}, 0)'
    args = 'time'
    function = 'if(time >= 0, ${MV0}, 0)'
  [../]
  [./Operation_mobility_S]
    type = ParsedMaterial
    f_name = MS
    # args = 'time dcSx dcSy'
    # function = 'if(time < 0, if(sqrt(dcSx^2 + dcSy^2) > 1e-8, ${MS0}, 0), 0)'
    args = 'time'
    function = 'if(time < 0, ${MS0}, 0)'
  [../]

  [./Mutual_mobilities_LV]
    type = DerivativeParsedMaterial
    f_name = mLV
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcLx dcLy dcVx dcVy'
    # function = 'if(ML*MV > 0, ML*MV/(ML+MV+MS), 0)'
    # function = 'ML*MV/(ML+MV+MS)*(1+tanh(cL/eps))*(1+tanh(cV/eps))/4'
    # function = 'ML*MV/(ML+MV+MS)*tanh((dcLx^2+dcLy^2)*(dcVx^2+dcVy^2)/eps)'
    function = 'ML*MV/(ML+MV+MS)'
    derivative_order = 1
  [../]

  [./Mutual_mobilities_LS]
    type = DerivativeParsedMaterial
    f_name = mLS
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcLx dcLy dcSx dcSy'
    # function = 'if(ML*MS > 0, ML*MS/(ML+MV+MS), 0)'
    # function = 'ML*MS/(ML+MV+MS)*(1+tanh(cL/eps))*(1+tanh(cS/eps))/4'
    # function = 'ML*MS/(ML+MV+MS)*tanh((dcLx^2+dcLy^2)*(dcSx^2+dcSy^2)/eps)'
    function = 'ML*MS/(ML+MV+MS)'
    derivative_order = 1
  [../]

  [./Mutual_mobilities_VS]
    type = DerivativeParsedMaterial
    f_name = mVS
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcVx dcVy dcSx dcSy'
    # function = 'if(MV*MS > 0, MV*MS/(ML+MV+MS), 0)'
    # function = 'MV*MS/(ML+MV+MS)*(1+tanh(cV/eps))*(1+tanh(cS/eps))/4'
    # function = 'MV*MS/(ML+MV+MS)*tanh((dcVx^2+dcVy^2)*(dcVx^2+dcVy^2)/eps)'
    function = 'MV*MS/(ML+MV+MS)'
    derivative_order = 1
  [../]

  [./Self_mobilities_L]
    type = DerivativeParsedMaterial
    f_name = mpL
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcLx dcLy'
    # function = 'if(ML+MV+MS > 0, ML - ML*ML/(ML+MV+MS), 0)'
    # function = 'ML*(1 - ML/(ML+MV+MS))*(1+tanh(cL/eps))*(1+tanh((1-cL)/eps))/4'
    # function = 'ML*(1 - ML/(ML+MV+MS))*tanh((dcLx^2+dcLy^2)^2/eps)'
    function = 'ML*(1 - ML/(ML+MV+MS))'
    derivative_order = 1
  [../]

  [./Self_mobilities_V]
    type = DerivativeParsedMaterial
    f_name = mpV
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcVx dcVy'
    # function = 'if(ML+MV+MS > 0, MV - MV*MV/(ML+MV+MS), 0)'
    # function = '(MV - MV*MV/(ML+MV+MS))*(1+tanh(cV/eps))*(1+tanh((1-cV)/eps))/4'
    # function = '(MV - MV*MV/(ML+MV+MS))*tanh((dcVx^2+dcVy^2)^2/eps)'
    function = '(MV - MV*MV/(ML+MV+MS))'
    derivative_order = 1
  [../]

  [./Self_mobilities_S]
    type = DerivativeParsedMaterial
    f_name = mpS
    material_property_names = 'ML MV MS'
    # constant_names = 'eps'
    # constant_expressions = '0.01'
    # args = 'dcSx dcSy'
    # function = 'if(ML+MV+MS > 0, MS - MS*MS/(ML+MV+MS), 0)'
    # function = '(MS - MS*MS/(ML+MV+MS))*(1+tanh(cS/eps))*(1+tanh((1-cS)/eps))/4'
    # function = '(MS - MS*MS/(ML+MV+MS))*tanh((dcSx^2+dcSy^2)^2/eps)'
    function = '(MS - MS*MS/(ML+MV+MS))'
    derivative_order = 1
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
    material_property_names = 'dwh_LV ABScL(cL) ABScV(cV)'
    args = 'cL cV'
    # function = 'dwh_LV*(sqrt(cL^2+(${eps})^2)-${eps})*(sqrt(cV^2+(${eps})^2)-${eps})'
    function = 'dwh_LV*ABScL*ABScV'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_LStw]
    type = DerivativeParsedMaterial
    f_name = fLS_LO
    material_property_names = 'dwh_LS ABScL(cL) ABScS(cS)'
    args = 'cL cS'
    # function = 'dwh_LS*(sqrt(cL^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = 'dwh_LS*ABScL*ABScS'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_VStw]
    type = DerivativeParsedMaterial
    f_name = fVS_LO
    material_property_names = 'dwh_VS ABScV(cV) ABScS(cS)'
    args = 'cV cS'
    # function = 'dwh_VS*(sqrt(cV^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = 'dwh_VS*ABScV*ABScS'
    #outputs = exodus
    derivative_order = 2
  [../]

  [./doublewell_ACsmoothing]
    type = DerivativeParsedMaterial
    f_name = fVS_ACsmoothing
    material_property_names = 'dwh_VS'
    args = 'cS'
    function = '0.5*dwh_VS*(sqrt((1-cS)^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
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
    material_property_names = 'hS(cS) hL(cL) hV(cV)'
    constant_names =       'mu_S     mu_L     mu_V'
    constant_expressions = '1.002e-3 1.002e-6 0.018e-6'  # dynamic viscosity of solid should be huge (ideally infinity)
    # constant_expressions = '1.002e-6 1.002e-6 0.018e-6'  # dynamic viscosity of solid should be huge (ideally infinity)
    # constant_expressions = '0.018e-6 0.018e-6 0.018e-6'  # dynamic viscosity of solid should be huge (ideally infinity)
    # function = 'if(cS > 1, 1, max(cS,0))*mu_S + if(cL > 1, 1, max(cL,0))*mu_L + if(cV > 1, 1, max(cV,0))*mu_V'
    function = 'mu_S * hS + mu_L * hL + mu_V * hV'
    derivative_order = 2
    outputs = exodus
  [../]

  [./massdensity]
    type = DerivativeParsedMaterial
    f_name = rho
    args = 'cS cL cV'
    material_property_names = 'hS(cS) hL(cL) hV(cV)'
    constant_names =       'rho_S rho_L rho_V'
    constant_expressions = '1e-3  1e-3  1.1839e-6'
    # constant_expressions = '1.1839e-6  1e-3  1.1839e-6'
    # constant_expressions = '1e-3  1e-3  1e-3'
    # function = 'if(cS > 1, 1, max(cS,0))*rho_S + if(cL > 1, 1, max(cL,0))*rho_L + if(cV > 1, 1, max(cV,0))*rho_V'
    function = '(rho_S * hS + rho_L * hL + rho_V * hV)/(hS+hL+hV)'
    derivative_order = 2
    outputs = exodus
  [../]

  [./massdensity_op]
    type = DerivativeParsedMaterial
    f_name = rho_op
    args = 'cS cL cV time'
    material_property_names = 'rho(cS,cL,cV)'  # When use multiple arguments, space is not allowed.
    # constant_names =       'rho_S rho_L rho_V'
    # constant_expressions = '1e-3  1e-3  1.1839e-6'
    # function = 'if(time >= 0,if(cS > 1, 1, max(cS,0))*rho_S + if(cL > 1, 1, max(cL,0))*rho_L + if(cV > 1, 1, max(cV,0))*rho_V, 1e-3)'
    function = 'if(time >= 0,rho, 1e-3)'
    #outputs = exodus
  [../]

  [./ForceMasking]
    type = ParsedMaterial
    f_name = forcemasking
    constant_names = 'thres'
    constant_expressions = '0.1'
    args = 'cL time'
    function = 'if(time < 0, 0, if((cL-thres)*(1-thres-cL) >= 0, 1, 0))'
    outputs = exodus
  [../]

  [./abs_cL]
    type = DerivativeParsedMaterial
    f_name = ABScL
    args = 'cL'
    function = 'sqrt(cL^2 + (${eps})^2) - ${eps}'
    derivative_order = 2
  [../]
  [./abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV
    args = 'cV'
    function = 'sqrt(cV^2 + (${eps})^2) - ${eps}'
    derivative_order = 2
  [../]
  [./abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS
    args = 'cS'
    function = 'sqrt(cS^2 + (${eps})^2) - ${eps}'
    derivative_order = 2
  [../]

  [./h_cL]
    type = DerivativeParsedMaterial
    f_name = hL
    args = 'cL'
    constant_names = 'e'
    constant_expressions = '0.15'
    function = '0.5 + 0.5*tanh((cL-0.5)/e)'
    # function = 'cL'
  [../]
  [./h_cV]
    type = DerivativeParsedMaterial
    f_name = hV
    args = 'cV'
    constant_names = 'e'
    constant_expressions = '0.15'
    function = '0.5 + 0.5*tanh((cV-0.5)/e)'
    # function = 'cV'
  [../]
  [./h_cS]
    type = DerivativeParsedMaterial
    f_name = hS
    args = 'cS'
    constant_names = 'e'
    constant_expressions = '0.15'
    function = '0.5 + 0.5*tanh((cS-0.5)/e)'
    # function = 'cS'
  [../]

  [./kinetic_energy_density]
    type = ParsedMaterial
    f_name = KEdensity
    args = 'v_x v_y'
    material_property_names = 'rho'
    function = '0.5 * rho * (v_x^2 + v_y^2)'
  [../]

  [./potential_energy_density]
    type = ParsedMaterial
    f_name = PEdensity
    constant_names = 'g'
    constant_expressions = '-9.81e-3'
    material_property_names = 'rho'
    args = 'height'
    function = '-rho * g * height'
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
    dt = 1e-5
    cutback_factor = 0.5
    growth_factor = 1.8
    # optimal_iterations = 20
    # iteration_window = 5
  [../]
  dtmax = 0.5
  #end_time = 20.0
  start_time = -0.01
  # start_time = 0.0
  end_time = 170.0

  # adaptive mesh to resolve an interface
  [./Adaptivity]
    initial_adaptivity = 3
    max_h_level = 3
    refine_fraction = 0.99
    coarsen_fraction = 0.001
    weight_names =  'cL cV cS wL wV wS v_x v_y p'
    weight_values = '1  1  1  1  1  1  1   1   1'

  [../]
[]

[Debug]
  #show_var_residual = true
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #interval = 20
  sync_times = '0'
[]
