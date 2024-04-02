elem = QUAD4
[GlobalParams]
  displacements = 'disp_x disp_y'
[]

L=1.0
B=1.0
Hor_num=1
dimension=2
xn=10
yn=10
delx=${fparse L/xn}
dely=${fparse L/xn}
M_L_min=${fparse -delx/2}
M_L_max=${fparse L+delx/2}
M_B_min=${fparse -dely/2}
M_B_max=${fparse B+dely/2}
M_nx=${fparse xn+1}
M_ny=${fparse yn+1}
YM=1000
PR=0.3
[Mesh]
  type = PeridynamicsMesh
  horizon_number = ${Hor_num}
  [Mainsec]
    type = GeneratedMeshGenerator
    dim = ${dimension}
    xmin = ${M_L_min}
    xmax = ${M_L_max}
    ymin = ${M_B_min}
    ymax = ${M_B_max}
    nx = ${M_nx}
    ny = ${M_ny}
    elem_type = ${elem}
    boundary_name_prefix = Mainsec
    boundary_id_offset = 10
  []
  [./gpd]
    type = MeshGeneratorPD
    input = Mainsec
    retain_fe_mesh = false
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[BCs]
  [./left_x1]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 1013
    function = '-0.01 * t'
  [../]
  [./right_x1]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 1011
    function = '0.01 * t'
  [../]
[]

[Modules/Peridynamics/Mechanics/Master]
  [./all]
    formulation = BOND
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = ${YM}
    poissons_ratio = ${PR}
  [../]

  [./force_density]
    type =  ComputeSmallStrainConstantHorizonMaterialBPD
	plane_stress=true
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
  solve_type = NEWTON
  end_time = 100
  dt = 1
[]
[Outputs]
  exodus = true
[]


