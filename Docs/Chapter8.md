# BOSS的挥砍和上挑

第一步依旧是老生常谈的动画制作，注意这里刀光制作要加碰撞体相关的关键帧（这里刀光碰撞体关键帧要用“离散”更新模式不要用“连续”，不然砍小骑士似乎不生效）

## BOSS的状态机

这里BOSS其实也可以算作是一个角色，只不过不像小骑士是人操作的。那么在开发初期我们可以通过较为简单的状态机设计写一个死逻辑来测试BOSS在各个状态下的表现是否正常，例如：站立 -> 挥砍准备 -> 挥砍 -> 上挑准备 -> 上挑 -> 站立

然后根据小骑士的位置来控制BOSS面对的方向：

```GDScript
func turn_direction():
    var playerPosition = get_node("/root/MainScene/Player").global_position
    $SpriteArea.scale.x = 1 if playerPosition.x < global_position.x else -1
    $HurtboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
    $BodyHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
    $DaoguangHitboxArea.scale.x = 1 if playerPosition.x < global_position.x else -1
    $CollisionPolygon2D.scale.x = 1 if playerPosition.x < global_position.x else -1
```

转向的实现其实和小骑士是差不多，只不过这里的转向是根据小骑士的位置来确定的

随后再在处理BOSS对应状态的函数中添加物理属性的递变，比如速度、重力之类的，其实也和之前对小骑士的操作思路是类似的

## 关门战斗

当角色进入BOSS战场景一定距离之后就关门不让BOSS和小骑士乱跑，并在此时激活BOSS从准备到站立模式：

```GDScript
func process_ready(delta):
    turn_direction()
    $AnimationPlayer.play("站立")
    if playerPosition.x < -250:
        var door = get_node("/root/MainScene/Doors/Door")
        door.close()
        call_deferred("change_state", State.IDLE)
```

这样一来就和游戏中的 进入 -> 关门 -> 战斗 的模式相同了
