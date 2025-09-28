extends Node2D

func spawn_pindao_texiao(effect_pos):
	var pindao_scene = load("res://scenes/pindao_texiao.tscn")
	var pindao_node = pindao_scene.instantiate()
	pindao_node.position = effect_pos
	add_child(pindao_node)

func spawn_zhanhou_texiao(boss_pos):
	var zhanhou_scene = load("res://scenes/zhanhou_texiao.tscn")
	var zhanhou_node = zhanhou_scene.instantiate()
	zhanhou_node.position = boss_pos
	add_child(zhanhou_node)

func delete_zhanhou():
	var zhanhou_node = get_node("/root/MainScene/TexiaoSpawner/ZhanhouTexiao")
	zhanhou_node.queue_free()
