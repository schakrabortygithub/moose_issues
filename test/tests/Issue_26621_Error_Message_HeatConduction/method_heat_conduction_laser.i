# From https://github.com/idaholab/moose/discussions/26621
# Error message #26621

[Mesh]
  [generated_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 100
    ny = 100
    nz = 40
    xmax = 1000
    ymax = 1000
    zmax = 100
  []
[]

[Variables]
  [temperature]
    initial_condition = 473
  []
[]

[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = temperature
  []

  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = temperature
  []

  [laser_heat_source]
    type = ADMatHeatSource
    material_property = volumetric_heat
    variable = temperature
  []
[]

[BCs]
  [back_fixed_temperature]
    type = ADDirichletBC
    variable = temperature
    boundary = back
    value = 473
  []
  [front_convection]
    type = HeatConvectionOutFlow
    variable = temperature
    boundary = front
    value = 298
  []
  [front_radiation]
    type = HeatRadiationOutFlow
    variable = temperature
    boundary = front
    value = 298
  []
[]

[Materials]
  [Constant]
    type = ADGenericConstantMaterial
    prop_names = ' radiation_heat_transfer_coefficient convective_heat_transfer_                                                                                                             coefficient T_infinity '
    prop_values = ' 4.536e-20 11.2e-12 298 '
  []

  [Column]
  type = PackedColumn
  temperature = temperature
  thermal_conductivity_file = data/data/thermal_conductivity_file3.csv                                                                                                                       
  heat_capacity_file = data/data/heat_capacity_file3.csv                                                                                                                                     
  density_file = data/data/density_file3.csv                                                                                                                                                 
  outputs = exodus
  []

  [volumetric_heat]
  type= FunctionPathEllipsoidHeatSource
  rx = 28
  ry = 50
  rz = 40
  power = 100
  efficiency = 0.4
  factor = 1
  function_x = path_x
  function_y = path_y
  function_z = path_z
  []
[]

[Functions]
  [path_x]
  type = ParsedFunction
  value = 500
  []

  [path_y]
  type = ParsedFunction
  value = 0.8e6*t
  []

  [path_z]
  type = ParsedFunction
  value = 100
  []
[]

[Problem]
  type = FEProblem
[]

[VectorPostprocessors]
  [t_sampler]
    type = LineValueSampler
    variable = temperature
    start_point = '500 500 0'
    end_point = '500 500 100'
    num_points = 40
    sort_by = z
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 3e-3

  dt = 2e-5
  dtmin = 1e-8

  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'

  steady_state_tolerance = 10e-4
  steady_state_detection = true


[]

[Controls]
  [Laser_Source]
   type = TimePeriod
   disable_objects = 'Kernels/laser_heat_source'
   start_time = '1.25e-3'
   execute_on  = 'initial timestep_begin'
  []
  [Radiation]
   type = TimePeriod
   disable_objects = 'BCs/front_radiation'
   start_time = '1.25e-3'
   execute_on  = 'initial timestep_begin'
  []
[]

[Outputs]
  exodus = true

  [csv]
    type = CSV
    file_base = excel_Al12Si/additive_manufacturing_temperature_profile_output_A
    start_time = 0.0
    end_time = 3e-3
    interval = 1
    execute_on = timestep_end
  []
[]


