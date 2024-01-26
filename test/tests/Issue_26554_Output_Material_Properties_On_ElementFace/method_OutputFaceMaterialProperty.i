# This is to test the 'LowerDBlockFromSidesetGenerator' to output material property on element faces.


[Mesh]
[./gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 4
  ny = 4
  nz = 2
  xmax = 0.1
  ymax = 0.1
  zmax = 0.01
  elem_type = HEX8 #TET4, HEX, HEX8
 []
 [SurfaceBlock]
    input = gmg   # breakmesh surface_FB
    type = LowerDBlockFromSidesetGenerator
    sidesets = 'top bottom left right'
    new_block_id = '2'
    new_block_name = 'surface_LRTB'
    show_info = True
  []
[]

[Outputs]
    file_base = Data_ElasticBasic_n1_Comp
    csv = true
    exodus = true
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Modules/TensorMechanics/Master/all]
  strain = FINITE
  add_variables = true
  #new_system = true
  #formulation = updated
  #volumetric_locking_correction = true
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
  end_time = 0.2
[]


[AuxVariables]
  [./pk2_yy_Surface]
    order = CONSTANT
    family = MONOMIAL
    block = surface_LRTB
  [../]
  [./pk2_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Aux_pk2_yy_Surface]
   type = RankTwoAux
   variable = pk2_yy_Surface
   rank_two_tensor = stress
   index_j = 1
   index_i = 1
   block = 'surface_LRTB'  
  [../]
  [./Aux_pk2_yy]
   type = RankTwoAux
   variable = pk2_yy
   rank_two_tensor = stress
   index_j = 1
   index_i = 1
  [../]
[]

[AuxVariables]
  [./F_yy_Surface]
    order = CONSTANT
    family = MONOMIAL
    block = surface_LRTB
  [../]
  [./F_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Aux_F_yy_Surface]
   type = RankTwoAux
   variable = F_yy_Surface
   rank_two_tensor = deformation_gradient
   index_j = 1
   index_i = 1
   block = 'surface_LRTB'  #'top bottom left '
  [../]
  [./Aux_F_yy]
   type = RankTwoAux
   variable = F_yy
   rank_two_tensor = deformation_gradient
   index_j = 1
   index_i = 1
  [../]
[]
