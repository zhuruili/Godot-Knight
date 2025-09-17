extends Node2D

func spawn_guci():
	var boss = get_node("/root/MainScene/Enemy/BOSS")
	var guci_scene = load("res://scenes/guci.tscn")
	for i in range(10):
		var guci_node_right = guci_scene.instantiate()
		guci_node_right.position.x = boss.position.x + 45 + 45 * i
		if guci_node_right.position.x > -500 and guci_node_right.position.x < -240:
			add_child(guci_node_right)
		var guci_node_left = guci_scene.instantiate()
		guci_node_left.position.x = boss.position.x - 45 - 45 * i
		if guci_node_left.position.x > -500 and guci_node_left.position.x < -240:
			add_child(guci_node_left)
		await get_tree().create_timer(0.2).timeout
