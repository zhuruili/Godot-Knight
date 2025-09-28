# BOSS的战吼

整体效果：开局BOSS从天空掉落下来，然后进入战吼准备，然后战吼，战吼的时候会有战吼特效并且强大的气场把小骑士吼退一点，并给以屏幕震动反馈

## 状态机变化

首先把一开始BOSS的出生位置调高一点`global_position.y = -180`，然后下落，落地后进入战吼前的准备，之后战吼，战吼结束后再变成普通状态：

```GDScript
func process_ready_2(delta):
    if isStateNew:
        $AnimationPlayer.play("下落")
    velocity.y += gravity * delta
    move_and_slide()
    if is_on_floor():
        velocity = Vector2.ZERO
        call_deferred("change_state", State.ZHANHOU_ZHUNBEI)

func process_zhanhou_zhunbei(delta):
    if isStateNew:
        $AnimationPlayer.play("战吼准备")
    if !$AnimationPlayer.is_playing():
        call_deferred("change_state", State.ZHANHOU)
```

## 小骑士战吼反馈

小骑士在BOSS战吼时候给他一个被气场短暂震慑的效果，即播放一个类似于被大风吹走的动画，让小骑士后退一点并平缓停下：

```GDScript
func process_scared(delta):
    if isStateNew:
        $AnimationPlayer.play("抬头")
        velocity.x = 150
    velocity.x = lerp(0.0, velocity.x, pow(2, -10 * delta))
    velocity.y += gravity * delta
    move_and_slide()
    if !$AnimationPlayer.is_playing():
        call_deferred("change_state", State.NORMAL)
```

并提供一个方法让BOSS得以在吼叫开始的时候调用并让小骑士进入`SCARED`状态：

```GDScript
func player_change_state_to_scared():
    call_deferred("change_state", State.SCARED)
```

## 吼叫特效

我们新增这个特效动画并与`TexiaoSpawner`绑定，其总体思路其实和之前的黑白波、拼刀等类似：

```GDScript
func spawn_zhanhou_texiao(boss_pos):
    var zhanhou_scene = load("res://scenes/zhanhou_texiao.tscn")
    var zhanhou_node = zhanhou_scene.instantiate()
    zhanhou_node.position = boss_pos
    add_child(zhanhou_node)
```

这里针对吼叫我们使用代码来提供一个接口将它在合适的时机消除，因为之前基本都是通过关键帧动画操作的，这里来尝试使用代码来控制：

```GDScript
func delete_zhanhou():
    var zhanhou_node = get_node("/root/MainScene/TexiaoSpawner/ZhanhouTexiao")
    zhanhou_node.queue_free()
```
