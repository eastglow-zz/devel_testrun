
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
  #type = FileMesh
  #file = notch.msh
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./c_squareIC]
    type = BoundingBoxIC
    variable = c
    x1 = 30
    x2 = 70
    y1 = 30
    y2 = 70
    inside = 1
    outside = 0
  [../]
  [./w_IC]
    type = ConstantIC
    variable = w
    value = 0
  [../]
[]

[BCs]
[]

[Kernels]
  # Rc part
  [./cdot]
    type = TimeDerivative
    variable = c
  [../]

  [./div_grad_w_term]
    type = SimpleCoupledACInterface
    variable = c
    v = w
    kappa_name = Mc
    mob_name = One
  [../]

  # Rw part
  [./w_itself_neg]
    type = MassEigenKernel
    variable = w
    eigen = false
  [../]

  [./doublewell_term]
    type = CoupledAllenCahn
    variable = w
    v = c
    f_name = f_doublewell
    mob_name = One
  [../]

  [./laplacian_c_term]
    type = SimpleCoupledACInterface
    variable = w
    v = c
    kappa_name = kappa_c
    mob_name = One
  [../]
[]

[Materials]
  [./Constants]
    type = GenericConstantMaterial
    prop_names = 'One negOne Mc kappa_c height'
    prop_values = '1  -1     1  1       1'
  [../]

  [./doublewell]
    type = DerivativeParsedMaterial
    f_name = f_doublewell
    material_property_names = 'height'
    args = 'c'
    function = 'height*c^2*(1-c)^2'
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

  #petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  #petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 50
  l_tol = 1e-5
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-6
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  #end_time = 20.0
  #end_time = 2000.0
  # adaptive mesh to resolve an interface
  #[./Adaptivity]
  #  initial_adaptivity    = 1             # Number of times mesh is adapted to initial condition
  #  refine_fraction       = 0.7           # Fraction of high error that will be refined
  #  coarsen_fraction      = 0.1           # Fraction of low error that will coarsened
  #  max_h_level           = 3             # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #  weight_names          = 'c	 '
  #  weight_values         = '1  '
  #[../]
[]

[Outputs]
  exodus = true
[]
