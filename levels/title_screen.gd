extends Node2D

onready var level = load_progress()

func load_progress():
	var file = File.new()
	if file.open("user://saved_game.sav", File.READ) != 0:
		print("Error opening file")
		return 0
	var text = file.get_as_text()
	var level = int(text)
	file.close()
	return level

func _on_level_select_pressed():
	get_tree().change_scene("res://menu/menu.tscn")


func _on_play_pressed():
	get_tree().change_scene("res://levels/level_" + str(level) + ".tscn")
