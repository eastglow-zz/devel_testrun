# Length unit: nm
# Time unit: s
# Energy unit: eV


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
  #SolutionUserObject parameters
  # mesh = IC_bub_poly_2.e
  mesh = './10gr1000K_ps_etab/CnR/GPM_GT_ic_from_file_out.e'
  system_variables = 'bnds etab cg'
  # timestep = 0 # Time step number (not time) that will be extracted from the exodus file
  # timestep = 115 # Time step number (not time) that will be extracted from the exodus file
  # timestep = 95 # Time step number (not time) that will be extracted from the exodus file

  file_base = './10gr1000K_ps_etab/CnR/etab_filtered'
[]

[Variables]
  [./dummyvar]
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

  [./etab_f]
    order = FIRST
    family = MONOMIAL
  [../]

  [./cg]
    order = FIRST
    family = LAGRANGE
  [../]

  [./cg_f]
    order = FIRST
    family = MONOMIAL
  [../]

  [./interXe]
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

  #For use of Grain Tracker
  # [./BndsCalc]
  #   type = BndsCalcAux
  #   variable = bnds
  #   execute_on = 'initial timestep_end'
  # [../]

  [./solaux_etab]
    type = SolutionAux
    variable = etab
    solution = soln_uo
    execute_on = 'TIMESTEP_END'
    direct = true
    from_variable = etab
  [../]

  [./solaux_cg]
    type = SolutionAux
    variable = cg
    solution = soln_uo
    execute_on = 'TIMESTEP_END'
    direct = true
    from_variable = cg
  [../]

  [./solaux_bnds]
    type = SolutionAux
    variable = bnds
    solution = soln_uo
    execute_on = 'TIMESTEP_END'
    direct = true
    from_variable = bnds
  [../]

  [./etab_f_save]
    type = MaterialRealAux
    variable = etab_f
    property = etab_filtered
  [../]

  [./cg_f_save]
    type = MaterialRealAux
    variable = cg_f
    property = cg_filtered
  [../]

  [./interXe_save]
    type = MaterialRealAux
    variable = interXe
    property = interGvolFrac_filtered
  [../]
[]

[Kernels]
  [./dummyvar_time_derivative]
    type = TimeDerivative
    variable = dummyvar
  [../]

[]

[Materials]
  [./gb_stepfnc]
    type = ParsedMaterial
    f_name = gb_stepfnc
    args = 'bnds etab'
    function = '(-0.5*tanh((bnds-0.8)/0.01)-0.5*tanh((etab-0.8)/0.01))/480'

  [../]
  [./etab_filtered]
    type = ParsedMaterial
    f_name = etab_filtered
    args = 'etab'
    # function = '(0.5+0.5*tanh((etab-0.39)/0.05))*(0.5+0.5*tanh((time-1e6)/1e6)) + etab*(0.5-0.5*tanh((time-1e6)/1e6))'
    function = '(0.5+0.5*tanh((etab-0.5)/0.1))'
    # function = 'etab'
  [../]

  [./cg_filtered]
    type = ParsedMaterial
    f_name = cg_filtered
    args = 'cg'
    function = 'if(cg < 0, 0, cg)'
  [../]


  [./interGvolFrac_filtered]
    type = ParsedMaterial
    f_name = interGvolFrac_filtered
    material_property_names = 'etab_filtered cg_filtered'
    args = 'bnds'
    function = 'if(bnds < 0.9, cg_filtered, 0)'
    # function = 'etab'
  [../]
[]

[UserObjects]

  [./soln_uo]
    type = SolutionUserObject
    # mesh = This is provided by GlobalParams block
    # system_variables = This is provided in GlobalParams block
    # timestep = This is provided in GlobalParams block
  [../]

[]

[Postprocessors]

  [./etab_ps_filtered]
    type = ElementAverageValue
    variable = etab_f
  [../]

  [./interXe_ps_filtered]
    type = ElementAverageValue
    variable = interXe
  [../]

  [./cg_f]
    type = ElementAverageValue
    variable = cg_f
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
  end_time = 1.2e8
  # end_time = 7.44e7
  nl_abs_tol = 1e-10

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    growth_factor = 1.2
    cutback_factor = 0.8
    # adapt_log = true
  [../]
  dtmax = 1e6
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
