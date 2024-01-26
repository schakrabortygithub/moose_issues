# This is to test the restart capability of a Crystal Plasticity Simulation.
#. First run the script by commenting 'restart_file_base' in the 'Problem' block
#. Then restart the simulation from the generated checkpoint

[Mesh]
[./gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 2
  ny = 2
  nz = 2
  xmax = 0.1
  ymax = 0.1
  zmax = 0.01
  elem_type = HEX8 #TET4
 [../]
[]

[Outputs]
    file_base = Data_CP_Comp
    csv = true
    exodus = true
  [./my_checkpoint]
    type = Checkpoint
    num_files = 2
    interval = 5
  [../]
[]

[Problem]
  type = FEProblem
  #solve = false
  restart_file_base = Data_CP_Comp_cp/LATEST
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Modules/TensorMechanics/Master/all]
  strain = FINITE
  add_variables = true  
[]


[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensorCP
    C_ijkl = '1.684e5 1.214e5 1.214e5 1.684e5 1.214e5 1.684e5 0.754e5 0.754e5 0.754e5'
    fill_method = symmetric9
  [../]
  [./stress]
    type = ComputeMultipleCrystalPlasticityStress
    crystal_plasticity_models = 'trial_xtalpl'
    tan_mod_type = exact
    abs_tol = 1.0e-02
  [../]
  [./trial_xtalpl]
    type = CrystalPlasticityKalidindiUpdate
    number_slip_systems = 12
    slip_sys_file_name = input_slip_sys.inp
  [../]
[]

[BCs]
  [./BC_disp_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'bottom'
    function = '0.0'
  [../] 
  [./BC_disp_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 'top bottom'
    function = '(0.0*x + (-0.1)*y + 0.0*z)*t'
  [../]
  [./BC_disp_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 'bottom'
    function = '0.0'
  [../]
[]


[Executioner]
  type = Transient
  solve_type = 'PJFNK' #'NEWTON' 'PJFNK'
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
  nl_rel_tol = 1e-5
  nl_max_its = 10
  l_tol = 1e-5
  l_max_its = 50

  dt = 0.002 #0.01
  dtmin = 0.00001
  dtmax = 0.02
  end_time = 0.2
[]

