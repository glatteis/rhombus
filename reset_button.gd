extends Button

onready var level = get_parent()

func _on_reset_button_pressed():
	get_node("rotate_animation").play("rotate")
	level.change_scene_to(level.scene_number)

