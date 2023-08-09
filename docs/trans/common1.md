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
tw.OnUpdate = t => Logger.Log(LogLevel.Info, "test", $"Tweening... Eased: {t.Tased}, Percent: {t.Percent}");
```

最后记得 `Start` 它并且记得把它挂载到实体上, 因为它的更新是依赖实体的:

```cs title="开始并挂载"
// 如果你对 `start` 参数传入 `true` 那么你可以不用做这一步
tw.Start();
// 这里假设我们的所有代码都进行在一个实体内部
this.Add(tw);
```