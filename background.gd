extends Node2D

var cube = load("res://background/3dcube.tscn")
var cubes = []
var cube_rotations = []

func _ready():
	randomize()
	set_process(true)
	var num_cubes = int(rand_range(4, 8))
	for i in range(num_cubes):
		var c = cube.instance()
		cubes.append(c)
		var scale = rand_range(0.1, 2)
		c.set_scale(Vector3(scale, scale, scale))
		c.set_translation(Vector3(rand_range(-4, 4), rand_range(-1, 1), rand_range(-3, -8)))
		cube_rotations.append(Vector3(randf(), randf(), randf()).normalized())
		var material_override = FixedMaterial.new()
		material_override.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(randf(), randf(), randf()))
		c.set_material_override(material_override)
		add_child(c)


func _process(delta):
	for i in range(cubes.size()):
		cubes[i].rotate(cube_rotations[i], delta / 10)