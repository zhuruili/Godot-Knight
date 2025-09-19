# BOSS的僵直和死亡

## 代码优化

前面做过了小骑士的死亡，其实BOSS这里是比较类似的，只不过多了个阶段性的“僵直”状态。整体制作和逻辑没什么好说的，这里说一点对于原视频的代码层面的小优化吧

视频中使用的是简易理解的代码逻辑，把BOSS血量划分为多个区间，然后每个区间用复制粘贴的形式写了大段的对受击`area`的判断逻辑，这里其实可以抽象提取成函数式的，后续只需要直接调用就可以了（视频中作者也有提到过这个问题，并表示后续会优化）

我个人的方法是进一步封装了一个根据血量区间和`area`来决定BOSS血量增减的函数：

```GDScript
func deal_damage(health_upper_limit, health_lower_limit, area):
    if BossHealth <= health_upper_limit and BossHealth >= health_lower_limit:
        if area.name == "Attack_1":
            BossHealth -= 13
        if area.name == "Attack_2":
            BossHealth -= 13
        if area.name == "Attack_Up":
            BossHealth -= 13
        if area.name == "Attack_Down":
            BossHealth -= 13
        if area.name == "HeiboHitboxArea":
            BossHealth -= 30
        if BossHealth < health_lower_limit:  # 看上去和上层分支冲突，但是这里是连续的if，在突变的那一帧之内其实是可以触发的
            call_deferred("change_state", State.HURT)
        if BossHealth <= 0:  # 理论上在内层不会发生，只是为了保险
            call_deferred("change_state", State.DIE_1)
```

当然，这里只是多个封装方案中的一种，肯定还有更优的逻辑

## 开门

成功击杀BOSS战斗结束后应该把门打开，封装开门对应的方法，并在BOSS的死亡动画中配置方法调用轨道的关键帧操作即可
