#Run with 4 procs
[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  #volumetric_locking_correction = true
[]

[Mesh]
inactive = 'split '
  construct_side_list_from_node_list=true
  [file]
    type = FileMeshGenerator
    file = 200-ori.msh
  []
  [split]
    type = BreakMeshByBlockGenerator 
    input = file
    ### If you want to use 'breaknesh', you need to constrain the displacement among nodes across the interface. 
    ### otherwise the applied deformation at the boundary will no propagate across the domain.
  []
  [create_x0]
    type = BoundingBoxNodeSetGenerator
    input = file
    new_boundary = x0
    top_right = '0.001 1.001 1.001'
    bottom_left = '-0.001 -0.001 -0.001'
  []
  [create_y0]
    type = BoundingBoxNodeSetGenerator
    input = create_x0
    new_boundary = y0
    top_right = '1.001 0.001 1.001'
    bottom_left = '-0.001 -0.001 -0.001'
  []
  [create_z0]
    type = BoundingBoxNodeSetGenerator
    input = create_y0
    new_boundary = z0
    top_right = '1.001 1.001 0.001'
    bottom_left = '-0.001 -0.001 -0.001'
  []
  [create_z1]
    type = BoundingBoxNodeSetGenerator
    input = create_z0
    new_boundary = z1
    top_right = '1.001 1.001 1.001'
    bottom_left = '-0.001 -0.001 0.999'
  []
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./TensorMechanics]
    strain = FINITE
    add_variables = true
  [../]
[]

[UserObjects]
  [./prop_read]
    type = PropertyReadFile  ### ElementPropertyReadFile this is deprecated
    prop_file_name = '200-ori.inp'
    # Enter file data as prop#1, prop#2, .., prop#nprop
    nprop = 3
    read_type = grain
    ngrain = 200
  [../]
[]

[BCs]
inactive = 'right_x1_Neumann'
  [./left_x1]
    type = DirichletBC
    variable = disp_x
    boundary = z1
    value = 0.0
  [../]
  [./left_x2]
    type = DirichletBC
    variable = disp_y
    boundary = z1
    value = 0.0
  [../]
  [./left_x3]
    type = DirichletBC
    variable = disp_z
    boundary = z1
    value = 0.0
  [../]
  [./right_x1_Dirtch]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = z0
    function = '0.1*t'
    preset = false
  [../]
  [./right_x1_Neumann]
    type = FunctionNeumannBC
    variable = disp_z
    boundary = z0
    function  = '-2.5e7*t' ### That' very large magnitude NeumannBC, domain size is 1X1X1, in mm
  [../]
[]


[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensorCP #ComputeElasticityTensor
    C_ijkl = '5.93e10 2.57e10 2.14e10 5.93e10 2.14e10 6.15e10 1.64e10 1.64e10 1.68e10' # too large, unit MPa
    #base_name = 'euler'  ### if base name used here then also in stress calculation
    fill_method = symmetric9
    read_prop_user_object = prop_read # ComputeElasticityTensor does not take this input
    [../]
    [./strain]
      type = ComputeSmallStrain
      #eigenstrain_names = eigenstrain
      #base_name = 'euler'
    [../]
    [./stress]
      type = ComputeLinearElasticStress
      #base_name = 'euler'
    [../]
  []

  [Preconditioning]
    [./smp]
      type = SMP
      full = true
    [../]
  []

  [Executioner]
    type = Transient #Steady ### Use Transient, to get to that deformation gradually.
    solve_type = 'PJFNK'
    
    #petsc_options_iname = '-pc_type -ksp_gmres_restart'
    #petsc_options_value = 'lu       101'
      petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'
    line_search = 'none'

    #nl_abs_tol = 1e-11
    nl_rel_tol = 1e-5
    l_max_its = 30
    dt = 0.1
    end_time = 1

  []

  [Outputs]
    exodus = true
  []

### Get few more field output

[AuxVariables]
  [./pk2_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Aux_pk2_yy]
   type = RankTwoAux
   variable = pk2_yy
   rank_two_tensor = stress
   index_j = 1
   index_i = 1
  [../]
[]