# BOSS的移动和跳跃

制作好移动和跳跃相关的动画

## 状态机

新增了动作则会对应的添加移动、跳跃、下落的状态机：

```GDScript
enum State {READY, IDLE, HUIKAN, HUIKAN_ZHUNBEI, SHANGTIAO, SHANGTIAO_ZHUNBEI,
            MOVE, JUMP, FALL}
```

然后修改状态机的切换逻辑，如果说小骑士距离BOSS在某个限定范围之内那么就直接触发之前制作好的攻击逻辑，但是如果小骑士的位置距离BOSS比较远，那么就触发移动或者跳跃，待靠近小骑士之后再触发攻击，并且由于之前的制作中还有转向面对小骑士的逻辑，所以视觉效果上就是BOSS一直在追着小骑士打

这里究竟是触发移动还是跳跃可以使用`randf()`来模拟控制概率给BOSS的行动添加一点随机性

```GDScript
if randf() > 0.5:
    call_deferred("change_state", State.MOVE)
else:
    call_deferred("change_state", State.JUMP)
```

## 移动

移动的逻辑是让BOSS一直朝着小骑士走，当距离足够近的时候就进入攻击状态：

```GDScript
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
```

## 跳跃

跳跃是让BOSS向小骑士的方向跳，并根据小骑士和BOSS的位置关系自适应调整水平方向的跳跃速度，并在上升达到最高点的时候切换为下落状态：

```GDScript
func process_jump(delta):
    if isStateNew:
        velocity.x = playerPosition.x - global_position.x
        velocity.y = -400
        $AnimationPlayer.play("跳跃")
    velocity.y += gravity * delta
    move_and_slide()
    if velocity.y > 0:
        call_deferred("change_state", State.FALL)
```

这里的`velocity.x = playerPosition.x - global_position.x`调整的其实不只是水平方向的速度大小，也包括跳跃的方向
