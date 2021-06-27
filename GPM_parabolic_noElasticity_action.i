[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 120
  ny = 120
  xmin = 0
  xmax = 1200
  ymin = 0
  ymax = 1200
[]

[GlobalParams]
  op_num = 5
  grain_num = 5
  var_name_base = etam
  numbub = 14
  bubspac = 150
  radius = 44
  int_width = 30
[]

[Variables]
  # [./w]
  # [../]
  # [./phi]
  # [../]
  # [./eta0]
  # [../]

  [./wv]
  [../]
  [./wg]
  [../]
  [./bubble]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./XolotlXeRate]
    order = FIRST
    family = LAGRANGE
  [../]
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
[]

[ICs]
  # [./IC_w]
  #   type = BoundingBoxIC
  #   variable = w
  #   x1 = 150
  #   x2 = 300
  #   y1 = 0
  #   y2 = 0
  #   inside = 0.1
  #   outside = 0
  # [../]
  # [./IC_phi]
  #   type = BoundingBoxIC
  #   variable = phi
  #   x1 = 0
  #   x2 = 150
  #   y1 = 0
  #   y2 = 0
  #   inside = 1
  #   outside = 0
  # [../]
  # [./IC_eta0]
  #   type = BoundingBoxIC
  #   variable = eta0
  #   x1 = 150
  #   x2 = 300
  #   y1 = 0
  #   y2 = 0
  #   inside = 1
  #   outside = 0
  # [../]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      invalue = 1.0
      outvalue = 0.0
    [../]
  [../]
  # [./]
  [./bnds]
    type = ConstantIC
    variable = bnds
    value = 1
  [../]
  [./bubble_IC]
    variable = bubble
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 1.0
    outvalue = 0.0
  [../]
  [./IC_wv]
    variable = wv
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 0.0
    outvalue = 0.0
  [../]
  [./IC_wg]
    variable = wg
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 0.0
    outvalue = 0.0
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
  [../]
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
[]

[Modules]
  [./PhaseField]
    [./GrandPotential]
      switching_function_names = 'hb hm'
      anisotropic = false

      chemical_potentials = 'wv wg'
      mobilities = 'Dchiv Dchig'
      susceptibilities = 'chiv chig'
      free_energies_w = 'rhovbub rhovmatrix rhogbub rhogmatrix'

      # chemical_potentials = 'wg'
      # mobilities = 'Dchig'
      # susceptibilities = 'chig'
      # free_energies_w = 'rhogbub rhogmatrix'

      # gamma_gr = gamma
      gamma_gr = gmm
      mobility_name_gr = L
      kappa_gr = kappa
      free_energies_gr = 'omegab omegam'

      additional_ops = 'bubble'
      gamma_grxop = gmb
      mobility_name_op = L
      kappa_op = kappa
      free_energies_op = 'omegab omegam'
    [../]
  [../]
[]

[Kernels]
  [./Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 1
    mask = VacRate0
  [../]
  [./Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 1
    mask = XeRate0
  [../]
[]

[Materials]
  # #REFERENCES
  # [./constants]
  #   type = GenericConstantMaterial
  #   prop_names =  'Va      cb_eq cm_eq kb   km  mu  gamma L      L_phi  kappa  kB'
  #   prop_values = '0.04092 1.0   1e-5  1400 140 1.5 1.5   5.3e+3 2.3e+4 295.85 8.6173324e-5'
  # [../]
  # #SWITCHING FUNCTIONS
  # [./switchb]
  #   type = SwitchingFunctionMultiPhaseMaterial
  #   h_name = hb
  #   all_etas = 'phi eta0'
  #   phase_etas = 'phi'
  # [../]
  # [./switchm]
  #   type = SwitchingFunctionMultiPhaseMaterial
  #   h_name = hm
  #   all_etas = 'phi eta0'
  #   phase_etas = 'eta0'
  # [../]
  # [./omegab]
  #   type = DerivativeParsedMaterial
  #   f_name = omegab
  #   args = 'w phi'
  #   material_property_names = 'Va kb cb_eq'
  #   function = '-0.5*w^2/Va^2/kb - w/Va*cb_eq'
  #   derivative_order = 2
  # [../]
  # [./omegam]
  #   type = DerivativeParsedMaterial
  #   f_name = omegam
  #   args = 'w eta0'
  #   material_property_names = 'Va km cm_eq'
  #   function = '-0.5*w^2/Va^2/km - w/Va*cm_eq'
  #   derivative_order = 2
  # [../]
  # [./chi]
  #   type = DerivativeParsedMaterial
  #   f_name = chi
  #   args = 'w'
  #   material_property_names = 'Va hb hm kb km'
  #   function = '(hm/km + hb/kb)/Va^2'
  #   derivative_order = 2
  # [../]
  # #DENSITIES/CONCENTRATION
  # [./rhob]
  #   type = DerivativeParsedMaterial
  #   f_name = rhob
  #   args = 'w'
  #   material_property_names = 'Va kb cb_eq'
  #   function = 'w/Va^2/kb + cb_eq/Va'
  #   derivative_order = 1
  # [../]
  # [./rhom]
  #   type = DerivativeParsedMaterial
  #   f_name = rhom
  #   args = 'w eta0'
  #   material_property_names = 'Va km cm_eq(eta0)'
  #   function = 'w/Va^2/km + cm_eq/Va'
  #   derivative_order = 1
  # [../]
  # [./concentration]
  #   type = ParsedMaterial
  #   f_name = c
  #   material_property_names = 'rhom hm rhob hb Va'
  #   function = 'Va*(hm*rhom + hb*rhob)'
  #   outputs = exodus
  # [../]
  # [./mobility]
  #   type = DerivativeParsedMaterial
  #   material_property_names = 'chi kB'
  #   constant_names = 'T Em D0'
  #   constant_expressions = '1400 2.4 1.25e2'
  #   f_name = chiD
  #   function = 'chi*D0*exp(-Em/kB/T)'
  # [../]

  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4'
    phase_etas = 'bubble'
    outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4'
    phase_etas = 'etam0 etam1 etam2 etam3 etam4'
    outputs = exodus
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
    prop_names =  'kappa     mu     L        Dm   Db   Va      cvbubeq  cgbubeq gmb 	 gmm T     YXe'
    prop_values = '2.21125e2 1.875  0.975e-3 0.1  0.1  0.0409  0.546    0.454   0.922  1.5 1200  0.2156'
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
    outputs = exodus
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
    outputs = exodus
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

  [./XeRate]
    type = ParsedMaterial
    f_name = XeRate
    material_property_names = 'hm'
    args = 'time XolotlXeRate'  # XolotlXeRate is in Xe/(nm^3 * s) & Va is in Xe/nm^3
    # function = 'if(time < 0, 0, XolotlXeRate * hm)'
    function = 'if(time < 0, 0, XolotlXeRate)'
    outputs = exodus
  [../]

  [./VacRate]
    type = ParsedMaterial
    f_name = VacRate
    material_property_names = 'XeRate YXe'
    function = 'XeRate / YXe'
    outputs = exodus
  [../]

  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hm'
    constant_names = 's0'
    constant_expressions = '2.35e-9'  # in atoms/(nm^3 * s)
    args = 'time'
    function = 'if(time < 0, 0, s0 * hm)'
    outputs = exodus
  [../]
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate0'
    args = 'time'
    function = 'if(time < 0, 0, XeRate0 / YXe)'
    outputs = exodus
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
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  # solve_type = NEWTON
  # petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart -sub_ksp_type'
  # petsc_options_value = ' asm      lu           1               31                 preonly'
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu'
  nl_max_its = 15
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  start_time = -1e3
  #num_steps = 1000
  end_time = 1e9
  nl_abs_tol = 1e-10
  [./TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.2
    cutback_factor = 0.8
    dt = 0.5
    adapt_log = true
  [../]
[]

[Outputs]
  exodus = true
  interval = 10
  sync_times = '0'
  csv = true
[]
