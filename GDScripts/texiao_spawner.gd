extends Node2D

func spawn_pindao_texiao(effect_pos):
	var pindao_scene = load("res://scenes/pindao_texiao.tscn")
	var pindao_node = pindao_scene.instantiate()
	pindao_node.position = effect_pos
	add_child(pindao_node)
