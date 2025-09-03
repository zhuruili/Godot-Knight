extends CharacterBody2D

enum State {NORMAL, DASH}

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

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASH:
			process_dash(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else  0
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
		$AnimationPlayer.play("移动")
	else:
		$AnimationPlayer.play("站立")

func turn_direction():
	var moveVector = get_movement_vector()
	if moveVector.x !=0:
		$SpriteArea.scale.x = 1 if moveVector.x > 0 else -1

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
	
	velocity.y += gravity * delta  # 物理帧率默认60，所以每次增量算出来约为10
	
	move_and_slide()
	update_animation()
	turn_direction()
	
	if is_on_floor():
		canDash = true
		canDoubleJump = true
	
	if Input.is_action_just_pressed("dash") and canDash == true:
		call_deferred("change_state", State.DASH)

func process_dash(delta):
	if isStateNew:
		canDash = false
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if moveVector.x != 0:
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $SpriteArea.scale.x == 1 else -1
		velocity.x = velocityMod * maxDashSpeed
		velocity.y = 0
		$AnimationPlayer.play("冲刺")
	velocity.x = lerp(0.0, velocity.x, pow(2,-6 * delta))
	move_and_slide()
	if !$AnimationPlayer.is_playing():
		call_deferred("change_state", State.NORMAL)
