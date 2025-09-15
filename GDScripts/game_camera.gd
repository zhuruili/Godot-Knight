extends Camera2D

var playerPosition = Vector2.ZERO

func _ready() -> void:
	global_position.x = -64
	global_position.y = -72
	
func match_player_position():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		playerPosition = player.global_position

func _process(delta: float) -> void:
	match_player_position()
	if playerPosition.x > -210 and playerPosition.x < -64:
		global_position.x = lerp(playerPosition.x, global_position.x, pow(2, -7 * delta))
	if playerPosition.x < -210:
		global_position.x = lerp(-370.0, global_position.x, pow(2, -7 * delta))
	if playerPosition.x > -64:
		global_position.x = lerp(-64.0, global_position.x, pow(2, -7 * delta))
