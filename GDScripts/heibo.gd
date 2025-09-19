extends CharacterBody2D

var direction = 1 # 注意黑白波本身动画朝向不一样所以下面脚本很多数值是相反数

func _ready() -> void:
	$AnimationPlayer.play("BlackWave")

func _process(delta: float) -> void:
	if direction == 1:
		velocity.x = 600
	else:
		velocity.x = -600
	move_and_slide()
	
	# 获取相机
	var camera = get_viewport().get_camera_2d()
	if not camera:
		print("未找到相机")
		return

	# 获取实际视口大小（避免分辨率缩放导致的误差）
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x
	var viewport_height = viewport_rect.size.y

	# 计算相机视角下的世界坐标边界（适配相机移动范围）
	var margin = 100 # 边缘冗余，防止过早销毁
	var half_width = viewport_width / 2
	var half_height = viewport_height / 2

	# 相机当前的世界坐标（相机x有分段逻辑，这里取实时值）
	var cam_x = camera.global_position.x
	var cam_y = camera.global_position.y

	# 世界坐标下的可见区域边界
	var min_x = cam_x - half_width - margin
	var max_x = cam_x + half_width + margin
	var min_y = cam_y - half_height - margin
	var max_y = cam_y + half_height + margin

	# 检查子弹是否在边界内
	var is_inside = (global_position.x > min_x) && (global_position.x < max_x) && (global_position.y > min_y) && (global_position.y < max_y)

	# 详细调试信息
	if not is_inside:
		#print("""
		#子弹位置：%s
		#相机位置：%s
		#视口大小：%s x %s
		#边界范围：x[%s~%s], y[%s~%s]
		#移动方向：%s（速度：%s）
		#""" % [
			#global_position,
			#camera.global_position,
			#viewport_width, viewport_height,
			#min_x, max_x, min_y, max_y,
			#direction, velocity.x
		#])
		queue_free()
