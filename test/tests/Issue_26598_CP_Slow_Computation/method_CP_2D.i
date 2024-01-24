[Mesh] 
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 100
    ny = 100
    xmax = 1
    ymax = 1
    elem_type = tri3
  []
    
[]


[GlobalParams]
  displacements = 'disp_x disp_y'
[]  
[Variables]
  [./disp_x]
  [../]
  [./disp_y] 
  [../]
[]  
    
[Modules]
[./TensorMechanics]
    [./Master]
      [./All]
        add_variables = true
        strain = FINITE # SMALL
        save_in = 'resid_x resid_y'
        additional_generate_output = stress_yy
      [../]
    [../]
[../]
[]

[BCs]
 [./bottomy]
    type = DirichletBC
    variable = disp_y
    boundary =bottom
    value = 0.0
   [../]
  [./topy]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function ='-1.0e-3*t'
   [../]
  [./rightx]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0
   [../]
[]



[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensorCP
    C_ijkl = '43.582e3  15.18e3  15.18e3  43.582e3 15.18e3  43.582e3   14.701e3 14.701e3  14.701e3'
    fill_method = symmetric9
    #read_prop_user_object = prop_read
  [../]
   [stress_copper]
    type = ComputeMultipleCrystalPlasticityStress
    crystal_plasticity_models = 'trial_xtalpl'
    tan_mod_type = exact
    maximum_substep_iteration = 10
  []
  [trial_xtalpl]
    type = CrystalPlasticityKalidindiUpdate
    number_slip_systems = 12
    slip_sys_file_name = ./input_slip_sys.txt
    ao = 1.0e-3
    gss_a =5.0
    gss_initial = 5
    h = 1000.0
    r =1.
    xm = 0.05
    t_sat = 10.
    resistance_tol = 0.05
    slip_increment_tolerance = 0.02
    stol = 0.01
    use_displaced_mesh = true
  []
[]

[AuxVariables]
[./resid_x]
  [../]
  [./resid_y]
  [../]
[]

[UserObjects]
#inactive = 'prop_read '
  [./prop_read]
    type = PropertyReadFile
    prop_file_name = 'input_euler.txt'
    nprop = 4
    read_type = grain
    nvoronoi = 20
    use_random_voronoi = true
    rand_seed = 777
    rve_type = periodic
  [../]
[]


[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist                 '
  automatic_scaling = true

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_max_its = 10
  dt = 1e-2
  end_time = 200.0

[]

[Outputs]
  exodus = true
  interval = 1
  [./table]
    interval = 1
    type = CSV
   # delimiter = ' '
  [../]
[]

