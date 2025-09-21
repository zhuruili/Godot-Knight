# 震动与卡帧

通过震动和卡帧可以制造一种打击感，震动可以在比如黑波、下砸、BOSS死亡等场景触发；卡帧其实就像一种子弹时间，当打出关键操作或者游戏进行到关键节点进行一个时间减速然后再恢复，在那一瞬间就会感觉很帅

## 震动

震动其实是通过调整摄像机的`offset`实现的：

```GDScript
offset = Vector2(randf_range(-shakeStrength, shakeStrength), randf_range(-shakeStrength, shakeStrength))
shakeStrength = move_toward(shakeStrength, 0, recovery_speed * delta)
```

给镜头添加随机扰动，并不断回正，看起来就是游戏画面在震动一样，想要触发这个效果我们只需要在方法中调整`shakeStrength`就可以了，并在对应的动作位置调用这个方法：

```GDScript
func camera_shake_small():
    shakeStrength = 3
```

## 卡帧

卡帧的时空减速效果其实是通过调整`Engine.time_scale`实现的，通过调整该属性的数值把时间放缓，之后等对应的`Timer`结束之后再将其回正：

```GDScript
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
```
