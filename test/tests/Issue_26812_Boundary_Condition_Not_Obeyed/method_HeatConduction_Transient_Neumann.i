[Mesh]
[./gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 10
  ny = 2
  nz = 2
  xmax = 5
  ymax = 1
  zmax = 1
  elem_type = HEX8 #TET4, TET10, HEX, HEX8
  #show_info = True
 []
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = u
  [../]

  [./ie]
    type = SpecificHeatConductionTimeDerivative
    variable = u
  [../]
[]

[ICs]
  [./ic_u]
    type = ConstantIC
    variable = u
    value = 0.1
  [../]
[]

[BCs]
inactive = 'BC_right_Dir ' # 
#inactive = 'BC_right_Neu '
  [./BC_left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0.0
  [../]

  [./BC_right_Dir]
    type = DirichletBC
    variable = u
    boundary = right
    value = 2.0
    #preset = false
  [../]

  [./BC_right_Neu]
    type = NeumannBC
    variable = u
    boundary = right
    value = 0
  [../]
[]

[Materials]
  [./constant]
    type = HeatConductionMaterial
    #block = 1
    thermal_conductivity = 1
    specific_heat = 1
  [../]
  [./density]
    type = Density
    #block = 1
    density = 1
  [../]
[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'



  start_time = 0.0
  num_steps = 200
  dt = .1
[]

[Outputs]
  file_base = out
  exodus = true
[]
