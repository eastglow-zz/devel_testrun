# Length unit: nm
# Time unit: s
# Energy unit: eV, scaled by 64 GPa

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 200
  xmin = 0
  xmax = 20000
  ymin = 0
  ymax = 20000
  #uniform_refine = 3
  # parallel_type = DISTRIBUTED
[]

[GlobalParams]
  op_num = 11
  var_name_base = eta

  #SolutionUserObject parameters
  mesh = IC_bub_poly_10gr_50dt.e
  system_variables = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 etab'
  timestep = 50 # Time step number (not time) that will be extracted from the exodus file
[]

[Variables]
  [./wv]
  [../]
  [./wg]
  [../]
  [./etab]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./XolotlXeRate]
    order = FIRST
    family = LAGRANGE
  [../]
  [./XolotlXeMono]
    order = FIRST
    family = LAGRANGE
  [../]
  [./XolotlVolumeFraction]
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

  #For use of Grain Tracker
  [./unique_grains]
    order = FIRST
    family = MONOMIAL
  [../]
  [./var_indices]
    order = FIRST
    family = MONOMIAL
  [../]

  [./halos]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo0] #We need the 'op_num' number of halos here; so we need 8 halo variables
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo1]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo2]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo3]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo4]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo5]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo6]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo7]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo8]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo9]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo10]
   order = FIRST
   family = MONOMIAL
  [../]
  #[./halo11]
  #  order = FIRST
  #  family = MONOMIAL
  #[../]
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

  #For use of Grain Tracker
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
  [../]
  [./halo0]
    type = FeatureFloodCountAux
    variable = halo0
    map_index = 0
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo1]
    type = FeatureFloodCountAux
    variable = halo1
    map_index = 1
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo2]
    type = FeatureFloodCountAux
    variable = halo2
    map_index = 2
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo3]
    type = FeatureFloodCountAux
    variable = halo3
    map_index = 3
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo4]
    type = FeatureFloodCountAux
    variable = halo4
    map_index = 4
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo5]
    type = FeatureFloodCountAux
    variable = halo5
    map_index = 5
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo6]
    type = FeatureFloodCountAux
    variable = halo6
    map_index = 6
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo7]
    type = FeatureFloodCountAux
    variable = halo7
    map_index = 7
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo8]
    type = FeatureFloodCountAux
    variable = halo8
    map_index = 8
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo9]
    type = FeatureFloodCountAux
    variable = halo9
    map_index = 9
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo10]
   type = FeatureFloodCountAux
   variable = halo10
   map_index = 10
   field_display = HALOS
   flood_counter = grain_tracker
  [../]
  #[./halo11]
  #  type = FeatureFloodCountAux
  #  variable = halo11
  #  map_index = 11
  #  field_display = HALOS
  #  flood_counter = grain_tracker
  #[../]
[]

[ICs]
  [./IC_eta0]
    type = FunctionIC
    variable = eta0
    function = sln_fnc_eta0
  [../]
  [./IC_eta1]
    type = FunctionIC
    variable = eta1
    function = sln_fnc_eta1
  [../]
  [./IC_eta2]
    type = FunctionIC
    variable = eta2
    function = sln_fnc_eta2
  [../]
  [./IC_eta3]
    type = FunctionIC
    variable = eta3
    function = sln_fnc_eta3
  [../]
  [./IC_eta4]
    type = FunctionIC
    variable = eta4
    function = sln_fnc_eta4
  [../]
  [./IC_eta5]
    type = FunctionIC
    variable = eta5
    function = sln_fnc_eta5
  [../]
  [./IC_eta6]
    type = FunctionIC
    variable = eta6
    function = sln_fnc_eta6
  [../]
  [./IC_eta7]
    type = FunctionIC
    variable = eta7
    function = sln_fnc_eta7
  [../]
  [./IC_eta8]
    type = FunctionIC
    variable = eta8
    function = sln_fnc_eta8
  [../]
  [./IC_eta9]
    type = FunctionIC
    variable = eta9
    function = sln_fnc_eta9
  [../]
  [./IC_eta10]
    type = FunctionIC
    variable = eta10
    function = sln_fnc_eta10
  [../]
  [./IC_etab]
    type = FunctionIC
    variable = etab
    function = sln_fnc_etab
  [../]

  [./IC_chempot_wg]
    type = ConstantIC
    variable = wg
    value = 0.0
  [../]
  [./IC_chempot_wv]
    type = ConstantIC
    variable = wv
    value = 0.0
  [../]

[] #End of ICs block



[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[] #End of BCs block

[Modules]
  [./PhaseField]
    [./GrandPotential]
      # op_num = 10
      switching_function_names = 'hb hm'
      anisotropic ='false false'

      chemical_potentials = 'wv wg'
      mobilities = 'Dchiv Dchig'
      susceptibilities = 'chiv chig'
      free_energies_w = 'rhovbub rhovmatrix rhogbub rhogmatrix'

      gamma_gr = gmm
      mobility_name_gr = L
      kappa_gr = kappa
      free_energies_gr = 'omegab omegam'

      additional_ops = 'etab'
      gamma_grxop = gmb
      mobility_name_op = L
      kappa_op = kappa
      free_energies_op = 'omegab omegam'
    [../]
  [../]
[] #End of Modules block

[Kernels]
  #[./Source_v]
  # type = MaskedBodyForce
  # variable = wv
  # value = 1
  # mask = VacRate0
  #[../]
  [./Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 1
    mask = VacRate
  [../]

  #[./Source_g]
  # type = MaskedBodyForce
  # variable = wg
  # value = 1
  # mask = XeRate0
  #[../]
  [./Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 1 # for unit conversion between PF app and Xolotl
    mask = XeRate
  [../]
[] #End of Kernels block

# [AuxKernels]
#   [./BndsCalc]
#     type = BndsCalcAux
#     variable = bnds
#     execute_on = timestep_end
#   [../]
# []

[Materials]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    #all_etas = 'etab0 etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10 etam11'
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 etab'
    phase_etas = 'etab'
    #outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 etab'
    # phase_etas = 'etam0 etam1 etam2 etam3 etam4'
    #all_etas = 'etab0 etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10 etam11 etam12 etam13 etam14 etam15'
    phase_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10'
    #outputs = exodus
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
    prop_names =  'kappa     mu      L   Dm      Db     Va      cvbubeq  cgbubeq gmb 	gmm T     YXe'
    #prop_values = '0.84368e2 0.00293 0.1   2.3398  2.3398 0.0409  0.546    0.454   0.922  1.5 1200  0.2156'
    #prop_values = '0.84368e1 0.00293e-1 0.5   4.6796  4.6796  0.0409  0.546    0.454   0.922  1.5 1200  0.2156'
    prop_values = '0.84368e1 0.00293e-1 0.0049 2.3398 2.3398  0.0409  0.546    0.454   0.922  1.5 1800  0.25'
    #prop_values = '2.21125e2 1.875  0.975e-3 0.1  0.1  0.0409  0.546    0.454   0.922  1.5 1200  0.2156'
  [../]
  [./L_bub]
    type = ParsedMaterial
    f_name = L_bub
    material_property_names = 'L'
    function = '1e-6*L'
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
    #function = '3.00625e3' # in eV/nm^3
    #function = '7.516' # in eV/nm^3
    function = '0.11' # in eV/nm^3, decreased
    #outputs = exodus
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
    #function = '0.5625e3' # in eV/nm^3
    function = '1.406' # in eV/nm^3
    #function = '1.406e-2' # in eV/nm^3, decreased
    #outputs = exodus
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
    function = 'if(time < 0, 100*Db*chiv, Db*chiv)'
    #function = 'Db*chiv'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'Dm chig'
    args = 'time'
    function = 'if(time < 0, 100*Dm*chig, Dm*chig)'
    #function = 'Dm*chig'
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
    outputs = out
  [../]

  [./VacRate]
    type = ParsedMaterial
    f_name = VacRate
    material_property_names = 'XeRate YXe'
    function = 'XeRate / YXe'
    # outputs = exodus
  [../]

  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hm'
    constant_names = 's0'
    constant_expressions = '2.0e-9'  # in atoms/(nm^3 * s)
    args = 'time bnds'
    # function = 'if(time < 0, 0, s0 * hm)'
    function = 'if(time < 0, 0, if(bnds >= 0.9 ,s0, 0))'
    outputs = out
  [../]
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate0'
    args = 'time'
    function = 'if(time < 0, 0, XeRate0 / YXe)'
    outputs = out
  [../]

  [./cg]
    type = ParsedMaterial
    f_name = cg_from_rhog
    material_property_names = 'Va rhogbub rhogmatrix hm hb'
    function = 'hb*Va*rhogbub + hm*Va*rhogmatrix'
    outputs = out
  [../]
  [./cv]
    type = ParsedMaterial
    f_name = cv_from_rhov
    material_property_names = 'Va rhovbub rhovmatrix hm hb'
    function = 'hb*Va*rhovbub + hm*Va*rhovmatrix'
    outputs = out
  [../]
[]  #End of Materials block

[UserObjects]

  #[./hex_ic]
  #  type = PolycrystalHex
  #  coloring_algorithm = jp
  #  x_offset = 0
  #  #grain_num = 64  #already set by GlobalParam
  #[../]

  [./grain_tracker]
    type = GrainTracker
    # threshold = 0.5
    # connecting_threshold = 0.5
    threshold = 0.2
    connecting_threshold = 0.08
  [../]

  [./soln_uo]
    type = SolutionUserObject
    # mesh = This is provided by GlobalParams block
    # system_variables = This is provided in GlobalParams block
    # timestep = This is provided in GlobalParams block
  [../]
[] #End of UserObjects block

[Functions]
  [./sln_fnc_eta0]
    type = SolutionFunction
    from_variable = eta0
    solution = soln_uo
  [../]
  [./sln_fnc_eta1]
    type = SolutionFunction
    from_variable = eta1
    solution = soln_uo
  [../]
  [./sln_fnc_eta2]
    type = SolutionFunction
    from_variable = eta2
    solution = soln_uo
  [../]
  [./sln_fnc_eta3]
    type = SolutionFunction
    from_variable = eta3
    solution = soln_uo
  [../]
  [./sln_fnc_eta4]
    type = SolutionFunction
    from_variable = eta4
    solution = soln_uo
  [../]
  [./sln_fnc_eta5]
    type = SolutionFunction
    from_variable = eta5
    solution = soln_uo
  [../]
  [./sln_fnc_eta6]
    type = SolutionFunction
    from_variable = eta6
    solution = soln_uo
  [../]
  [./sln_fnc_eta7]
    type = SolutionFunction
    from_variable = eta7
    solution = soln_uo
  [../]
  [./sln_fnc_eta8]
    type = SolutionFunction
    from_variable = eta8
    solution = soln_uo
  [../]
  [./sln_fnc_eta9]
    type = SolutionFunction
    from_variable = eta9
    solution = soln_uo
  [../]
  [./sln_fnc_eta10]
    type = SolutionFunction
    from_variable = eta10
    solution = soln_uo
  [../]
  [./sln_fnc_etab]
    type = SolutionFunction
    from_variable = etab
    solution = soln_uo
  [../]
[] #End of Functions block


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
  # [./number_DOFs]
  #   type = NumDOFs
  # [../]
  # [./dt]
  #   type = TimestepSize
  # [../]
  [./numgrain]
    type = ElementExtremeValue
    variable = unique_grains
  [../]

  [./porosity]
    type = ElementAverageValue
    variable = etab
  [../]

  [./gas_conc_interg]
    type = ElementAverageValue
    variable = cg
  [../]

  [./gas_conc_intrag]
    type = ElementAverageValue
    variable = XolotlXeMono
  [../]

  [./porefrac_intrag]
    type = ElementAverageValue
    variable = XolotlVolumeFraction
  [../]

[] #End of Postprocessors block

[Preconditioning]
  [./SMP]
    type = SMP
    # full = true
    coupled_groups = 'etab,wg etab,wv'
  [../]
[] #End of Preconditioning block

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  # solve_type = NEWTON
  solve_type = PJFNK
  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu'
  # Use with solve_type = NEWTON in Executioner block
  petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = 'bjacobi  gmres     30'  # default is 30, the higher the higher resolution but the slower

  l_max_its = 15
  l_tol = 1.0e-5
  nl_rel_tol = 1.0e-8
  start_time = 0
  #num_steps = 1000
  end_time = 1.2e8
  # end_time = 1.0e6
  nl_abs_tol = 1e-10
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    growth_factor = 1.2
    cutback_factor = 0.8
    # adapt_log = true
  [../]
[] #End of Executioner block

[Outputs]
  [./out]
    type = Exodus
    interval = 10
    # interval = 1
    sync_times = '0 1.2e8'
    #sync_times = '0 1.0e6'
  [../]
  # [./out]
  #   type = Nemesis
  #   sync_times = '0 1.2e8'
  #   hide='cg cv unique_grains var_indices halos halo0 halo1 halo2 halo3 halo4 halo5 halo6 halo7 halo8 halo9 halo10'
  # [../]
  # checkpoint = true
  csv = true
  perf_graph = true
[] #End of Outputs block


[MultiApps]
  [./sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
input_files = 'xolotl_subapp.i'
app_type = coupling_xolotl_newApp
execute_on = TIMESTEP_END
library_path = 'lib'
[../]
[]

[Transfers]
[./fromsubrate]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = Auxv
variable = XolotlXeRate
execute_on = SAME_AS_MULTIAPP
[../]
[./fromsubmono]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = AuxMono
variable = XolotlXeMono
execute_on = SAME_AS_MULTIAPP
[../]
[./fromsubfrac]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = AuxFrac
variable = XolotlVolumeFraction
execute_on = SAME_AS_MULTIAPP
[../]
[./tosub]
type = MultiAppInterpolationTransfer
direction = to_multiapp
multi_app = sub_app
source_variable = bnds
variable = AuxGB
execute_on = TIMESTEP_BEGIN
[../]
[]
