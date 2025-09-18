extends CanvasLayer

var PlayerSoul = 0

func _ready() -> void:
	PlayerSoul = 0
	refresh_player_soul()
	
func refresh_player_soul():
	if PlayerSoul == 0:
		$AnimationPlayer.play("1")
	if PlayerSoul == 1:
		$AnimationPlayer.play("2")
	if PlayerSoul == 2:
		$AnimationPlayer.play("3")
	if PlayerSoul == 3:
		$AnimationPlayer.play("4")
	if PlayerSoul == 4:
		$AnimationPlayer.play("5")
	if PlayerSoul == 5:
		$AnimationPlayer.play("6")
	if PlayerSoul == 6:
		$AnimationPlayer.play("7")
	if PlayerSoul == 7:
		$AnimationPlayer.play("8")
	if PlayerSoul == 8:
		$AnimationPlayer.play("9")
	if PlayerSoul == 9:
		$AnimationPlayer.play("10")
	if PlayerSoul < 0:
		PlayerSoul = 0
		$AnimationPlayer.play("1")
	if PlayerSoul > 9:
		PlayerSoul = 9
		$AnimationPlayer.play("10")
