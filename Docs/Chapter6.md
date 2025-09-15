# 受伤状态

依旧是先做一个受击时候的动画

## 受击状态

在小骑士状态机中新增一个`HURT`状态，并在小骑士的`Hurtbox`被进入的时候触发信号时改变状态为受伤状态，之后播放对应的动画，并根据受伤朝向与速度改变实现挨打时候被弹走的效果

## 黑冲无敌

在原作中黑冲过程是无敌的，因此在黑冲动画开始之前禁用受伤的碰撞体，并在黑冲动画播放完之后重置：

```GDScript
$HurtboxArea/Hurtbox.disabled = true/false
```

这样可以在黑冲时候无敌，但是普通冲刺撞到仍然会受伤

## 无敌时间

很多游戏在受击之后会给一小段无敌时间然后角色频闪。实现方式是给一个控制无敌时长的`Timer`，然后在进入受伤状态时禁用受伤的碰撞体，然后通过`../Sprite.visible`来控制角色闪烁：

```GDScript
func Invincible():
    $HurtboxArea/Hurtbox.set_deferred("disabled", true)
    $InvincibleTimer.start()
    while true:
        $SpriteArea/Sprite2D.visible = false
        await get_tree().create_timer(0.06).timeout
        $SpriteArea/Sprite2D.visible = true
        await get_tree().create_timer(0.06).timeout
        if $InvincibleTimer.is_stopped():
            $HurtboxArea/Hurtbox.set_deferred("disabled", false)
            break
```

## BOSS受击效果

原作中BOSS被打会突然变白一下，这里我们也来还原一下这个效果

这个闪白效果是通过对`BOSS`的`Sprite2D`的`Material`下的`Shader`实现的，主要是通过编辑`COLOR`来变白：

```GDScript
COLOR.rgba = vec4(1.0, 1.0, 1.0, texColor.a);
```

闪白效果制作完毕之后要让它与BOSS关联，则在BOSS的`Hurtbox`被进入的时候链接一个信号与刚刚制作的特效关联起来就可以了

另外一般BOSS会有一个受击间隔防止有时候一直触发掉血，这个也可以通过`Timer`来实现
