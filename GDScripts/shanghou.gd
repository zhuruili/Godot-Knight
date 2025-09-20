extends Node2D

func _ready() -> void:
	position.y -= 40
	$AnimationPlayer.play("roar")
