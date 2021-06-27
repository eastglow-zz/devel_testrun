# Ternary plotting
# (x,y) = (0,0): (c1, c2, c3) = (1, 0, 0)
# (x,y) = (1,0): (c1, c2, c3) = (0, 1, 0)
# (x, y) = (0.5, 0.86602540378): (c1, c2, c3) = (0, 0, 1)
# The transform formula (https://en.wikipedia.org/wiki/Ternary_plot)
# (x, y) = (0.5*(2*c2+c3)/(c1+c2+c3), 0.5*sqrt(3)*c3/(c1+c2+c3))
# , whice becomes (x, y) = (c2 + 0.5*c3, 0.5*sqrt(3)*c3).
# Thus, inverse relation is derived as:
# c3 = 2*y/sqrt(3)
# c2 = x - y/sqrt(3)
# c1 = 1 - c2 - c3 = 1 - x - y/sqrt(3)

interwidth = 5 #Target full-interfacial Width
alpha = 5.8888779583  # 2*ln(0.95/0.05)


[Mesh]
  type = FileMesh
  file = Triangle_extended.msh
[]

[Variables]
  [./c1]
  [../]
  [./c2]
  [../]
  [./c3]
  [../]
[]

[ICs]
  [./define_c1]
    type = FunctionIC
    variable = c1
    function = xy_to_c1
  [../]
  [./define_c2]
    type = FunctionIC
    variable = c2
    function = xy_to_c2
  [../]
  [./define_c3]
    type = FunctionIC
    variable = c3
    function = xy_to_c3
  [../]
[]

[Functions]
  [./xy_to_c1]
    type = ParsedFunction
    value = '1 - x - y/sqrt(3)'
  [../]
  [./xy_to_c2]
    type = ParsedFunction
    value = 'x - y/sqrt(3)'
  [../]
  [./xy_to_c3]
    type = ParsedFunction
    value = '2*y/sqrt(3)'
  [../]
[]

[Materials]
  [./Constants]
    type = GenericConstantMaterial
    prop_names =  'sig_12 sig_23 sig_31 One negOne'
    prop_values = '1      1      1      1   1'
  [../]
  [./dwh_12]
    type = ParsedMaterial
    f_name = dwh_12
    material_property_names = 'sig_12'
    function = '3*${alpha}*sig_12/${interwidth}'
  [../]
  [./dwh_23]
    type = ParsedMaterial
    f_name = dwh_23
    material_property_names = 'sig_23'
    function = '3*${alpha}*sig_23/${interwidth}'
  [../]
  [./dwh_31]
    type = ParsedMaterial
    f_name = dwh_31
    material_property_names = 'sig_31'
    function = '3*${alpha}*sig_31/${interwidth}'
  [../]

  [./DW_double]
    type = DerivativeParsedMaterial
    f_name = DW_2
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = 'dwh_12*c1^2*c2^2 + dwh_23*c2^2*c3^2 + dwh_31*c3^2*c1^2'
    derivative_order = 2
    outputs = exodus
  [../]

  [./DW_triple]
    type = DerivativeParsedMaterial
    f_name = DW_3
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = '16 * max(dwh_12, max(dwh_23,dwh_31)) * c1^2*c2^2*c3^2'
    derivative_order = 2
    outputs = exodus
  [../]

  [./DW_saddle]
    type = DerivativeParsedMaterial
    f_name = DW_saddle
    material_property_names = 'a1 a2 a3'
    args = 'c1 c2 c3'
    function = 'c1*c2*c3*(a1*c1 + a2*c2 + a3*c3)'
    derivative_order = 2
    outputs = exodus
  [../]

  [./DW_saddle_sq]
    type = DerivativeParsedMaterial
    f_name = DW_saddle_sq
    material_property_names = 'a1 a2 a3'
    args = 'c1 c2 c3'
    function = '(c1*c2*c3*(a1*c1 + a2*c2 + a3*c3))^2'
    derivative_order = 2
    outputs = exodus
  [../]

  [./DWLO_2]
    type = DerivativeParsedMaterial
    f_name = DWLO_2
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = 'dwh_12*c1*c2 + dwh_23*c2*c3 + dwh_31*c3*c1'
    derivative_order = 2
    outputs = exodus
  [../]

  [./a1]
    type = ParsedMaterial
    f_name = a1
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = 'dwh_12 + dwh_31 - dwh_23'
  [../]
  [./a2]
    type = ParsedMaterial
    f_name = a2
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = 'dwh_12 + dwh_23 - dwh_31'
  [../]
  [./a3]
    type = ParsedMaterial
    f_name = a3
    material_property_names = 'dwh_12 dwh_23 dwh_31'
    args = 'c1 c2 c3'
    function = 'dwh_23 + dwh_31 - dwh_12'
  [../]

  [./DW_tot]
    type = DerivativeParsedMaterial
    f_name = fbulk
    material_property_names = 'DW_2(c1,c2,c3) DW_3(c1,c2,c3) DW_saddle(c1,c2,c3)'
    args = 'c1 c2 c3'
    function = 'DW_2 + DW_saddle'
    derivative_order = 2
    outputs = exodus
  [../]
[]

[Executioner]
  type = Transient
  dt = 1
  end_time = 1
[]

[Problem]
  kernel_coverage_check = false
  solve = false
[]

[Outputs]
  exodus = true
[]
