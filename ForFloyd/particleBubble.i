# Length unit: nm
# Time unit: s
#  Energy scale: 4e-7 ev/nm^3 = 64e9 J/m^3

# Fission gas bubble growth in UO2 fuel with a secondary phase particle

# Output fields
# pf_particle : phase field of the particle (has the value of 1 within the particle)
# pf_fuel : phase field of the fuel (has the value of 1 within the fuel)
# pf_bubble : phase field of the bubble (has the value of 1 within the bubble)
# interface_particle_bubble: interface field of the particle/bubble interface (has the value of 1 within particle/bubble interface)
# interface_particle_fuel: interface field of the particle/fuel interface (has the value of 1 within particle/fuel interface)
# interface_fuel_bubble: interface field of the fuel/bubble interface (has the value of 1 within fuel/bubble interface)
# ColorField: color representation of each phase (0 for the bubble, 1 for the particle, and 2 for the fuel phase)


# The equilibrium interfacial width is fixed at 30 nm.

iw = 30  # initial interfacial width (nm)

xpc = 600  # x coordinate of the particle center (nm)
ypc = 600  # y coordinate of the particle center (nm)
rpc = 150  # radius of the particle (nm)

xbc = 750  # x coordinate of the bubble seed center (nm)
ybc = 600  # y coordinate of the bubble seed center (nm)
rbc = 15  # initial radius of the bubble seed (nm)


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 120
  ny = 120
  xmin = 0
  xmax = 1200
  ymin = 0
  ymax = 1200
  #uniform_refine = 3
[]

[Variables]
  [./wv]
  [../]
  [./wg]
  [../]
  [./pf_bubble]
  [../]
  [./pf_particle]
  [../]
  [./pf_fuel]
  [../]
[]

[AuxVariables]
  [./time]
  [../]
  [./cg]
    order = FIRST
    family = MONOMIAL
  [../]
  [./cv]
    order = FIRST
    family = MONOMIAL
  [../]
  [./interface_particle_bubble]  #AuxVariable for plotting particle/bubble interface
    order = FIRST
    family = MONOMIAL
  [../]
  [./interface_particle_fuel]  #AuxVariable for plotting particle/fuel interface
    order = FIRST
    family = MONOMIAL
  [../]
  [./interface_fuel_bubble]  #AuxVariable for plotting fuel/bubble interface
    order = FIRST
    family = MONOMIAL
  [../]

  [./ColorField]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./time]
    type = FunctionAux
    variable = time
    function = 't'
  [../]
  [./cg]
    type = MaterialRealAux
    variable = cg
    property = cg_from_rhog
  [../]
  [./cv]
    type = MaterialRealAux
    variable = cv
    property = cv_from_rhov
  [../]

  [./Inter_particle_bubble]
    type = MaterialRealAux
    variable = interface_particle_bubble
    property = Inter_particle_bubble_material
  [../]
  [./Inter_particle_fuel]
    type = MaterialRealAux
    variable = interface_particle_fuel
    property = Inter_particle_fuel_material
  [../]
  [./Inter_fuel_bubble]
    type = MaterialRealAux
    variable = interface_fuel_bubble
    property = Inter_fuel_bubble_material
  [../]

  [./Coloring]
    type = ParsedAux
    variable = ColorField
    args = 'pf_bubble pf_particle pf_fuel'
    constant_names =       'coidx0 coidx1 coidx2'
    constant_expressions = '0      1      2'
    function = 'coidx0*0.5*(1+tanh((pf_bubble-0.5)/0.15)) + coidx1*0.5*(1+tanh((pf_particle-0.5)/0.15)) + coidx2*0.5*(1+tanh((pf_fuel-0.5)/0.15))'
  [../]
[]

[ICs]
  [./particle_IC]  #The circular particle at the center of the domain
    type = SmoothCircleIC
    variable = pf_particle
    invalue = 1
    outvalue = 0
    x1 = ${xpc}
    y1 = ${ypc}
    radius = ${rpc}
    int_width = ${iw}
  [../]

  [./fuel_IC]  #Fuel
    type = SmoothCircleIC
    variable = pf_fuel
    invalue = 0
    outvalue = 1
    x1 = ${xpc}
    y1 = ${ypc}
    radius = ${rpc}
    int_width = ${iw}
  [../]

  [./bubble_IC] # A tiny bubble seed within the particel interface region
    type = SmoothCircleIC
    variable = pf_bubble
    invalue = 1
    outvalue = 0
    x1 = ${xbc}
    y1 = ${ybc}
    radius = ${rbc}
    int_width = ${iw}
  [../]
  [./IC_wv]
    type = ConstantIC
    variable = wv
    value = 0
  [../]
  [./IC_wg]
    type = ConstantIC
    variable = wg
    value = 0
  [../]
[]



[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Kernels]
# Order parameter for the bubble phase
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = pf_bubble
    v =           'pf_particle pf_fuel'
    gamma_names = 'gmb      gmb'
    mu = mu
    mob_name = L
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = pf_bubble
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'pf_particle pf_fuel  wv wg'
    mob_name = L
  [../]
  [./ACb0_int]
    type = ACInterface
    variable = pf_bubble
    kappa_name = kappa
    mob_name = L
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = pf_bubble
  [../]
# Order parameter for the particle phase, fixed phase
  [./em0_dot]
    type = TimeDerivative
    variable = pf_particle
  [../]

# Order parameter for the fuel phase
  [./ACm1_bulk]
    type = ACGrGrMulti
    variable = pf_fuel
    v =           'pf_bubble pf_particle'
    gamma_names = 'gmb    gmm'
    mu = mu
    mob_name = L
  [../]
  [./ACm1_sw]
    type = ACSwitching
    variable = pf_fuel
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'pf_bubble pf_particle  wv wg'
    mob_name = L
  [../]
  [./ACm1_int]
    type = ACInterface
    variable = pf_fuel
    kappa_name = kappa
    mob_name = L
  [../]
  [./em1_dot]
    type = TimeDerivative
    variable = pf_fuel
  [../]

#Chemical potential for vacancies
  [./wv_dot]
    type = SusceptibilityTimeDerivative
    variable = wv
    f_name = chiv
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_v]
    type = MatDiffusion
    variable = wv
    D_name = Dchiv
    args = ''
  [../]
  [./Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 1
    mask = VacRate0
  [../]

  [./coupled_v_bubbledot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = pf_bubble
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]
  [./coupled_source_v_particle]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = pf_particle
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]
  [./coupled_source_v_fuel]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = pf_fuel
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]


#Chemical potential for gas atoms
  [./wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_g]
    type = MatDiffusion
    variable = wg
    D_name = Dchig
    args = ''
  [../]
  [./Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 1
    mask = XeRate0
  [../]

  [./coupled_g_bubbledot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = pf_bubble
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]
  [./coupled_source_g_particle]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = pf_particle
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]
  [./coupled_source_g_fuel]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = pf_fuel
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'pf_bubble pf_particle pf_fuel'
  [../]

[]

[Materials]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'pf_bubble pf_particle pf_fuel'
    phase_etas = 'pf_bubble'
    # outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'pf_bubble pf_particle pf_fuel'
    phase_etas = 'pf_particle pf_fuel'
    # outputs = exodus
  [../]
  [./hf]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hf
    all_etas = 'pf_bubble pf_particle pf_fuel'
    phase_etas = 'pf_fuel'
    # outputs = exodus
  [../]
# Chemical contribution to grand potential of bubble
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg time'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq'
    function = 'if(time < 0, 0, -0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq)'
    derivative_order = 2
    #outputs = exodus
  [../]

# Chemical contribution to grand potential of matrix
  [./omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg time'
    f_name = omegam
    material_property_names = 'Va kvmatrix cvmatrixeq kgmatrix cgmatrixeq'
    function = 'if(time < 0, 0, -0.5*wv^2/Va^2/kvmatrix-wv/Va*cvmatrixeq-0.5*wg^2/Va^2/kgmatrix-wg/Va*cgmatrixeq)'
    derivative_order = 2
    #outputs = exodus
  [../]

# Densities
  [./rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va kvmatrix cvmatrixeq'
    function = 'wv/Va^2/kvmatrix + cvmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va kgmatrix cgmatrixeq'
    function = 'wg/Va^2/kgmatrix + cgmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa     mu     L         Dm0  Db0  Va      cvbubeq  cgbubeq gmb 	 gmm T     YXe'
    prop_values = '2.21125e2 1.875  0.975e-3  0.1  0.1  0.0409  0.546    0.454   11.2  1.5 1200  0.2156'
  [../]
  [./Dm_eff]
    type = ParsedMaterial
    f_name = Dm
    material_property_names = 'Dm0 hf hb'
    # function = 'Dm0 * (hf + hb) + 1e-3 * Dm0 * (1 - hf - hb)'
    function = 'Dm0'
  [../]
  [./Db_eff]
    type = ParsedMaterial
    f_name = Db
    material_property_names = 'Db0 hf hb'
    # function = 'Db0 * (hf + hb) + 1e-3 * Db0 * (1 - hf - hb)'
    function = 'Db0'
  [../]
  [./cvmatrixeq]
    type = ParsedMaterial
    f_name = cvmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efv'  # in eV/atom
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
  [../]
  [./cgmatrixeq]
    type = ParsedMaterial
    f_name = cgmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efg'  # in eV/atom
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efg/(kB*T))'
  [../]
  [./kvmatrix_parabola]
    type = ParsedMaterial
    f_name = kvmatrix
    args = 'time'
    function = '3.00625e3' # in eV/nm^3
    # outputs = exodus
  [../]
  [./kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgmatrix
    material_property_names = 'kvmatrix'
    function = 'kvmatrix'
  [../]
  [./kgbub_parabola]
    type = ParsedMaterial
    f_name = kgbub
    function = '0.5625e3' # in eV/nm^3
    # outputs = exodus
  [../]
  [./kvbub_parabola]
    type = ParsedMaterial
    f_name = kvbub
    material_property_names = 'kgbub'
    function = 'kgbub'
  [../]
  [./Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchiv
    material_property_names = 'Db chiv'
    args = 'time'
    function = 'if(time < 0, 0, Db*chiv)'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'Dm chig'
    args = 'time'
    function = 'if(time < 0, 0, Dm*chig)'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    material_property_names = 'Va hb kvbub hm kvmatrix '
    function = '(hm/kvmatrix + hb/kvbub) / Va^2'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./chig]
    type = DerivativeParsedMaterial
    f_name = chig
    material_property_names = 'Va hb kgbub hm kgmatrix '
    function = '(hm/kgmatrix + hb/kgbub) / Va^2'
    derivative_order = 2
    # outputs = exodus
  [../]

  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hf'
    constant_names = 's0'
    constant_expressions = '2.35e-9'  # in atoms/(nm^3 * s)
    args = 'time'
    function = 'if(time < 0, 0, s0 * hf)'
    # outputs = exodus
  [../]
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate0'
    args = 'time'
    function = 'if(time < 0, 0, XeRate0 / YXe)'
    # outputs = exodus
  [../]

  [./cg]
    type = ParsedMaterial
    f_name = cg_from_rhog
    material_property_names = 'Va rhogbub rhogmatrix hm hb'
    function = 'hb*Va*rhogbub + hm*Va*rhogmatrix'
  [../]
  [./cv]
    type = ParsedMaterial
    f_name = cv_from_rhov
    material_property_names = 'Va rhovbub rhovmatrix hm hb'
    function = 'hb*Va*rhovbub + hm*Va*rhovmatrix'
  [../]

  [./area_particle]
    type = ParsedMaterial
    f_name = area_particle
    args = 'pf_particle'
    function = '0.5*(1 + tanh((pf_particle-0.1)/0.001))' # becomes 1 if pf_particle > 0.1, otherwise 0
    outputs = exodus
  [../]
  [./area_bubble]
    type = ParsedMaterial
    f_name = area_bubble
    args = 'pf_bubble'
    function = '0.5*(1 + tanh((pf_bubble-0.1)/0.001))' # becomes 1 if pf_bubble > 0.1, otherwise 0
    outputs = exodus
  [../]
  [./area_fuel]
    type = ParsedMaterial
    f_name = area_fuel
    args = 'pf_fuel'
    function = '0.5*(1 + tanh((pf_fuel-0.1)/0.001))' # becomes 1 if pf_fuel > 0.1, otherwise 0
    outputs = exodus
  [../]

  [./Inter_particle_bubble_material]
    type = ParsedMaterial
    f_name = Inter_particle_bubble_material
    material_property_names = 'area_particle(pf_particle) area_bubble(pf_bubble)'
    args = 'pf_particle pf_bubble'
    function = 'area_particle * area_bubble'
  [../]
  [./Inter_particle_fule_material]
    type = ParsedMaterial
    f_name = Inter_particle_fuel_material
    material_property_names = 'area_particle(pf_particle) area_fuel(pf_fuel)'
    args = 'pf_particle pf_fuel'
    function = 'area_particle * area_fuel'
  [../]
  [./Inter_fuel_bubble_material]
    type = ParsedMaterial
    f_name = Inter_fuel_bubble_material
    material_property_names = 'area_fuel(pf_fuel) area_bubble(pf_bubble)'
    args = 'pf_fuel pf_bubble'
    function = 'area_fuel * area_bubble'
  [../]
[]

#[Adaptivity]
#  marker = errorfrac
#  max_h_level = 3
#  [./Indicators]
#    [./error]
#      type = GradientJumpIndicator
#      variable = bnds
#    [../]
#  [../]
#  [./Markers]
#    [./bound_adapt]
#      type = ValueThresholdMarker
#      third_state = DO_NOTHING
#      coarsen = 1.0
#      refine = 0.99
#      variable = bnds
#      invert = true
#    [../]
#    [./errorfrac]
#      type = ErrorFractionMarker
#      coarsen = 0.1
#      indicator = error
#      refine = 0.7
#    [../]
#  [../]
#[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu'
  # solve_type = NEWTON
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = 'bjacobi  gmres     30'  # default is 30, the higher the higher resolution but the slower
  l_max_its = 15
  l_tol = 1.0e-4
  nl_rel_tol = 1e-9
  start_time = 0
  end_time = 1e20
  nl_abs_tol = 1e-12
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    growth_factor = 1.2
    cutback_factor = 0.8
  [../]
  dtmax = 5e4
[]

[Outputs]
  [./exodus]
    type = Exodus
    interval = 10
    # interval = 1
    sync_times = '0'
  [../]
  # checkpoint = true
  csv = true
  perf_graph = true
[]
