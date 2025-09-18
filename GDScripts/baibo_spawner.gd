extends Node2D

func spawn_baibo_left():
	var boss = get_node("/root/MainScene/Enemy/BOSS")
	var baibo_scene = load("res://scenes/baibo.tscn")
	var baibo_node_left = baibo_scene.instantiate()
	baibo_node_left.position.x = boss.position.x - 20
	baibo_node_left.position.y = boss.position.y
	baibo_node_left.scale.x = 1
	baibo_node_left.direction = 1
	add_child(baibo_node_left)
	
func spawn_baibo_right():
	var boss = get_node("/root/MainScene/Enemy/BOSS")
	var baibo_scene = load("res://scenes/baibo.tscn")
	var baibo_node_right = baibo_scene.instantiate()
	baibo_node_right.position.x = boss.position.x + 20
	baibo_node_right.position.y = boss.position.y
	baibo_node_right.scale.x = -1
	baibo_node_right.direction = -1
	add_child(baibo_node_right)
