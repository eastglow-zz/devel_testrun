# Take aways:
# DistributedGeneratedMesh works only for the FIRST order element types: EDGE2, QUAD4, and HEX8


[Mesh]
  type = DistributedGeneratedMesh
  parallel_type = DISTRIBUTED
  # type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./c_box]
    type = BoundingBoxIC
    variable = c
    x1 = 40
    x2 = 60
    y1 = 40
    y2 = 60
    inside = 1
    outside = 0
  [../]
[../]

[Kernels]
  [./cdot]
    type = TimeDerivative
    variable = c
  [../]

  [./c_diffu]
    type = Diffusion
    variable = c
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
  start_time = 0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.001
  [../]
[]

[Outputs]
  exodus = true
[]
