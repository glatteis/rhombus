extends Node2D

func _ready():
	var level = load_progress()
	var title_level = get_node("title_level")
	if level == 0:
		get_tree().change_scene("res://levels/level_1.tscn")
	else:
		title_level.scene_number = level - 1

func load_progress():
	var file = File.new()
	if file.open("user://saved_game.sav", File.READ) != 0:
		print("Error opening file")
		return 0
	var text = file.get_as_text()
	var level = int(text)
	file.close()
	return level