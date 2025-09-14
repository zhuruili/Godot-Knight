extends CharacterBody2D

func _ready() -> void:
	$AnimationPlayer.play("站立")


func _on_hurtbox_area_area_entered(area: Area2D) -> void:
	$MateriaTimer.start()
	$SpriteArea/Sprite2D.use_parent_material = false


func _on_materia_timer_timeout() -> void:
	$SpriteArea/Sprite2D.use_parent_material = true
