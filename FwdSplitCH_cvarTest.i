
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 4
  xmax = 4
  ymax = 4
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
  [./c1]
  [../]
  [./c2]
  [../]
  [./dcx]
    order = FIRST
    family = LAGRANGE
  [../]
  [./dcy]
    order = FIRST
    family = LAGRANGE
  [../]
  [./dc1x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./dc1y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./dc2x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./dc2y]
    order = FIRST
    family = LAGRANGE
  [../]
[]



[ICs]
  [./c_squareIC]
    type = BoundingBoxIC
    variable = c
    x1 = 2
    x2 = 3
    y1 = 2
    y2 = 3
    inside = -1
    outside = 0
  [../]
  [./w_squareIC]
    type = BoundingBoxIC
    variable = w
    x1 = 2
    x2 = 3
    y1 = 2
    y2 = 3
    inside = -1
    outside = 0
  [../]
  [./c1]
    type = ConstantIC
    variable = c1
    value = 1
  [../]
  [./c2]
    type = ConstantIC
    variable = c2
    value = 2
  [../]
[]

[BCs]
[]

[Kernels]
  [./calc_dcx]
    type = CoupledGradComponent
    variable = dcx
    arg = 'c'
    component = x
  [../]
  [./calc_dcy]
    type = CoupledGradComponent
    variable = dcy
    arg = 'c'
    component = y
  [../]

  [./calc_dc1x]
    type = CoupledGradComponent
    variable = dc1x
    arg = 'c1'
    component = x
  [../]
  [./calc_dc1y]
    type = CoupledGradComponent
    variable = dc1y
    arg = 'c1'
    component = y
  [../]

  [./calc_dc2x]
    type = CoupledGradComponent
    variable = dc2x
    arg = 'c2'
    component = x
  [../]
  [./calc_dc2y]
    type = CoupledGradComponent
    variable = dc2y
    arg = 'c2'
    component = y
  [../]

  [./cdot]
    type = TimeDerivative
    variable = c
  [../]

  [./FwdSplitCH_debug]
    type = FwdSplitCH
    variable = c
    mu_name = w
    mob_name = Mtest
    var_grad_components = 'dcx dcy'
    coupled_vars = 'c1 c2'
    coupled_var_grad_components = 'dc1x dc1y dc2x dc2y'
  [../]

  [./w]
    type = TimeDerivative
    variable = w
  [../]
  [./c1]
    type = TimeDerivative
    variable = c1
  [../]
  [./c2]
    type = TimeDerivative
    variable = c2
  [../]

[]

[Materials]

  [./Mtest]
    type = DerivativeParsedMaterial
    f_name = Mtest
    args = 'c dcx dcy c1 c2 dc1x dc1y dc2x dc2y'
    function = 'c + 2*dcx + 3*dcy + 4*c1 + 5*c2 + 6*dc1x + 7*dc1y + 8*dc2x + 9*dc2y'
    derivative_order = 1
  [../]

[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  dt = 1
  end_time = 2
  dtmin = 0.5
[]

[Outputs]
  exodus = true
[]
