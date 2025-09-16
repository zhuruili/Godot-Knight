extends CharacterBody2D

func _ready() -> void:
	$AnimationPlayer.play("default")
	
func open():
	$AnimationPlayer.play("open")
	
func close():
	$AnimationPlayer.play("close")
