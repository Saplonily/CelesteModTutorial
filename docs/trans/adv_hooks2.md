# 协程的钩取与私有访问

## 协程的钩取

### 迭代器函数

迭代器函数, 也即方法体带 `yield return` 或 `yield break` 语句并返回 `IEnumerable` 或 `IEnumerator` 的函数,
它允许你 "中断" 函数的运行并中途 "返回" 一个值. 经过前面 [Alarm, Tween, Coroutine](../trans/common1.md) 节的介绍相信你也知道到了协程之于迭代器函数的强大.
不过对于协程函数的钩取并不是那么简单, 需要一些额外步骤.  

如果你相对了解一点 C# 的底层的话, 你应该会知道迭代器函数最终会被编译为一个状态机类, 而原函数只是做了一个 new 并返回的工作.  
为了在反编译器比如 dnspy 中浏览这个状态机类, 你需要关闭类似的 视图 -> 选项 -> 反编译器 -> 反编译枚举器 这个功能, 这样反编译器才会展示隐藏的状态机类.  

比如 `FinalBoss.Attack01Sequence` 方法:

原方法:

```cs
private IEnumerator Attack01Sequence()
{
	this.StartShootCharge();
	for (;;)
	{
		yield return 0.5f;
		this.Shoot(0f);
		yield return 1f;
		this.StartShootCharge();
		yield return 0.15f;
		yield return 0.3f;
	}
	yield break;
}
```

关闭 反编译枚举器 选项后:

```cs
private IEnumerator Attack01Sequence()
{
	FinalBoss.<Attack01Sequence>d__49 <Attack01Sequence>d__ = new FinalBoss.<Attack01Sequence>d__49(0);
	<Attack01Sequence>d__.<>4__this = this;
	return <Attack01Sequence>d__;
}
```

其中 `<Attack01Sequence>d__49` 这个古怪的类名就是背后生成的状态机类, 而方法体的实际内容则在该类的 `MoveNext` 方法中:

```cs
bool IEnumerator.MoveNext()
{
    int num = this.<>1__state;
    FinalBoss finalBoss = this.<>4__this;
    switch (num)
    {
    case 0:
        this.<>1__state = -1;
        finalBoss.StartShootCharge();
        break;
    case 1:
        this.<>1__state = -1;
        finalBoss.Shoot(0f);
        this.<>2__current = 1f;
        this.<>1__state = 2;
        return true;
    case 2:
        this.<>1__state = -1;
        finalBoss.StartShootCharge();
        this.<>2__current = 0.15f;
        this.<>1__state = 3;
        return true;
    case 3:
        this.<>1__state = -1;
        this.<>2__current = 0.3f;
        this.<>1__state = 4;
        return true;
    case 4:
        this.<>1__state = -1;
        break;
    default:
        return false;
    }
    this.<>2__current = 0.5f;
    this.<>1__state = 1;
    return true;
}
```

上述代码中 `<>2__current` 这个古怪的字段用来储存返回值, `<>1__state` 则用来储存协程运行的进度.

### On 协程钩子

对协程使用 On 钩子相对简单一点 ,例如钩取 `Celeste.NPC01_Theo.Talk` 这个协程函数, 也就是 1a 6zb 面的 theo 的对话的协程,
如果你直接使用如下代码(方法 1):

```cs
public override void Load()
{
    On.Celeste.NPC01_Theo.Talk += NPC01_Theo_Talk;
}

private IEnumerator NPC01_Theo_Talk(On.Celeste.NPC01_Theo.orig_Talk orig, NPC01_Theo self, Player player)
{
    var it = orig(self, player);
    Logger.Log(LogLevel.Info, "Test", "not the right time.");
    return it;
}

public override void Unload()
{
    On.Celeste.NPC01_Theo.Talk -= NPC01_Theo_Talk;
}
```

你会发现它实际上是在对话开始前输出的, 这并不是我们想要的时机, 同样这也很好理解为什么会这样, 因为原函数只是返回了一个背后状态机类的新实例.  
为了达成这个目的, 我们需要这么做(方法 2):

```cs
private IEnumerator NPC01_Theo_Talk(On.Celeste.NPC01_Theo.orig_Talk orig, NPC01_Theo self, Player player)
{
    IEnumerator origEnum = orig(self, player);
    while (origEnum.MoveNext()) yield return origEnum.Current;
    Logger.Log(LogLevel.Info, "Test", "the right time.");
}
```

也就是将对应的协程包装起来并在最后附加我们的代码. 说到这个, 你可能会想到这段代码可以简化成这样(方法 3):

```cs
private IEnumerator NPC01_Theo_Talk(On.Celeste.NPC01_Theo.orig_Talk orig, NPC01_Theo self, Player player)
{
    yield return orig(self, player);
    Logger.Log(LogLevel.Info, "Test", "does not execute.");
}
```

直接将协程返回并在其执行完后做一些事, 看起来似乎没什么问题? 但是! 如果你看过 `Coroutine` 的实现的话,
你会发现协程返回另一个协程时, 另一个协程并不是马上执行的, 而是等到了下一帧, 为了更好的兼容 tas, 我们要么使用方法 2, 要么使用如下类似的代码(方法 4):

```cs
private IEnumerator OuiFileSelect_Leave(On.Celeste.OuiFileSelect.orig_Leave orig, OuiFileSelect self, Oui next) 
{
    yield return new SwapImmediately(orig(self, next));
    Logger.Log("TestMod", "I left file select!");
}
```

也就是在获取协程后再用 everest 为我们提供的 `SwapImmediately` 包起来, 这会让内部的协程立刻前进一次. 而不会等待多余的 1 帧.

!!! info
    具体上述方法的行为描述的可能并不是很准确, 因为我个人很少会出现需要钩取协程的案例, 很感谢如果你能完善它的话!

### IL 协程钩子

对协程使用 IL 钩子相对会复杂很多, 因为对原函数使用 IL 钩子通常是没有意义的, 为此, 我们需要获取到背后实际储存方法体的状态机的 `MoveNext` 方法:

```cs
var methodInfo = typeof(Player).GetMethod("DashCoroutine", BindingFlags.NonPublic | BindingFlags.Instance).GetStateMachineTarget();
ILHook dashCoroutineHook = new ILHook(methodInfo, ILHookDashCoroutine);
```

在这里, MonoMod 为我们提供了一个很方便的拓展方法 `GetStateMachineTarget`, 它会获取这个方法对应的状态机的 `MoveNext` 方法,
随后我们手动构造一个 IL 钩子, 然后就像往常一样实现我们的钩子. 不过当然, 难度会非常大, 因为通常这个方法是非常混乱的.

## 私有访问

通常, 你可能需要访问一个私有方法或者私有字段, 首先最容易想到的当然是反射, 不过 MonoMod 为我们提供了一个更好的东西:
`DynamicData` 类, 例如访问玩家的私有字段 `onGround`:

```cs
DynamicData playerData = DynamicData.For(player);
bool onGround = playerData.Get<bool>("onGround");
```

修改也十分简单, 例如修改玩家的最大下落速度:

```cs
playerData.Set("maxFall", 660f);
```

调用私有方法同理, 参数也只需作为 params 参数传递:

```cs
playerData.Invoke("Duck");

bool checkResult = (bool)playerData.Invoke("DreamDashCheck", Vector2.UnitX);
```

对于静态类, 只需要简单的更改获取 `DynamicData` 的方式:

```cs
DynamicData inputData = new DynamicData(typeof(Input));
```

随后静态方法, 字段, 属性的访问也与实例的相同.  

当字符串指定的成员不存在时, 注意并不会报错, 对于其的非泛型 `Get` 方法会简单地返回 null 值, 对于值类型泛型 `Get` 方法会引发空引用异常, 对于引用类型泛型 `Get` 方法返回 null.
不过对于 `Set` 方法, 如果指定的成员不存在时它会将这个成员 "粘附" 到对象上, 就像给对象动态加了一条字段一样, 随后使用 `Get` 方法也能获取到这个值,
你可以使用将这个行为当 "动态添加字段" 一样使用. 例如:

```cs
DynamicData dd = DynamicData.For(player);
dd.Set("mcm_attached", "some attached data...");


// ...一些其他地方
string data = dd.Get<string>("mcm_attached");
Logger.Log(LogLevel.Info, "MyCelesteMod", $"data is {data}");
```

不过记得添加自己 mod 独特的命名前缀以防重名, `DynamicData` 在不同 mod 间是共享的.