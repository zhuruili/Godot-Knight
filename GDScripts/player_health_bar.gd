extends CanvasLayer

var PlayerHealthBar = 9

func _ready() -> void:
	PlayerHealthBar = 9
	refresh_player_health_bar()
	
func refresh_player_health_bar():
	if PlayerHealthBar == 0:
		$AnimationPlayer.play("1")
	if PlayerHealthBar == 1:
		$AnimationPlayer.play("2")
	if PlayerHealthBar == 2:
		$AnimationPlayer.play("3")
	if PlayerHealthBar == 3:
		$AnimationPlayer.play("4")
	if PlayerHealthBar == 4:
		$AnimationPlayer.play("5")
	if PlayerHealthBar == 5:
		$AnimationPlayer.play("6")
	if PlayerHealthBar == 6:
		$AnimationPlayer.play("7")
	if PlayerHealthBar == 7:
		$AnimationPlayer.play("8")
	if PlayerHealthBar == 8:
		$AnimationPlayer.play("9")
	if PlayerHealthBar == 9:
		$AnimationPlayer.play("10")
	if PlayerHealthBar < 0:
		PlayerHealthBar = 0
		$AnimationPlayer.play("1")
	if PlayerHealthBar > 9:
		PlayerHealthBar = 9
		$AnimationPlayer.play("10")
