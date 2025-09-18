extends CharacterBody2D

enum State {NORMAL, DASH,
ATTACK, ATTACK_UP, ATTACK_DOWN, ATTACK_JUMP,
HURT, DIE_1, DIE_2,
HEAL}

var currentState = State.NORMAL
var isStateNew = true

var gravity = 580
var horizontalAcceleration = 2000
var maxHorizontalSpeed = 110
var jumpSpeed = 280
var DoublejumpSpeed = 250
var jumpHigher = 4
var maxDashSpeed = 400
var canDash = true
var canDoubleJump = true
@export var isDoubleJumping = false
var attack_index = 0
var hurt_direction: String

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASH:
			process_dash(delta)
		State.ATTACK:
			process_attack(delta)
		State.ATTACK_UP:
			process_attack_up(delta)
		State.ATTACK_DOWN:
			process_attack_down(delta)
		State.ATTACK_JUMP:
			process_attack_jump(delta)
		State.HURT:
			process_hurt(delta)
		State.DIE_1:
			process_die_1(delta)
		State.DIE_2:
			process_die_2(delta)
		State.HEAL:
			process_heal(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector

func update_animation():
	var moveVector = get_movement_vector()
	if !is_on_floor():
		if isDoubleJumping == true:
			$AnimationPlayer.play("二段跳")
		else:
			if velocity.y < 0:
				$AnimationPlayer.play("跳跃")
			if velocity.y > 0:
				$AnimationPlayer.play("下落")
	elif moveVector.x != 0:
		if Input.is_action_pressed("heal") and $"/root/PlayerSoul".PlayerSoul >= 3:
			call_deferred("change_state", State.HEAL)
		$AnimationPlayer.play("移动")
	else:
		if Input.is_action_pressed("heal") and $"/root/PlayerSoul".PlayerSoul >= 3:
			call_deferred("change_state", State.HEAL)
		$AnimationPlayer.play("站立")


func turn_direction():
	var moveVector = get_movement_vector()
	if moveVector.x != 0:
		$SpriteArea.scale.x = 1 if moveVector.x > 0 else -1
		$HurtboxArea.scale.x = 1 if moveVector.x > 0 else -1
		$Attack_1.scale.x = 1 if moveVector.x > 0 else -1
		$Attack_2.scale.x = 1 if moveVector.x > 0 else -1
		$Attack_Up.scale.x = 1 if moveVector.x > 0 else -1
		$Attack_Down.scale.x = 1 if moveVector.x > 0 else -1
		$CollisionPolygon2D.scale.x = 1 if moveVector.x > 0 else -1

func apply_gravity_movement(delta):
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	if moveVector.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2, -50 * delta))
	velocity.y += gravity * delta
	move_and_slide()

func process_normal(delta: float) -> void:
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	if moveVector.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2, -50 * delta))
		
	if moveVector.y == -1:
		if is_on_floor():
			velocity.y = jumpSpeed * moveVector.y
		elif canDoubleJump == true:
			velocity.y = DoublejumpSpeed * moveVector.y
			isDoubleJumping = true
			canDoubleJump = false
	if velocity.y < 0 and !Input.is_action_pressed("jump"):
		velocity.y += jumpHigher * delta * gravity
	
	velocity.y += gravity * delta # 物理帧率默认60，所以每次增量算出来约为10
	
	move_and_slide()
	update_animation()
	turn_direction()
	
	if is_on_floor():
		canDash = true
		canDoubleJump = true
	
	if Input.is_action_just_pressed("dash") and canDash == true:
		call_deferred("change_state", State.DASH)
	if Input.is_action_just_pressed("attack") and $AttackTimer.is_stopped():
		call_deferred("change_state", State.ATTACK)
	if Input.is_action_just_pressed("attack") and Input.get_action_strength("move_up") and $AttackTimer.is_stopped():
		call_deferred("change_state", State.ATTACK_UP)
	if Input.is_action_just_pressed("attack") and Input.get_action_strength("move_down") and !is_on_floor() and $AttackTimer.is_stopped():
		call_deferred("change_state", State.ATTACK_DOWN)

func process_dash(delta):
	if isStateNew:
		var hasBlackDash = $BlackDash.hasBlackDash
		turn_direction()
		canDash = false
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if moveVector.x != 0:
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $SpriteArea.scale.x == 1 else -1
		velocity.x = velocityMod * maxDashSpeed
		velocity.y = 0
		if hasBlackDash == true:
			$HurtboxArea/Hurtbox.disabled = true
			$BlackDash.spawn_blackdash()
			$AnimationPlayer.play("黑冲")
		else:
			$AnimationPlayer.play("冲刺")
	velocity.x = lerp(0.0, velocity.x, pow(2, -6 * delta))
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		$HurtboxArea/Hurtbox.disabled = false
		call_deferred("change_state", State.NORMAL)
		
func process_attack(delta):
	if isStateNew:
		if attack_index == 0:
			$AnimationPlayer.play("横劈1")
		else:
			$AnimationPlayer.play("横劈2")
	if !$AnimationPlayer.is_playing():
		$AttackTimer.start()
		attack_index = 1 - attack_index
		call_deferred("change_state", State.NORMAL)
	apply_gravity_movement(delta)

func process_attack_up(delta):
	if isStateNew:
		$AnimationPlayer.play("上劈")
	if !$AnimationPlayer.is_playing():
		$AttackTimer.start()
		call_deferred("change_state", State.NORMAL)
	apply_gravity_movement(delta)

func process_attack_down(delta):
	if isStateNew:
		$AnimationPlayer.play("下劈")
	if !$AnimationPlayer.is_playing():
		$AttackTimer.start()
		call_deferred("change_state", State.NORMAL)
	apply_gravity_movement(delta)

func process_attack_jump(delta):
	if isStateNew:
		canDash = true
		canDoubleJump = true
		velocity.x = 0
		velocity.y = -260
		$AnimationPlayer.play("下劈")
	if velocity.y >= -130:
		call_deferred("change_state", State.NORMAL)
	if Input.is_action_just_pressed("dash") and canDash == true:
		call_deferred("change_state", State.DASH)
	apply_gravity_movement(delta)


func _on_hurtbox_area_area_entered(area: Area2D) -> void:
	$"/root/PlayerHealthBar".PlayerHealthBar -= 1
	$"/root/PlayerHealthBar".refresh_player_health_bar()
	if area.global_position.x > global_position.x:
		hurt_direction = "left"
	else:
		hurt_direction = "right"
	if $"/root/PlayerHealthBar".PlayerHealthBar <= 0:
		call_deferred("change_state", State.DIE_1)
	else:
		call_deferred("change_state", State.HURT)

func Invincible():
	$HurtboxArea/Hurtbox.set_deferred("disabled", true)
	$InvincibleTimer.start()
	while true:
		$SpriteArea/Sprite2D.visible = false
		await get_tree().create_timer(0.06).timeout
		$SpriteArea/Sprite2D.visible = true
		await get_tree().create_timer(0.06).timeout
		if $InvincibleTimer.is_stopped():
			$HurtboxArea/Hurtbox.set_deferred("disabled", false)
			break

func process_hurt(delta):
	if isStateNew:
		Invincible()
		velocity.x = -150 if hurt_direction == "left" else 150
		velocity.y = -150
		$SpriteArea.scale.x = 1 if hurt_direction == "left" else -1
		$HurtboxArea.scale.x = 1 if hurt_direction == "left" else -1
		$Attack_1.scale.x = 1 if hurt_direction == "left" else -1
		$Attack_2.scale.x = 1 if hurt_direction == "left" else -1
		$Attack_Up.scale.x = 1 if hurt_direction == "left" else -1
		$Attack_Down.scale.x = 1 if hurt_direction == "left" else -1
		$CollisionPolygon2D.scale.x = 1 if hurt_direction == "left" else -1
		$AnimationPlayer.play("受击")
	velocity.y += gravity * delta
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.NORMAL)

func process_die_1(delta):
	if isStateNew:
		$HurtboxArea/Hurtbox.disabled = true
		$AnimationPlayer.play("死亡1")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.DIE_2)

func process_die_2(delta):
	if isStateNew:
		$AnimationPlayer.play("死亡2")

func process_heal(delta):
	if isStateNew:
		$AnimationPlayer.play("回血")
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.NORMAL)

func heal():
	$"/root/PlayerSoul".PlayerSoul -= 3
	$"/root/PlayerSoul".refresh_player_soul()
	$"/root/PlayerHealthBar".PlayerHealthBar += 1
	$"/root/PlayerHealthBar".refresh_player_health_bar()


func _on_attack_1_area_entered(area: Area2D) -> void:
	$"/root/PlayerSoul".PlayerSoul += 1
	$"/root/PlayerSoul".refresh_player_soul()
	if $SpriteArea.scale.x == 1:
		global_position.x -= 5
	else:
		global_position.x += 5

func _on_attack_2_area_entered(area: Area2D) -> void:
	$"/root/PlayerSoul".PlayerSoul += 1
	$"/root/PlayerSoul".refresh_player_soul()
	if $SpriteArea.scale.x == 1:
		global_position.x -= 5
	else:
		global_position.x += 5

func _on_attack_up_area_entered(area: Area2D) -> void:
	$"/root/PlayerSoul".PlayerSoul += 1
	$"/root/PlayerSoul".refresh_player_soul()
	pass # Replace with function body.

func _on_attack_down_area_entered(area: Area2D) -> void:
	$"/root/PlayerSoul".PlayerSoul += 1
	$"/root/PlayerSoul".refresh_player_soul()
	call_deferred("change_state", State.ATTACK_JUMP)
