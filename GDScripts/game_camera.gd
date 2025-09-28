extends Camera2D

var playerPosition = Vector2.ZERO

var shakeStrength = 0.0
var recovery_speed = 16.0

func _ready() -> void:
	global_position.x = -64
	global_position.y = -72
	
func match_player_position():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		playerPosition = player.global_position

func _process(delta: float) -> void:
	offset = Vector2(randf_range(-shakeStrength, shakeStrength), randf_range(-shakeStrength, shakeStrength))
	shakeStrength = move_toward(shakeStrength, 0, recovery_speed * delta)
	
	match_player_position()
	if playerPosition.x > -210 and playerPosition.x < -64:
		global_position.x = lerp(playerPosition.x, global_position.x, pow(2, -7 * delta))
	if playerPosition.x < -210:
		global_position.x = lerp(-370.0, global_position.x, pow(2, -7 * delta))
	if playerPosition.x > -64:
		global_position.x = lerp(-64.0, global_position.x, pow(2, -7 * delta))

func camera_shake_small():
	shakeStrength = 3

func camera_shake_big():
	shakeStrength = 5

func start_timer(time_scale):
	var timer = Timer.new()
	timer.wait_time = 0.03
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	Engine.time_scale = time_scale

func _on_timer_timeout():
	Engine.time_scale = 1

func enemy_rigidity():
	shakeStrength = 5
	start_timer(0.1)

func enemy_die():
	shakeStrength = 10
	start_timer(0.7)

func pindao_camera():
	shakeStrength = 1
	start_timer(0.1)

func zhanhou_camera():
	shakeStrength = 1.2
