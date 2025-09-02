# 小骑士基础移动

实现小骑士的站立、移动、跳跃、转向

## 新建角色

新建`CharacterBody2D`命名Player，其下加入`Sprite2D`、`AnimationPlayer`、`CollisionPolygon2D`

## 创建动画

将动画对应的图片拖入`Sprite2D`的`Texture`中，之后根据动画的帧数调整`Hframes`，之后添加各类关键帧信息，设置播放帧数等。快速开启下一个动画的制作可以复制一份当前动画

## 碰撞体

碰撞体的绘制：点击`CharacterBody2D`，在图像上绘制对应的形状即可

物理层：设置2D物理层的信息，然后在各个对象的`collision`属性中可以看到`Layer`和`Mask`，第一个是说当前对象属于哪一个物理层，而第二个是指这一层需要抓取那一层的信息，这俩可以多选

## 编码基础

Godot游戏开发可以通过`GDScript`语言来编写游戏脚本，这是个基于`Python`和`TypeScript`的语言，入门有些基础知识需要注意一下：

- `func _ready()`是游戏一开始要执行的
- `func _process()`是游戏运行中的每一帧需要执行的
- `delta`表示游戏运行每一帧经过的时间

## 键位设置

在项目设置的键位映射中可以设置游戏键位

## 移动编码

可以创建一个`moveVector`向量来接收键盘输入映射出的移动方向，并且有个一般化的处理左右移动以及跳跃的写法：

```GDScript
moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
moveVector.y = -1 if Input.is_action_just_pressed("jump") else  0
```

随后可以使用`clamp()`来限制平滑加速后的速度上下限，使用`lerp()`来实现平滑减速，这里平滑减速有个小细节：

```GDScript
velocity.x = lerp(0.0, velocity.x, pow(2, -50 * delta))
```

这种写法通过动态调整插值系数与时间关联，能在不同帧率下保持一致的减速效果，而传统的固定系数的写法会因帧率变化导致减速效果不一致

此外还有“长按长跳，短按短跳”的实现：

```GDScript
if velocity.y < 0 and !Input.is_action_pressed("jump"):
    velocity.y += jumpHigher * delta * gravity
```

其实就相当于你在上升但是你已经没有按着跳跃键了，那么就给你一个向下的力

随后如果你直接根据运动状态使用`$AnimationPlayer`播放对应的动画，你会发现这个动画是单向的，这里需要通过`$Sprite2D.scale.x`的值来控制动画播放的朝向实现转向
