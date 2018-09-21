
[Mesh]
  type = GeneratedMesh
  dim = 2
  # nx = 25
  # ny = 25
  nx = 100
  ny = 100
  xmin = 0
  xmax = 8
  ymin = 0
  ymax = 8
[]
[Variables]
  [./d]
  [../]
[]
[ICs]
  [./BoxcarIC]
    type = FunctionIC
    variable = d
    function = BoxcarFunc
  [../]
[]
[Functions]
  [./BoxcarFunc]
    type = RepeatedBoxcarFunction2D
    xs = 0
    ys = 1
    nbumps = 4
    pitch_length = 2
    bump_height = 1
    diffusive_length = 0.1
    above_value = 0
    below_value = 1
  [../]
[]
[Executioner]
  type = Transient
  dt = 1
  end_time = 10
  # [./Adaptivity]
  #   initial_adaptivity = 2
  #   max_h_level = 2
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.005
  #   weight_names =  'd'
  #   weight_values = '1'
  # [../]
[]
[Problem]
  kernel_coverage_check = false
  solve = false
[]
[Outputs]
  exodus = true
[]
