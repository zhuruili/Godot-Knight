extends CharacterBody2D

enum State {READY, READY_2, ZHANHOU_ZHUNBEI, ZHANHOU, IDLE,
			HUIKAN, HUIKAN_ZHUNBEI, SHANGTIAO, SHANGTIAO_ZHUNBEI,
			MOVE, JUMP, FALL,
			JUMP_2, XIACHUO_ZHUNBEI, XIACHUO, XIACHUO_JIESHU,
			BACK_JUMP, BACK_FALL,
			BAIBO,
			CHONGCI_ZHUNBEI, CHONGCI, CHONGCI_TINGXIA,
			HURT, DIE_1, DIE_2}

var currentState = State.READY
var isStateNew = true

var playerPosition = Vector2.ZERO
var gravity = 1000
var BossHealth = 1000

func _ready() -> void:
	global_position.x = -450
	global_position.y = -180
	$HurtboxArea/Hurtbox.disabled = false
	$BodyHitboxArea/BodyHitbox.disabled = false
	$DaoguangHitboxArea/DaoguangHitbox.disabled = false

func _process(delta: float) -> void:
	match_player_position()
	match currentState:
		State.READY:
			process_ready(delta)
		State.READY_2:
			process_ready_2(delta)
		State.ZHANHOU_ZHUNBEI:
			process_zhanhou_zhunbei(delta)
		State.ZHANHOU:
			process_zhanhou(delta)
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
		State.BACK_JUMP:
			process_back_jump(delta)
		State.BACK_FALL:
			process_back_fall(delta)
		State.BAIBO:
			process_baibo(delta)
		State.CHONGCI_ZHUNBEI:
			process_chongci_zhunbei(delta)
		State.CHONGCI:
			process_chongci(delta)
		State.CHONGCI_TINGXIA:
			process_chongci_tingxia(delta)
		State.HURT:
			process_hurt(delta)
		State.DIE_1:
			process_die_1(delta)
		State.DIE_2:
			process_die_2(delta)
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
	if isStateNew:
		turn_direction()
	$AnimationPlayer.play("站立")
	if playerPosition.x < -250:
		var door = get_node("/root/MainScene/Doors/Door")
		door.close()
		call_deferred("change_state", State.READY_2)

func process_ready_2(delta):
	if isStateNew:
		$AnimationPlayer.play("下落")
	velocity.y += gravity * delta
	move_and_slide()
	if is_on_floor():
		velocity = Vector2.ZERO
		call_deferred("change_state", State.ZHANHOU_ZHUNBEI)

func process_zhanhou_zhunbei(delta):
	if isStateNew:
		$AnimationPlayer.play("战吼准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.ZHANHOU)

func process_zhanhou(delta):
	$"/root/MainScene/GameCamera".zhanhou_camera()
	if isStateNew:
		var boss_pos = position
		$"/root/MainScene/TexiaoSpawner".spawn_zhanhou_texiao(boss_pos)
		var player = get_node("/root/MainScene/Player/Player")
		player.player_change_state_to_scared()
		$AnimationPlayer.play("战吼")
	if !$AnimationPlayer.is_playing():
		$"/root/MainScene/TexiaoSpawner".delete_zhanhou()
		call_deferred("change_state", State.IDLE)


func process_idle(delta):
	turn_direction()
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("站立")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		if randf() > 0.5:
			if abs(playerPosition.x - global_position.x) < 80:
				call_deferred("change_state", State.HUIKAN_ZHUNBEI)
			else:
				if randf() > 0.5:
					call_deferred("change_state", State.MOVE)
				else:
					call_deferred("change_state", State.JUMP)
		else:
			if randf() > 0.5:
				call_deferred("change_state", State.JUMP_2)
			else:
				call_deferred("change_state", State.BACK_JUMP)

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
		$"/root/MainScene/GameCamera".camera_shake_small()
		var guci_spawner = get_node("/root/MainScene/Enemy/Guci_Spawner")
		guci_spawner.spawn_guci()
		call_deferred("change_state", State.XIACHUO_JIESHU)

func process_xiachuo_jieshu(delta):
	if isStateNew:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("下戳结束")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)


func process_back_jump(delta):
	if isStateNew:
		velocity.x = -500 - global_position.x if playerPosition.x > (-500 - 240) * 0.5 else -240 - global_position.x
		velocity.y = -400
		if velocity.x < 0 and $SpriteArea.scale.x == 1:
			$AnimationPlayer.play("跳跃")
		if velocity.x < 0 and $SpriteArea.scale.x == -1:
			$AnimationPlayer.play("后跳")
		if velocity.x > 0 and $SpriteArea.scale.x == 1:
			$AnimationPlayer.play("后跳")
		if velocity.x > 0 and $SpriteArea.scale.x == -1:
			$AnimationPlayer.play("跳跃")
	velocity.y += gravity * delta
	move_and_slide()
	if velocity.y > 0:
		call_deferred("change_state", State.BACK_FALL)

func process_back_fall(delta):
	if isStateNew:
		if velocity.x < 0 and $SpriteArea.scale.x == 1:
			$AnimationPlayer.play("下落")
		if velocity.x < 0 and $SpriteArea.scale.x == -1:
			$AnimationPlayer.play("后跳下落")
		if velocity.x > 0 and $SpriteArea.scale.x == 1:
			$AnimationPlayer.play("后跳下落")
		if velocity.x > 0 and $SpriteArea.scale.x == -1:
			$AnimationPlayer.play("下落")
	velocity.y += gravity * delta
	move_and_slide()
	if is_on_floor():
		velocity = Vector2.ZERO
		if randf() > 0.5:
			call_deferred("change_state", State.BAIBO)
		else:
			call_deferred("change_state", State.CHONGCI_ZHUNBEI)


func process_baibo(delta):
	if isStateNew:
		turn_direction()
		velocity = Vector2.ZERO
		$AnimationPlayer.play("白波释放")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)

func spawn_baibo(delta):
	var baibo_spawner = get_node("/root/MainScene/Enemy/Baibo_Spawner")
	if $SpriteArea.scale.x == 1:
		baibo_spawner.spawn_baibo_left()
	else:
		baibo_spawner.spawn_baibo_right()


func process_chongci_zhunbei(delta):
	if isStateNew:
		turn_direction()
		velocity = Vector2.ZERO
		$AnimationPlayer.play("冲刺准备")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.CHONGCI)

func process_chongci(delta):
	if isStateNew:
		velocity.x = -400 if $SpriteArea.scale.x == 1 else 400
		velocity.y = 0
		$AnimationPlayer.play("冲刺")
	velocity.y += gravity * delta
	move_and_slide()
	if $SpriteArea.scale.x == 1 and global_position.x < -500:
		call_deferred("change_state", State.CHONGCI_TINGXIA)
	if $SpriteArea.scale.x == -1 and global_position.x > -240:
		call_deferred("change_state", State.CHONGCI_TINGXIA)

func process_chongci_tingxia(delta):
	if isStateNew:
		velocity.x = lerp(0.0, velocity.x, pow(2, -10 * delta))
		$AnimationPlayer.play("冲刺停下")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)

func process_hurt(delta):
	if isStateNew:
		$"/root/MainScene/GameCamera".enemy_rigidity()
		turn_direction()
		$AnimationPlayer.play("僵直")
		velocity.x = 400 if $SpriteArea.scale.x == 1 else -400
	velocity.x = lerp(0.0, velocity.x, pow(2, -10 * delta))
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.IDLE)

func process_die_1(delta):
	if isStateNew:
		$"/root/MainScene/GameCamera".enemy_rigidity()
		$HurtboxArea/Hurtbox.disabled = true
		$BodyHitboxArea/BodyHitbox.disabled = true
		$DaoguangHitboxArea/DaoguangHitbox.disabled = true
		turn_direction()
		$AnimationPlayer.play("僵直")
		velocity.x = 400 if $SpriteArea.scale.x == 1 else -400
	velocity.x = lerp(0.0, velocity.x, pow(2, -10 * delta))
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.DIE_2)

func process_die_2(delta):
	if isStateNew:
		$AnimationPlayer.play("死亡")

func enemy_die_camera_shake():
	$"/root/MainScene/GameCamera".enemy_die()

func door_open():
	var door = get_node("/root/MainScene/Doors/Door")
	door.open()


func deal_damage(health_upper_limit, health_lower_limit, area):
	if BossHealth <= health_upper_limit and BossHealth >= health_lower_limit:
		if area.name == "Attack_1":
			BossHealth -= 13
		if area.name == "Attack_2":
			BossHealth -= 13
		if area.name == "Attack_Up":
			BossHealth -= 13
		if area.name == "Attack_Down":
			BossHealth -= 13
		if area.name == "HeiboHitboxArea":
			BossHealth -= 30
		if area.name == "ShanghouHitboxArea":
			BossHealth -= 20
		if area.name == "XiazaHitboxArea":
			BossHealth -= 30
		if area.name == "XiazaHitboxArea2":
			BossHealth -= 15
		if BossHealth <= 0: # 理论上在内层不会发生，只是为了保险
			call_deferred("change_state", State.DIE_1)
		elif BossHealth < health_lower_limit: # 看上去和外层分支冲突，但是这里是连续的if，在突变的那一帧之内其实是可以触发的
			call_deferred("change_state", State.HURT)

func _on_hurtbox_area_area_entered(area: Area2D) -> void:
	$MateriaTimer.start()
	$SpriteArea/Sprite2D.use_parent_material = false
	var boss_pos = position
	$"/root/MainScene/TexiaoSpawner".spawn_hit_particle(boss_pos)
	deal_damage(1000, 750, area)
	deal_damage(750, 500, area)
	deal_damage(500, 250, area)
	deal_damage(250, 0, area)
	print(BossHealth)


func _on_materia_timer_timeout() -> void:
	$SpriteArea/Sprite2D.use_parent_material = true
