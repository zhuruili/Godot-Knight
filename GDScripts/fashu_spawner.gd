extends Node2D

func spawn_heibo_left():
	var player = get_node("/root/MainScene/Player/Player")
	var heibo_scene = load("res://scenes/heibo.tscn")
	var heibo_node_left = heibo_scene.instantiate()
	heibo_node_left.position.x = player.position.x
	heibo_node_left.position.y = player.position.y
	heibo_node_left.scale.x = -1
	heibo_node_left.direction = -1
	add_child(heibo_node_left)
	
func spawn_heibo_right():
	var player = get_node("/root/MainScene/Player/Player")
	var heibo_scene = load("res://scenes/heibo.tscn")
	var heibo_node_right = heibo_scene.instantiate()
	heibo_node_right.position.x = player.position.x
	heibo_node_right.position.y = player.position.y
	heibo_node_right.scale.x = 1
	heibo_node_right.direction = 1
	add_child(heibo_node_right)

func spawn_shanghou():
	var player = get_node("/root/MainScene/Player/Player")
	var shanghou_scene = load("res://scenes/shanghou.tscn")
	var shanghou_node = shanghou_scene.instantiate()
	shanghou_node.position.x = player.position.x
	shanghou_node.position.y = player.position.y
	add_child(shanghou_node)
