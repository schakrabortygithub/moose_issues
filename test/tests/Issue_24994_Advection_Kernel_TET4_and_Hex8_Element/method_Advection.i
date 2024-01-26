#. Advection kernel have weird checkered pattern when using TET4 elemet
#. None of those appear when HEX8 element is used.

[Mesh]
[./gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 10
  ny = 10
  nz = 2
  xmax = 0.1
  ymax = 0.1
  zmax = 0.02
  elem_type = TET4 #TET4, HEX, HEX8
  #show_info = True
[../]
[]

[Outputs]
    file_base = ./Data_CDT_ScalarVar_Temp_TET4
    csv = true
    exodus = true
    #append_date = true
    append_date_format = '%Y-%m-%d-%H-%M-%S'
    execute_on = 'timestep_end'
  [./console]
    type = Console
    output_file = true
    max_rows = 0
  [../]
[]

[Variables]
  [./DD_EdgePositive_00]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./IC_DD_EdgePositive_00]
    type = FunctionIC
    variable = DD_EdgePositive_00
    function = '1.0'
  [../]
[]

[Kernels]
  [./dot_DD_EdgePositive_00]
    type = MassLumpedTimeDerivative  #MassLumpedTimeDerivative
    variable = DD_EdgePositive_00
  [../]
  [./advection_DD_EdgePositive_00]
    type = ConservativeAdvection #ConservativeAdvection, AdvectionCDT
    variable = DD_EdgePositive_00
    upwinding_type = Full
    velocity = '0.1 0.0 0.0'
    #block = 0
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
  solve_type = 'NEWTON' #'NEWTON' , 'PJFNK'
  #automatic_scaling = true
  #scaling_group_variables = 'disp_x disp_y disp_z; DD_EdgePositive_01'
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
  nl_abs_tol = 1e-5  #1e-10 for all *_tol
  nl_rel_tol = 1e-5
  nl_abs_step_tol = 1e-5

  dt = 0.01
  dtmin = 0.00001
  dtmax = 0.01
  end_time = 1
[]
