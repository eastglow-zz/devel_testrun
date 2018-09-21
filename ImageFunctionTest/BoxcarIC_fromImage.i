
[Mesh]
  type = ImageMesh
  cells_per_pixel = 1
  dim = 2
  file = Boxcar.png
[]
[Variables]
  [./d]
  [../]
[]
[ICs]
  [./BoxcarIC]
    type = FunctionIC
    variable = d
    function = Boxcar_from_image
  [../]
[]
[Functions]
  [./Boxcar_from_image]
    type = ImageFunction
    file = Boxcar.png
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
