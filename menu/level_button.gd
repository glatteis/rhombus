extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var scene_file = null

func set_level_num(level_num):
	get_node("label").set_text(str(level_num))
	scene_file = "res://levels/level_" + str(level_num) + ".tscn"

var display_scene = null

var check_dir = Directory.new()

func init_display():
	if check_dir.file_exists(scene_file):
		var scene = load(scene_file)
		var s = scene.instance()
		s.set_script(null)
		s.set_scale(Vector2(0.13, 0.13))
		add_child(s)
		display_scene = s

func remove_display():
	if display_scene != null:
		remove_child(display_scene)


func _on_level_button_pressed():
	get_tree().change_scene(scene_file)

