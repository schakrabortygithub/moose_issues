[Mesh]
inactive = 'interface2'
[gen]
type = GeneratedMeshGenerator
dim = 2
nx = 20
ny = 20
xmax = 1
ymax = 1
[]
[./subdomain1]
input = gen
type = SubdomainBoundingBoxGenerator
bottom_left = '0.5 0 0'
top_right = '1.0 1.0 0'
block_id = 1
[../]
[./interface1]
type = SideSetsAroundSubdomainGenerator
input = subdomain1
block = 0
normal = '1 0 0' # right
new_boundary = 'interface'
[../]

[./interface2]
input = subdomain1
type = SideSetsBetweenSubdomainsGenerator
primary_block = '0'
paired_block = '1'
new_boundary = 'master0_interface'
[../]
[]


[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
    [./v]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./timeu]
    type = TimeDerivative
    variable = u
  [../]
  [./diff0]
    type = CoefDiffusion
    variable = u
    coef = 4
    block = 0
  [../]
  
  
  [./timev]
    type = TimeDerivative
    variable = v
  [../]
  [./diff1]
    type = CoefDiffusion
    variable = v
    coef = 2
    block = 1
  [../]
[]


[InterfaceKernels]
inactive = 'Interface1 Interface2 '
[./Interface1]
type = InterfaceDiffusion
variable = 'u'
neighbor_var = 'v'
D = 1
D_neighbor = 3
boundary = 'interface'
[../]

[./Interface2]
type = InterfaceDiffusion
variable = 'u'
neighbor_var = 'v'
D = 1
D_neighbor = 3
boundary = 'master0_interface'
[../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = 'left'
    value = 1
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = 'right'
    value = 0
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
  solve_type = 'PJFNK' 

  dt = 0.1
  dtmin = 0.000001
  dtmax = 0.2
  end_time = 1.0
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
[]