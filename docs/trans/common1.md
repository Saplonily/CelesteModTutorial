# Alarm, Tween, Coroutine

那么经过前面这么多废话(确信)之后我们终于来到了介绍一些常见的蔚蓝类和 Monocle 类的地方(wuwu), 那么...就开始吧.

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