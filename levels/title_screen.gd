extends Node2D

onready var fade_animation = load("res://fade.tscn").instance()
onready var level = load_progress()

func _ready():
	add_child(fade_animation)
	fade_animation.play_backwards("fade")

func load_progress():
	var file = File.new()
	if file.open("user://saved_game.sav", File.READ) != 0:
		print("Error opening file")
		return 1
	var text = file.get_as_text()
	var level = int(text)
	file.close()
	#return level
	return 1

func _on_level_select_pressed():
	get_tree().change_scene("res://menu/menu.tscn")


func _on_play_pressed():
	get_tree().change_scene("res://levels/level_" + str(level) + ".tscn")
