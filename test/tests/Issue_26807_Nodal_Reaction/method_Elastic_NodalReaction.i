[Mesh]
[./gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmax = 0.1
  ymax = 0.1
  zmax = 0.1
  elem_type = HEX8 #TET4, HEX, HEX8
  show_info = true
 []
[]

[Outputs]
    file_base = Data_Elastic_n1_Comp_NodalReaction
    csv = true
    exodus = true
    append_date = true
    append_date_format = '%Y-%m-%d-%H-%M-%S'
  [./my_checkpoint]
    type = Checkpoint
    num_files = 10
    interval = 3
  [../]
[]


[Problem]
  type = FEProblem
  #solve = false
  #restart_file_base = Data_ElasticBasic_n1_Comp_2024-02-05-15-42-22_cp/LATEST
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[AuxVariables]
  [./Residual_Nodal_X]
  [../]
  [./Residual_Nodal_Y]
  [../]
  [./Residual_Nodal_Z]
  [../]

  [./resid_x]
  [../]
  [./resid_y]
  [../]
[]

[Modules/TensorMechanics/Master/all]
  strain = FINITE
  add_variables = true
  #new_system = true
  #formulation = updated
  #volumetric_locking_correction = true
  save_in = 'Residual_Nodal_X Residual_Nodal_Y Residual_Nodal_Z '
[]

[Kernels]
  [./res_y]
    type = StressDivergenceTensors
    component = 1
    variable =disp_y
    save_in = 'resid_y'
  [../]
  [./res_x]
    type = StressDivergenceTensors
    component =0
    variable =disp_x
    save_in = 'resid_x'
  [../]
[]

[Materials]
  [./elasticity_tensor_iso]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.68e5
    poissons_ratio = 0.25
  [../]
  [./compute_stress]
    type = ComputeFiniteStrainElasticStress
  [../]
[]


[BCs]
  [./BC_All_Y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 'top '
    function = '(-0.1)*y*t'
  [../]

  [./BC_BottomLeft_X]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'bottom'  # mid_nodes, left_bottom_node back_bottom_node
    function = 0.0
  [../]
   [./BC_BottomLeft_Y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 'bottom' # mid_nodes, left_bottom_node
    function = 0.0
  [../]
   [./BC_BottomBack_Z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 'bottom'  #'back_bottom_node'
    function = 0.0
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
  solve_type = 'PJFNK' #'NEWTON' , 'PJFNK'
  automatic_scaling = false # 'true' will give segfault due to memory issue
  #scaling_group_variables = 'disp_x disp_y disp_z; Rho_EdgePositive Rho_EdgeNegative'
  #petsc_options = '-pc_svd_monitor'
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
  nl_abs_tol = 1e-5  #1e-10 for all *_tol
  nl_rel_tol = 1e-5
  nl_abs_step_tol = 1e-5
  nl_max_its = 10
  l_abs_tol = 1e-5
  l_tol = 1e-5
  l_max_its = 20

  dt = 0.05
  dtmin = 0.0001
  dtmax = 0.1
  #end_time = 0.2
   num_steps = 50
[]


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

[Postprocessors]
  [./react_x]
    type = SidesetReaction
    direction = '1 0 0'
    stress_tensor = stress
    boundary = bottom
  [../]
[]
