extends CharacterBody2D

var gravity = 580
var horizontalAcceleration = 2000
var maxHorizontalSpeed = 110
var jumpSpeed = 280
var jumpHigher = 4

func _ready() -> void:
	pass

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else  0
	return moveVector

func update_animation():
	var moveVector = get_movement_vector()
	if !is_on_floor():
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
		$Sprite2D.scale.x = 1 if moveVector.x > 0 else -1

func _physics_process(delta: float) -> void:
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	if moveVector.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2, -50 * delta))
		
	if is_on_floor() and moveVector.y == -1:
		velocity.y = jumpSpeed * moveVector.y
	if velocity.y < 0 and !Input.is_action_pressed("jump"):
		velocity.y += jumpHigher * delta * gravity
	
	velocity.y += gravity * delta  # 物理帧率默认60，所以每次增量算出来约为10
	
	move_and_slide()
	update_animation()
	turn_direction()
