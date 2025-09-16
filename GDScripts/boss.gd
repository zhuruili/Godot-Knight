extends CharacterBody2D

enum State {READY, IDLE, HUIKAN, HUIKAN_ZHUNBEI, SHANGTIAO, SHANGTIAO_ZHUNBEI}

var currentState = State.READY
var isStateNew = true

var gravity = 1000

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match currentState:
		State.READY:
			process_ready(delta)
		State.IDLE:
			process_idle(delta)
		State.HUIKAN:
			process_huikan(delta)
		State.HUIKAN_ZHUNBEI:
			process_huikan_zhunbei(delta)
		State.SHANGTIAO:
			process_shangtiao(delta)
		State.SHANGTIAO_ZHUNBEI:
			process_shangtiao_zhunbei(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func turn_direction():
	var playerPosition = get_node("/root/MainScene/Player").global_position
	$SpriteArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$HurtboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$BodyHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$DaoguangHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$CollisionPolygon2D.scale.x = 1 if playerPosition.x < global_position.x else -1

func process_ready(delta):
	turn_direction()
	var playerPosition = get_node("/root/MainScene/Player").global_position
	$AnimationPlayer.play("站立")
	if playerPosition.x < -250:
		var door = get_node("/root/MainScene/Doors/Door")
		door.close()
		call_deferred("change_state", State.IDLE)

func process_idle(delta):
	turn_direction()
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("站立")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.HUIKAN_ZHUNBEI)

func process_huikan(delta):
	if isStateNew:
		velocity.x = -300 if $SpriteArea.scale.x == 1 else 300
		velocity.y = 0
		$AnimationPlayer.play("挥砍")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.SHANGTIAO_ZHUNBEI)

func process_huikan_zhunbei(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("挥砍准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.HUIKAN)

func process_shangtiao(delta):
	if isStateNew:
		velocity.x = -80 if $SpriteArea.scale.x == 1 else 80
		velocity.y = -400
		$AnimationPlayer.play("上挑")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)

func process_shangtiao_zhunbei(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("上挑准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.SHANGTIAO)

func _on_hurtbox_area_area_entered(area: Area2D) -> void:
	$MateriaTimer.start()
	$SpriteArea/Sprite2D.use_parent_material = false


func _on_materia_timer_timeout() -> void:
	$SpriteArea/Sprite2D.use_parent_material = true
