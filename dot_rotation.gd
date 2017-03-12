extends MeshInstance

var rotation_vector = Vector3(randf(), randf(), randf()).normalized()

func _ready():
	set_process(true)
	print(rotation_vector)
	pass

func _process(delta):
	rotate(rotation_vector, delta / 10)
