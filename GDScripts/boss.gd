extends CharacterBody2D

enum State {READY, IDLE,
			HUIKAN, HUIKAN_ZHUNBEI, SHANGTIAO, SHANGTIAO_ZHUNBEI,
			MOVE, JUMP, FALL,
			JUMP_2, XIACHUO_ZHUNBEI, XIACHUO, XIACHUO_JIESHU}

var currentState = State.READY
var isStateNew = true

var playerPosition = Vector2.ZERO
var gravity = 1000

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match_player_position()
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
		State.MOVE:
			process_move(delta)
		State.JUMP:
			process_jump(delta)
		State.FALL:
			process_fall(delta)
		State.JUMP_2:
			process_jump_2(delta)
		State.XIACHUO_ZHUNBEI:
			process_xiachuo_zhunbei(delta)
		State.XIACHUO:
			process_xiachuo(delta)
		State.XIACHUO_JIESHU:
			process_xiachuo_jieshu(delta)
		
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func turn_direction():
	$SpriteArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$HurtboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$BodyHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$DaoguangHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
	$CollisionPolygon2D.scale.x = 1 if playerPosition.x < global_position.x else -1

func match_player_position():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		playerPosition = player.global_position

func process_ready(delta):
	turn_direction()
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
		if randf() < 0.7:
			if abs(playerPosition.x - global_position.x) < 80:
				call_deferred("change_state", State.HUIKAN_ZHUNBEI)
			else:
				if randf() > 0.5:
					call_deferred("change_state", State.MOVE)
				else:
					call_deferred("change_state", State.JUMP)
		else:
			call_deferred("change_state", State.JUMP_2)

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
		call_deferred("change_state", State.FALL)

func process_shangtiao_zhunbei(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("上挑准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.SHANGTIAO)

func process_move(delta):
	turn_direction()
	if isStateNew:
		if playerPosition.x > global_position.x:
			velocity.x = 80
		else:
			velocity.x = -80
		velocity.y = 0
		$AnimationPlayer.play("移动")
	velocity.y += gravity * delta
	move_and_slide()
	if abs(playerPosition.x - global_position.x) < 80:
		call_deferred("change_state", State.HUIKAN_ZHUNBEI)

func process_jump(delta):
	if isStateNew:
		velocity.x = playerPosition.x - global_position.x
		velocity.y = -400
		$AnimationPlayer.play("跳跃")
	velocity.y += gravity * delta
	move_and_slide()
	if velocity.y > 0:
		call_deferred("change_state", State.FALL)

func process_fall(delta):
	if isStateNew:
		$AnimationPlayer.play("下落")
	velocity.y += gravity * delta
	move_and_slide()
	if is_on_floor():
		velocity = Vector2.ZERO
		call_deferred("change_state", State.IDLE)


func process_jump_2(delta):
	if isStateNew:
		velocity.x = (playerPosition.x - global_position.x) * 2
		velocity.y = -400
		$AnimationPlayer.play("跳跃")
	velocity.y += gravity * delta
	move_and_slide()
	if velocity.y > 0:
		call_deferred("change_state", State.XIACHUO_ZHUNBEI)

func process_xiachuo_zhunbei(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("下戳准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.XIACHUO)

func process_xiachuo(delta):
	if isStateNew:
		$AnimationPlayer.play("下戳")
	velocity.y += 100
	move_and_slide()
	if is_on_floor():
		var guci_spawner = get_node("/root/MainScene/Enemy/Guci_Spawner")
		guci_spawner.spawn_guci()
		call_deferred("change_state", State.XIACHUO_JIESHU)

func process_xiachuo_jieshu(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("下戳结束")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)


func _on_hurtbox_area_area_entered(area: Area2D) -> void:
	$MateriaTimer.start()
	$SpriteArea/Sprite2D.use_parent_material = false


func _on_materia_timer_timeout() -> void:
	$SpriteArea/Sprite2D.use_parent_material = true
