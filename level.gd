extends Node2D

onready var fade_animation = load("res://fade.tscn").instance()

var mouse_nodes = []
var done_nodes = []

var do_cursor_drawing = true

export var line_color = Color(0, 0, 0, 1)
export var line_thickness = 5

export var scene_number = 1
export (String)var custom_next_scene

var children = []

var polygon_points = {}

onready var line_node = load("res://line.tscn")
onready var cursor_line = line_node.instance()

var drawn_mouse_nodes = {}
var drawn_done_nodes = []

func _ready():
	collect_children()
	fade_animation.connect("finished", self, "_on_fade_finished")
	add_child(fade_animation)
	set_process_input(true)
	set_opacity(0)
	set_process(true)
	fade_animation.play_backwards("fade")
	if scene_number != 0:
		save_progress()
	add_child(cursor_line)
	if custom_next_scene == null:
		add_child(load("res://background/background.tscn").instance())
	

func recursive_count(l):
	var c = 0
	for ch in l:
		if ch.get_children().size() > 0:
			c += recursive_count(ch.get_children())
		if ch extends MeshInstance:
			c += 1
	return c

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON or event.type == InputEvent.MOUSE_MOTION) and do_cursor_drawing:
		if event.is_action_pressed("click") and not mouse_nodes.empty():
			mouse_nodes = []
			return
		elif (event.is_action_pressed("click") and mouse_nodes.empty()) or (event.type == InputEvent.MOUSE_MOTION and not mouse_nodes.empty()):
			for node in children:
				if node.get_pos().distance_to(get_viewport().get_mouse_pos()) < 20 and not any_contain(done_nodes, node):
					if mouse_nodes.empty() or not node == mouse_nodes[mouse_nodes.size() - 1]:
						mouse_nodes.append(node)
					if not mouse_nodes.empty():
						var dot_types = []
						for node in mouse_nodes:
							if node.dot_type != null and not node.dot_type == "circle" and not node.dot_type in dot_types:
								dot_types.append(node.dot_type)
						
						var tests_passed = 0
						
						if "cube" in dot_types and mouse_nodes.size() == 5 and mouse_nodes[0] == mouse_nodes[4]:
							var vectors = []
							for i in range(4):
								vectors.append(mouse_nodes[i].get_pos() - mouse_nodes[(i + 1) % 4].get_pos())
							if (vectors[0] + vectors[2]).length() < 1 and (vectors[1] + vectors[3]).length() < 1:
								tests_passed += 1
						
						if "triangle" in dot_types and mouse_nodes.size() == 4 and mouse_nodes[0] == mouse_nodes[3]:
							tests_passed += 1
						
						if "triangle_ra" in dot_types and mouse_nodes.size() == 4 and mouse_nodes[0] == mouse_nodes[3]:
							var angle = 0
							for i in range(3):
								var v1 = mouse_nodes[fposmod((i - 1), 3)].get_pos()
								var v2 = mouse_nodes[i].get_pos()
								var v3 = mouse_nodes[i + 1].get_pos()
								angle += abs((v2 - v1).angle_to(v2 - v3))
								if abs(abs((v2 - v1).angle_to(v2 - v3)) - PI / 2) < PI / 100:
									tests_passed += 1
									break
						if tests_passed == dot_types.size() and not tests_passed == 0:
							shape_finished()
						elif mouse_nodes.count(node) > 1:
							mouse_nodes.remove(mouse_nodes.size() - 1)
					break
		update()



func _draw():
	if do_cursor_drawing and not mouse_nodes.empty():
		cursor_line.set_hidden(false)
		line(mouse_nodes[mouse_nodes.size() - 1].get_pos(), get_viewport().get_mouse_pos(), line_color, line_thickness, false, cursor_line)
	else:
		cursor_line.set_hidden(true)
	if not mouse_nodes.empty():
		for i in range(mouse_nodes.size() - 1):
			if not drawn_mouse_nodes.has([mouse_nodes[i].get_pos(), mouse_nodes[i + 1].get_pos()]):
				drawn_mouse_nodes[[mouse_nodes[i].get_pos(), mouse_nodes[i + 1].get_pos()]] \
				= line(mouse_nodes[i].get_pos(), mouse_nodes[i + 1].get_pos(), line_color, line_thickness)
	if mouse_nodes.size() < drawn_mouse_nodes.size():
		for n in drawn_mouse_nodes.values():
			remove_child(n)
		drawn_mouse_nodes.clear()
	if done_nodes.size() > drawn_done_nodes.size():
		for i in range(drawn_done_nodes.size(), done_nodes.size()):
			var n = done_nodes[i]
			var drawn_shape = []
			for i in range(n.size() - 1):
				drawn_shape.append(line(n[i].get_pos(), n[i + 1].get_pos(), line_color, line_thickness))
			drawn_done_nodes.append(drawn_shape)

func line(position1, position2, color, thickness, do_add = true, l = line_node.instance()):
	var line_position = position1
	var line_angle = Vector2(0, 1).angle_to(position2 - position1)
	var length = position1.distance_to(position2)
	l.set_pos(line_position)
	l.set_rotation(line_angle)
	l.set_size(Vector2(thickness, length))
	if do_add:
		add_child(l)
	return l

func collect_children():
	for c in get_children():
		for p in c.get_property_list():
			if p["name"] == "dot_type":
				children.append(c)
				continue

func shape_finished():
	done_nodes.append(mouse_nodes)
	var p_nodes = []
	for n in mouse_nodes:
		p_nodes.append(n.get_pos())
	polygon_points[mouse_nodes] = Vector2Array(p_nodes)
	mouse_nodes = []
	var size = 0
	for d in done_nodes:
		size += d.size() - 1
	if size == children.size():
		change_scene_to(scene_number + 1)


var changing_scene_num_to = 0

func change_scene_to(scene_num):
	do_cursor_drawing = false
	fade_animation.play("fade")
	changing_scene_num_to = scene_num

func _on_fade_finished():
	if do_cursor_drawing == false:
		if custom_next_scene == null:
			get_tree().change_scene("res://levels/level_" + str(changing_scene_num_to) + ".tscn")
		else:
			get_tree().change_scene(custom_next_scene)

func any_contain(list, element):
	for e in list:
		if element in e:
			return true
	return false

func save_progress():
	var file = File.new()
	if file.open("user://saved_game.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	file.store_string(str(scene_number))
	file.close()