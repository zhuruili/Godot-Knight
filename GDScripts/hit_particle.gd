extends GPUParticles2D

func _ready() -> void:
	emitting = true
	var total_time = lifetime + 0.1
	await get_tree().create_timer(total_time).timeout
	queue_free()
