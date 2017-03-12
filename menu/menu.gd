extends Node2D

onready var container = get_node("container")
onready var button = load("res://menu/level_button.tscn")
var unlocked_levels = 100
var levels_per_row = 5
var level_size = 200
var margin_left = 20
var margin_top = 50
var display_starting = 0

func _ready():
	set_process(true)
	for y in range(unlocked_levels / levels_per_row):
		for x in range(levels_per_row):
			var b = button.instance()
			container.add_child(b)
			b.set_pos(Vector2(margin_left + x * level_size, margin_top + y * level_size))
			b.set_level_num(y * levels_per_row + x + 1)
	init_display()


func _on_button_up_pressed():
	if display_starting > 0:
		container.set_pos(container.get_pos() + Vector2(0, level_size))
		display_starting -= 1
		init_display()

func _on_button_down_pressed():
	container.set_pos(container.get_pos() - Vector2(0, level_size))
	display_starting += 1
	init_display()

func init_display():
	var children = container.get_children()
	for i in range((display_starting - 1) * levels_per_row, display_starting * levels_per_row):
		children[i].remove_display()
	for i in range((display_starting) * levels_per_row, (display_starting + 4) * levels_per_row):
		children[i].init_display()
	for i in range((display_starting + 4) * levels_per_row, (display_starting + 5) * levels_per_row):
		children[i].remove_display()


func _on_button_back_pressed():
	get_tree().change_scene("res://levels/title_screen.tscn")
