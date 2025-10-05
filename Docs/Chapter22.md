# 粒子特效

为BOSS的受击添加一个粒子特效，受击时会有黑色粒子弹出就像容器被打出了内含的虚空物质

> [!Tip]
> 如果你使用的是Godot4.x的版本，跟进视频教程的时候可能会发现在编辑粒子特效的属性时在视频对应的位置找不到你想要的属性名称。这时候使用该板块上方的搜索功能查找对应的属性名字就可以了，在4.x版本中确实有对应的属性，只不过位置和3.x版本中不同

## 特效的生成

这里BOSS受击的粒子特效和之前制作的拼刀特效一起由`TexiaoSpawner`管理，作为其子节点生成：

```GDScript
func spawn_hit_particle(boss_pos):
    var particle = load("res://scenes/hit_particle.tscn")
    var particle_node = particle.instantiate()
    particle_node.position = boss_pos
    add_child(particle_node)
```

并在BOSS受击时候调用：

```GDScript
func _on_hurtbox_area_area_entered(area: Area2D) -> void:
    ...
    var boss_pos = position
    $"/root/MainScene/TexiaoSpawner".spawn_hit_particle(boss_pos)
    ...
```

## 特效的释放

和之前制作的各种特效一样，子节点生成之后是不会自己消失的，需要在特效播放完之后释放它：

```GDScript
func _ready() -> void:
    emitting = true
    var total_time = lifetime + 0.1
    await get_tree().create_timer(total_time).timeout
    queue_free()
```

即特效播放完后经过短暂延迟被释放
