# BOSS的后跳

后跳的触发和之前的动作一样基于概率加入状态机即可，这里主要记录下动画的选取和播放的朝向

## 两个问题

这里有两个逻辑上的问题需要简单分析一下。第一，起跳要往哪儿跳？；第二，起跳时候播放哪个动画？是普通的“跳跃”还是“后跳”？

```GDScript
func process_back_jump(delta):
    if isStateNew:
        velocity.x = -500 - global_position.x if playerPosition.x > (-500 - 240) * 0.5 else -240 - global_position.x
        velocity.y = -400
        if velocity.x < 0 and $SpriteArea.scale.x == 1:
            $AnimationPlayer.play("跳跃")
        if velocity.x < 0 and $SpriteArea.scale.x == -1:
            $AnimationPlayer.play("后跳")
        if velocity.x > 0 and $SpriteArea.scale.x == 1:
            $AnimationPlayer.play("后跳")
        if velocity.x > 0 and $SpriteArea.scale.x == -1:
            $AnimationPlayer.play("跳跃")
    velocity.y += gravity * delta
    move_and_slide()
    if velocity.y > 0:
        call_deferred("change_state", State.BACK_FALL)
```

### 问题一

第一个问题，往哪儿跳。这个“后跳”动作的本质其实是要让BOSS和小骑士拉开一定的距离为后续的BOSS冲撞和白波做铺垫的，所以要往远离小骑士所在的半边地图的边缘跳：

```GDScript
velocity.x = -500 - global_position.x if playerPosition.x > (-500 - 240) * 0.5 else -240 - global_position.x
```

这行代码其实就是在说，当小骑士在右半边地图的时候，BOSS往左边缘跳；小骑士在左半边地图的时候，BOSS往右边缘跳

### 问题二

第二个问题，播放哪个动画。代码中写了四种分支判断，但其实可以用一句话总结：如果跳跃方向和BOSS面朝的方向一致那么就播放普通“跳跃”动画，如果相反则播放“后跳”动画。而对于“下落”动画的选择逻辑其实也是类似的
