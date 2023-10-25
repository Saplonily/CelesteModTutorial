# 阅读代码 II

一些情况下, 阅读由反编译器生成的代码时可能不是那么顺利, 那么这一节会简单说一些反编译器生成的代码与通常的 C# 代码不一样的地方.

## 奇奇怪怪的昵称与代码

在反编译器中可能会出现这种奇怪的语法:
```cs title="Celeste.FinalBoss (即 6a 后半段 Badeline Boss 实体)"
public void orig_ctor(EntityData e, Vector2 offset)
{
    this..ctor(e.Position + offset, e.NodesOffset(offset), e.Int("patternIndex", 0), e.Float("cameraPastY", 120f), e.Bool("dialog", false), e.Bool("startHit", false), e.Bool("cameraLockY", true));
}
```

嗯...好的, 首先 `orig_ctor` 这个名字有点怪但是能接受, 但是接下来的 `this..ctor` 是什么? 它甚至在 `C#` 中是个非法语法!  
其实这并不罕见, 由于 Everest 对蔚蓝程序的修改并不只是停留在表面, 而更是深入到了 **IL 代码层**, 这是一种相对底层的代码,
你的 `C#` 代码最终**都**会被编译为 `IL` 然后扔给**运行时(runtime)**来执行, 同样地, 所有其他的 `.NET` 系语言比如 `VB.NET` 和 `F#` 也都会被编译为 IL.  
那么既然这里的 IL 是由 `C#` 编译而来的, 那么这样的 IL 多多少少会有一种 "C# 味", 反编译器就是靠这种一定的 "C# 味" 来逆推出可能的 `C#` 源码. 
但是既然这里 Everest 直接在 IL 代码层进行了修改, 破坏了这种 "C# 味", 那自然反编译器就会生成奇奇怪怪的代码.

那么原因说完了, 接下来就来解决这些 "是什么" 的问题:

### .ctor / .cctor

`.ctor` 是一种特殊的函数名称, 表示类的**构造函数**, 比如 `Player..ctor(a, b)` 就表示这里调用了 `Player..ctor` 这个函数, 虽然你自己在 C# 中是做不到的.  
所以我们经常也会用 `ctor` 或者 `.ctor` 来指代 "构造函数".  

`.cctor` 也是一种特殊的函数名称, 表示类的**静态构造函数**, 比如 `Input..cctor()` 就表示调用 `Input` 类的无参静态构造函数.
同样地我们通常也会用 `cctor` 或者 `.cctor` 来指代 "静态构造函数".

这一类函数在 `IL` 层有个标记叫 `special name`, 当反编译器发现一个方法名为 `.ctor` 且带有 `special name` 标记的方法时,
反编译器就会认为它是一个构造函数, 如果反编译器发现这个方法在一个构造函数开头调用了, 那么反编译器就会认为这个构造函数带一个构造函数链,
但是如果它的调用位置在其他位置, 同时又因为 `C#` 编译器是不可能编译, 那么反编译器就会不知所措, 只能无奈的生成 `xxx..ctor()` 这种错误的语法.
这也是我们上面看到的 `this..ctor` 这种语法被生成的原因, 因为这个构造函数调用不在构造函数里出现, 而是在一个正常的 `orig_ctor` 方法里面!

!!! info
    在前面的钩子节我们没有探讨过构造函数如何钩取, 在这里你可能就会明白, 钩取名字为 `ctor` 的函数就是钩取了构造函数, 静态构造函数同理.

### orig_*

还有一些函数以 `orig_` 开头, 这其实是 everest 自己"钩取"的函数. 在这里, 比如 `Player.Update` 方法就被 everest 进行了"钩取",
而钩子函数本体就是 `Player.Update`, 而对应我们钩子的 `orig` 委托在就体现为 `orig_Update` 方法.

```cs title="Player.Update  (像钩子本体一样!)"
public override void Update()
{
	this.orig_Update(); // 就像在我们的钩子里调用 orig 委托一样
    // 就像在我们的钩子里在函数执行完后做些事情一样
	Level level = base.Scene as Level;
	if (level == null)
    ......
}
// Player.orig_Update() 就像我们的钩子钩取的原函数!
```

!!! info
    如果你自行钩取 `Player.Update` 函数这种已被 everest "钩取" 的函数实际上你钩取的是 everest 的钩子, 这对于 `On` 钩子可能没有大影响,
    但是对于后面我们会说的 `IL` 钩子有很大影响, 不过这些我们等到后面再说.

## StateMachine

这是 Monocle 中的一个 Component 类, 是一个**状态机**的实现, 具体的用法我会在 **常见 Celeste, Monocle 类**~在写了.jpg~ 节说, 这里仅是方便你阅读一下相关的代码:

### `St*` 类字段  
在阅读 `Player` 类的代码时, 你会看到这些`St`开头名字的常量但是你找不到"被使用"的地方:

- const int StNormal = 0;
- const int StClimb = 1;
- const int StDash = 2;
- const int StSwim = 3;
- const int StBoost = 4;
- ......

这些是玩家状态机的状态编号, 至于你找不到"被使用"是因为对于 const 常量成员, c# 编译器在编译期就把引用的这些东西直接替换为了数字, 你能看到的只有保留下来的这些常量的值和名字.  
那这样代码中就不避免的出现了奇怪的[魔数](https://www.zhihu.com/question/22018894), 比如这里的 24:
```cs title="int Player.FlingBirdUpdate()"
private int FlingBirdUpdate()
{
	base.MoveTowardsX(this.flingBird.X, 250f * Engine.DeltaTime, null);
	base.MoveTowardsY(this.flingBird.Y + 8f + base.Collider.Height, 250f * Engine.DeltaTime, null);
	return 24;
}
```
!!! info
    FlingBirdUpdate 是一个**状态机的** Update 函数, 所有该类函数的返回值表示下一帧玩家的状态应该是什么.

你肯定很疑惑这个奇怪的 24 是什么, 这里我们已经知道它是个状态机编号了, 我们只需要一下这个编号对应的状态.  
经过查询, 你会知道编号为 24 的状态是 `StFlingBird `, 即被鸟扔状态(符合这里的函数名!):

```cs
const int StFlingBird = 24;
```

在这里会简单列出一下 `Player` 的所有状态便于查询:

```cs
const int StNormal = 0; // 正常
const int StClimb = 1; // 攀爬
const int StDash = 2; // 冲刺
const int StSwim = 3; // 水中
const int StBoost = 4; // 绿泡泡中
const int StRedDash = 5; // 红泡泡中
const int StHitSquash = 6; // 被固体挤压?
const int StLaunch = 7; // 被 弹球, 鱼 弹开
const int StPickup = 8; // 捡起抓取物
const int StDreamDash = 9; // 穿果冻
const int StSummitLaunch = 10; // 7a, 7b 上升过场
const int StDummy = 11; // 剧情过场状态
const int StIntroWalk = 12; // Walk 类型的 Intro (Intro 即玩家进入关卡的表现方式)
const int StIntroJump = 13; // Jump 类型的 Intro (1a)
const int StIntroRespawn = 14; // Respawn 类型的 Intro (重生)
const int StIntroWakeUp = 15; // WakeUp 类型的 Intro (2a awake)
const int StBirdDashTutorial = 16; // 序章教冲刺时冲刺结束后进入的状态
const int StFrozen = 17; // 未知
const int StReflectionFall = 18; // 6a-2 掉落剧情段
const int StStarFly = 19; // 羽毛飞行
const int StTempleFall = 20; // 5a 镜子后的掉落段
const int StCassetteFly = 21; // 捡到磁带后的泡泡包裹段
const int StAttract = 22; // 6a badeline boss 靠近时的吸引段
const int StIntroMoonJump = 23; // 9a 开场上升剧情段
const int StFlingBird = 24; // 9a 鸟扔状态
const int StIntroThinkForABit = 25; // 9a Intro
```