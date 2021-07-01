# Length unit: nm
# Time unit: s
# Energy unit: eV

[Mesh]
  type = FileMesh
  file = PFmulti_bubble_master_exodus.e  #nCnR
[]


[Variables]
  [./dummyvar]
  [../]
[]

[AuxVariables]
  [./etab0]
    order = FIRST
    family = LAGRANGE
  [../]
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
  [./cg]
    order = FIRST
    family = LAGRANGE
  [../]

  [./time]
  [../]
[]

[AuxKernels]
  [./time]
    type = FunctionAux
    variable = time
    function = 't'
  [../]
  [./solaux]
    type = SolutionAux
    variable = etab0
    solution = soln
    execute_on = 'TIMESTEP_END'
    direct = true
  [../]
  [./solaux_cg]
    type = SolutionAux
    variable = cg
    solution = soln_cg
    execute_on = 'TIMESTEP_END'
    direct = true
  [../]
  [./solaux_XolotlXeMono]
    type = SolutionAux
    variable = XolotlXeMono
    solution = soln_XolotlXeMono
    execute_on = 'TIMESTEP_END'
    direct = true
  [../]
  [./solaux_XolotlVolumeFraction]
    type = SolutionAux
    variable = XolotlVolumeFraction
    solution = soln_XolotlVolumeFraction
    execute_on = 'TIMESTEP_END'
    direct = true
  [../]
[]

[Kernels]
  [./timederivative]
    type = TimeDerivative
    variable = dummyvar
  [../]
[]

[UserObjects]
  [./soln]
    type = SolutionUserObject
    mesh = PFmulti_bubble_master_exodus.e
    #mesh = PFmulti_bubble_master_exodus_1Xe.e
    system_variables = etab0
  [../]
  [./soln_cg]
    type = SolutionUserObject
    mesh = PFmulti_bubble_master_exodus.e
    #mesh = PFmulti_bubble_master_exodus_1Xe.e
    system_variables = cg
  [../]
  [./soln_XolotlXeMono]
    type = SolutionUserObject
    mesh = PFmulti_bubble_master_exodus.e
    #mesh = PFmulti_bubble_master_exodus_1Xe.e
    system_variables = XolotlXeMono
  [../]
  [./soln_XolotlVolumeFraction]
    type = SolutionUserObject
    mesh = PFmulti_bubble_master_exodus.e
    #mesh = PFmulti_bubble_master_exodus_1Xe.e
    system_variables = XolotlVolumeFraction
  [../]
[]

[Executioner]
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
  start_time = -2e3
  #end_time = 1.2e8
  end_time = 2.4e8
  nl_abs_tol = 1e-10
  [./TimeStepper]
    type = ConstantDT
    dt = 1e6
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    #interval = 1000
    sync_times = '0 1.2e8 2.4e8'
    #sync_times = '0 1.2e8 2.4e8'
  [../]
  # checkpoint = true
  csv = true
  perf_graph = true
  file_base = PP_CnR_1800K
[]


[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  [./porosity]
    type = ElementAverageValue
    variable = etab0
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
[]
