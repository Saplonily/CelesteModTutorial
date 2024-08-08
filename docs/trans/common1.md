# Alarm, Tween, Coroutine

## Tween

Tween 是一个在 Monocle 中用来实现**缓动**的 `Component`, 在这里你可以进行所有 [easings.net](https://easings.net/) 上的缓动, 它的使用方法很简单:
```cs title="使用 Tween"
// 首先使用静态方法 Tween.Create 来创建
Tween tw = Tween.Create(Tween.TweenMode.Oneshot, Ease.BackIn, 1f, false);
```

这里参数可能相对较多:

- 第一个参数 `mode`: 它表示缓动的类型, 可用的有:
    - `Persist`: 缓动结束后该组件会失活, 直到再次被调用 `Start`
    - `Oneshot`: 缓动结束后该组件会移除自身
    - `Looping`: 缓动结束一次后会立刻再次开始同一个缓动, 并循环
    - `YoyoOneshot`: 缓动结束后会立刻进行一次反向的缓动, 结束后移除自身
    - `YoyoLooping`: 同 `YoyoOneshot`, 但是会循环而不是移除自身
- 第二个参数 `easer`: 它表示该缓动的 `Easer`, 通常我们使用 `Ease` 类中的已有静态字段中提供的就行了, 
同样地你可以在 [easings.net](https://easings.net/) 感受并检索你所需要的缓动类型.
- 第三个参数 `duration`: 表示该缓动进行的时间(单位秒), 对于特殊的缓动类型来说它指一次正向缓动或者一次反向缓动所需时间.
- 第四个参数 `start`: 是否立即开始这个 `Tween`, 否则我们得需要手动调用 `Start` 方法

在创建完我们的 `tw` 实例后, 我们先制点小目标:

- 在缓动开始时输出 "Tween start!"
- 在缓动过程时输出 "Tweening... Eased: <此时的缓动值>, Percent: <缓动已进行的时间占比>"
- 在缓动结束后输出 "Tween complete!"

对于开始和结束很简单, 我们只需要赋值一些字段:

```cs title="赋值 Tween 的一些字段"
tw.OnStart = t => Logger.Log(LogLevel.Info, "test", "Tween start!");
tw.OnComplete = t => Logger.Log(LogLevel.Info, "test", "Tween complete!");
```

在这里我们使用 lambda 表达式为其赋值, 其中该 lambda 被传入的参数就是这个 `Tween` 实例, 这可以帮助我们避免 lambda 捕获以及复用我们的 `Tween` 处理函数.

对于缓动过程, 我们首先介绍两个属性:

- `Eased`: 表示该缓动当前的 "缓动值"
- `Percent`: 表示该缓动已进行时间占比, 即 已进行时间/总时间

一个更清楚的例子是观察 [easings.net](https://easings.net/) 的图像, `Eased` 即纵坐标值, `Percent` 即横坐标值.

那么这里就很简单实现了:
```cs
tw.OnUpdate = t => Logger.Log(LogLevel.Info, "test", $"Tweening... Eased: {t.Eased}, Percent: {t.Percent}");
```

最后记得 `Start` 它并且记得把它挂载到实体上, 因为它的更新是依赖实体的:

```cs title="开始并挂载"
// 如果你对 `start` 参数传入 `true` 那么你可以不用做这一步
tw.Start();
// 这里假设我们的所有代码都进行在一个实体内部
this.Add(tw);
```

或者, 我们使用 `Tween.Set` 方法, 它是一个工具方法允许我们简化对 Tween 的使用, 上面的例子用这个方法可以写成这样:
```cs
Tween tw = Tween.Set(this, Tween.TweenMode.Oneshot, 1f, Ease.BackIn,
    t => Logger.Log(LogLevel.Info, "test", $"Tweening... Eased: {t.Eased}, Percent: {t.Percent}"),
    t => Logger.Log(LogLevel.Info, "test", "Tween complete!"));
// OnStart 还得手动设置呐
tw.OnStart = t => Logger.Log(LogLevel.Info, "test", "Tween start!");
tw.Start();
```

它会自动帮我们挂载到实体上, 不过依然需要我们手动 `Start`, 这里方便之处就在于你可以直接把一个简单的函数直接在参数中传入,
而不是 `Create` 后再设置字段. 不过这里参数列表中并没有 `Start` 相关的参数, 如果你还需要设置 `Start` 的回调的话你可以回退到上面的例子中的方法,
就像上面的代码一样手动设置 `OnStart`.

## Alarm

顾名思义, 它就是个'闹钟', 它允许你设定一个时间并在时间结束后做一些事情, 其使用起来很简单:
```cs
Alarm alarm = Alarm.Create(Alarm.AlarmMode.Oneshot, OnAlarm, 2f, false);
Add(alarm);
alarm.Start();

static void OnAlarm()
{
    Logger.Log(LogLevel.Info, "Test", "123");
}
```

- 第一个参数 `AlarmMode` 与 `Tween.TweenMode` 的基本一致, 这里就不赘述了
- 第二个参数表示时间到后的回调函数
- 第三个参数表示时间有多长
- 第四个参数也与 tween 类似, 表示是否希望自动调用 `Start` 方法

除了在第三个参数处设置时间长度外, `Start` 方法也允许我们传入一个时间长度, 这会在你需要一个不定长的闹钟的时候很有用.  
除此之外, `Alarm` 也有类似于 `Tween.Set` 的方法直接作用与 `Entity` 上, 参数也与其构造函数相同:
```cs
// 不过这里 AlarmMode 反而被 matt 放到最后去了
Alarm.Set(this, 2f, OnAlarm, Alarm.AlarmMode.Oneshot).Start();
```

## Coroutine

`Coroutine` 常见的中文翻译叫做 '协程', 它是一个非常强大的东西, async/await 异步允许我们像写同步代码一样写异步代码,
大概类似地, 协程就允许我们像写一个在同一帧内允许的代码一样写在不同帧内运行的代码.  
好吧上面这句话有点乱, 不过我们看一下例子就会理解了:
```cs
var coroutine = new Coroutine(MakeRoutine());
Add(coroutine);

static IEnumerator MakeRoutine()
{
    Logger.Log(LogLevel.Info, "tag", "开始!");
    yield return 1f;
    Logger.Log(LogLevel.Info, "tag", "过了1s!");
    yield return 2f;
    Logger.Log(LogLevel.Info, "tag", "又过了2s!");
    yield break;
}
```
!!! info
    上述代码中的 `yield return` 等语法属于 "迭代器函数", 如果你不了解它的话你可以到 [msdn](https://learn.microsoft.com/zh-cn/dotnet/csharp/iterators) 上或者 [bing 搜索](https://cn.bing.com/search?q=C%23+%E8%BF%AD%E4%BB%A3%E5%99%A8%E5%87%BD%E6%95%B0) 上查找它.
上述代码会立刻打印一句 "开始!" 然后等待1s, 然后打印 "过了1s!", 再过了2s后再次打印"又过了2s!".
也就是说你每 `yield return` 一个浮点数, 游戏会等待该秒数, 然后继续执行下面的代码.  
你可能觉得这不就是个高级点的 `Alarm` 吗, 确实, 你仍然可以用 `Alarm` 来重写这部分功能, 不过很快你就会陷入回调地狱并且代码也变的十分难读:
```cs
Logger.Log(LogLevel.Info, "tag", "开始!");
Alarm.Set(this, 1f, () =>
{
    Logger.Log(LogLevel.Info, "tag", "过了1s!");
    Alarm.Set(this, 2f, () =>
    {
        Logger.Log(LogLevel.Info, "tag", "又过了2s!");

    }, Alarm.AlarmMode.Oneshot);

}, Alarm.AlarmMode.Oneshot);
```

除了返回一些浮点数, 我们还可以返回一个 `null`, 这样会让游戏仅等待一帧, 也就是在这次返回后, 游戏在下一帧立刻继续执行而不是等待秒数.  
比如在官图中 `FallingBlock` 对其的一个应用(已简化, 删除了 BadelineBoss 相关的代码):
```cs title="Celeste.FallingBlock.Sequence()"
// 持续检测是否玩家在上面抓/站着
while (!PlayerFallCheck())
    yield return null;
// 玩家抓/站着, 进入掉落状态
HasStartedFalling = true;
while (true)
{
    // 在真正进行向下移动时先等待 0.2s 
    yield return 0.2f;

    // 然后等待 0.4s, 但是玩家离开掉落块后会取消这个等待
    float waitTimer = 0.4f;
    while (waitTimer > 0f && PlayerWaitCheck())
    {
        yield return null;
        waitTimer -= Engine.DeltaTime;
    }

    // ......, 执行持续掉落的逻辑, 直到碰到了平台(泛指所有上面能站的东西, 非指木平台, 下同)然后停下

    // 每隔 0.1s 检测是否底下依然还存在平台, 否则进入下一次 while 循环
    while (CollideCheck<Platform>(Position + new Vector2(0f, 1f)))
        yield return 0.1f;
}
......
```
现在回忆一下官图的掉落块的逻辑, 是不是和上面代码描述的一致?  
如果没有了协程, 我们就得用一个状态变量来储存掉落块进行到哪一步, 并且时时刻刻维护这个变量, 日益变的越来越麻烦.

协程还能返回另一个协程, 只需要返回一个 `IEnumerator`:
```cs
var coroutine = new Coroutine(MakeRoutine());
Add(coroutine);

static IEnumerator MakeRoutine()
{
    Logger.Log(LogLevel.Info, "tag", "开始!");
    yield return 1f;
    Logger.Log(LogLevel.Info, "tag", "过了1s!");
    yield return MakeRoutineInner();
    Logger.Log(LogLevel.Info, "tag", "内部的协程结束了!");
    yield return MakeRoutineInner();
    Logger.Log(LogLevel.Info, "tag", "内部的协程又一次结束了!");
    yield break;
}

static IEnumerator MakeRoutineInner()
{
    yield return 1f;
    Logger.Log(LogLevel.Info, "tag", "内部等了1s!");
    yield return 1f;
    Logger.Log(LogLevel.Info, "tag", "内部又等了1s!");
    yield break;
}
```
它的输出会像是:
```log
(09/30/2023 13:39:28) [Everest] [Info] [tag] 开始!
(09/30/2023 13:39:29) [Everest] [Info] [tag] 过了1s!
(09/30/2023 13:39:30) [Everest] [Info] [tag] 内部等了1s!
(09/30/2023 13:39:31) [Everest] [Info] [tag] 内部又等了1s!
(09/30/2023 13:39:31) [Everest] [Info] [tag] 内部的协程结束了!
(09/30/2023 13:39:32) [Everest] [Info] [tag] 内部等了1s!
(09/30/2023 13:39:33) [Everest] [Info] [tag] 内部又等了1s!
(09/30/2023 13:39:33) [Everest] [Info] [tag] 内部的协程又一次结束了!
```

使用协程, 我们可以很轻松的就像自然描述一个过程一样 "自然" 地写实现的代码, 官图中剧情的实现就是一个很好的例子(此处为序章鸟教冲刺的剧情, 已大量简化):
```cs title="Celeste.CS00_Ending"
private IEnumerator Cutscene(Level level)
{
    // 慢慢减慢游戏速度直到 0.0x, 并且在减慢到 0.5x 时停止桥崩塌音乐
    while (Engine.TimeRate > 0f)
    {
        yield return null;
        if (Engine.TimeRate < 0.5f && bridge != null)
            bridge.StopCollapseLoop();
        level.StopShake();
        Engine.TimeRate -= Engine.RawDeltaTime * 2f;
    }
    // 此时游戏速度会被误减到负数, 设置回 0 防止游戏行为异常
    Engine.TimeRate = 0f;
    // 切换玩家状态到 StDummy, 即禁止所有输入和交互
    player.StateMachine.State = Player.StDummy;
    // 锁定玩家朝向为右
    player.Facing = Facings.Right;
    // 无视游戏速度地等待 1s, 默认返回浮点数的等待会受游戏速度影响,
    // 这里如果用返回浮点数的等待会造成协程停止, 因为游戏速度为 0x, 即等待永远不会结束
    yield return WaitFor(1f);
    // 播放鸟飞入的声音
    Audio.Play("event:/game/general/bird_in", bird.Position);
    // 设置鸟的朝向和动画
    bird.Facing = Facings.Left;
    bird.Sprite.Play("fall", false, false);
    // 缓动鸟的位置, 并在鸟飞到一半时播放飞行的动画
    float percent = 0f;
    Vector2 from = bird.Position;
    Vector2 to = bird.StartPosition;
    while (percent < 1f)
    {
        bird.Position = from + (to - from) * Ease.QuadOut(percent);
        if (percent > 0.5f)
            bird.Sprite.Play("fly", false, false);
        percent += Engine.RawDeltaTime * 0.5f;
        yield return null;
    }
    bird.Position = to;
    from = default(Vector2);
    to = default(Vector2);
    // 播放鸟碰地的音效
    Audio.Play("event:/game/general/bird_land_dirt", bird.Position);
    // 向左释放尘埃粒子效果
    Dust.Burst(bird.Position, - MathHelper.PI / 2, 12);
    // 播放闲置动画, 然后等待 0.5s 后再次播放啄地的动画
    bird.Sprite.Play("idle", false, false);
    yield return WaitFor(0.5f);
    bird.Sprite.Play("peck", false, false);
    // 等待 1.1s, 也就是差不多啄地动画的长度
    yield return WaitFor(1.1f);
    // 播放冲刺教学
    yield return bird.ShowTutorial(new BirdTutorialGui(
        bird, new Vector2(0f, -16f), Dialog.Clean("tutorial_dash", null), 
        new Vector2(1f, -1f), "+", BirdTutorialGui.ButtonPrompt.Dash
        ), caw: true);

    // 持续等待, 直到玩家按下了右上冲
    for (;;)
    {
        Vector2 aimVector = Input.GetAimVector(Facings.Right);
        if (aimVector.X > 0f && aimVector.Y < 0f && Input.Dash.Pressed)
            break;
        yield return null;
    }
    // 设置玩家的状态为 "鸟冲刺教程" 状态, 这个状态即冲刺开始到上岸并强制移动到右侧的状态
    player.StateMachine.State = Player.StBirdDashTutorial;
    player.Dashes = 0;
    level.Session.Inventory.Dashes = 1;
    // 恢复游戏速率
    Engine.TimeRate = 1f;
    // 收回鸟的教程框框
    bird.Add(new Coroutine(bird.HideTutorial()));
    // 等待 0.25s
    yield return 0.25f;
    // 播放鸟被玩家吓走飞走的动画 (此时大约是玩家冲刺结束的时间)
    bird.Add(new Coroutine(bird.StartleAndFlyAway()));
    // 等待直到玩家落地, 或者直到玩家寄了
    while (!player.Dead && !player.OnGround(1))
        yield return null;
    // 等待 2s
    yield return 2f;
    // 播放 title_ping 音效, 如果你想不起来的话你可以去仔细听听
    // 在蔚蓝源 fmod 工程文件里它的音频文件位于 music/kuraine/mus_lvl0_titleping_oneshot.ogg
    Audio.SetMusic("event:/music/lvl0/title_ping");
    // 继续等待 2s
    yield return 2f;
    // 向场景中加入显示 "你能做到." 这句话的实体
    endingText = new PrologueEndingText(false);
    Scene.Add(endingText);
    
    // 获取关卡中控制前景雪和背景雪的实体
    Snow bgSnow = level.Background.Get<Snow>();
    Snow fgSnow = level.Foreground.Get<Snow>();
    // 顺便加入高分辨率的雪, 也即 ui 层上的雪 (HiresSnow = High resolution snow)
    level.Add(level.HiresSnow = new HiresSnow(0.45f));
    // 但是先把透明度调成 0, 用来等会渐变
    level.HiresSnow.Alpha = 0f;

    // 开始渐变三层雪的透明度
    float ease = 0f;
    while (ease < 1f)
    {
        ease += Engine.DeltaTime * 0.25f;
        float eased = Ease.CubeInOut(ease);
        if (fgSnow != null)
            fgSnow.Alpha -= Engine.DeltaTime * 0.5f;
        if (bgSnow != null)
            bgSnow.Alpha -= Engine.DeltaTime * 0.5f;
        level.HiresSnow.Alpha = Calc.Approach(level.HiresSnow.Alpha, 1f, Engine.DeltaTime * 0.5f);
        // 于此同时 "你能做到." 这句话也慢慢降下来
        endingText.Position = new Vector2(960f, 540f - 1080f * (1f - eased));
        // 摄像机也慢慢向上移动
        level.Camera.Y = level.Bounds.Top - 3900f * eased;
        yield return null;
    }
    // 结束这个剧情
    EndCutscene(level);
    yield break;
}
```