# Length unit: nm
# Time unit: s
# Energy unit: eV

#Relative path also available when running in the application directory
#XolotlWrapperPath = './xolotl_userobj.i'

#Absolute path is neccessary when running from a remote directory
#XolotlWrapperPath = '/Users/donguk.kim/projects/coupling_xolotl/xolotl_userobj.i'    #for Mac
#XolotlWrapperPath = '/home/donguk.kim/projects/coupling_xolotl/xolotl_userobj.i'    #for UF HPG2
#XolotlWrapperPath = '/home/donguk.kim/projects/coupling_xolotl/xolotl_userobj_20umsq_10dx0.i'    #for UF HPG2
#XolotlWrapperPath = './XolotlWrapp_Sc_x4_CnR.i'

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
[]

[GlobalParams]
  op_num = 11
  grain_num = 64
  var_name_base = eta
  # numbub = 16
  # bubspac = 2500
  # radius = 480
  int_width = 480
  #invalue = 1
  #outvalue = 0
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./etab]
    order = FIRST
    family = LAGRANGE
  [../]

  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]

  [./time]
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

  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
    
    # [./PolycrystalVoronoiVoidIC]
    #   invalue = 1.0
    #   outvalue = 0.0
    #   # op_num = 10
    #   polycrystal_ic_uo = voronoi
    #   structure_type = grains
    # [../]
  [../]
  # [./bubble_IC]
  #   variable = etab
  #   type = PolycrystalVoronoiVoidIC
  #   structure_type = voids
  #   invalue = 1.0
  #   outvalue = 0.0
  #   polycrystal_ic_uo = voronoi
  # [../]
  [./bubble_IC_zero]
    variable = etab
    type = ConstantIC
    value = 0.0
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
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
    # c = etab
  [../]

[]

# [AuxKernels]
#   [./BndsCalc]
#     type = BndsCalcAux
#     variable = bnds
#     execute_on = timestep_end
#   [../]
# []

[Materials]
  [./CuGrGr]
    # Material properties
    type = GBEvolution
    T = 450 # Constant temperature of the simulation (for mobility calculation)
    wGB = 480 # Width of the diffuse GB
    GBmob0 = 2.5e-6 #m^4(Js) for copper from Schoenfelder1997
    Q = 0.23 #eV for copper from Schoenfelder1997
    GBenergy = 0.708 #J/m^2 from Schoenfelder1997
  [../]

[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    rand_seed = 2
    # int_width = 480
    coloring_algorithm = jp
    output_adjacency_matrix = false
  [../]

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
  solve_type = NEWTON
  #solve_type = PJFNK
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
  #end_time = 1.2e8
  end_time = 1.0e8
  nl_abs_tol = 1e-10
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    growth_factor = 1.2
    cutback_factor = 0.8
    # adapt_log = true
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    interval = 1
    # interval = 1
    sync_times = '0 1.2e8'
    #sync_times = '0 1.0e6'
  [../]
  # checkpoint = true
  csv = true
  perf_graph = true
[]
