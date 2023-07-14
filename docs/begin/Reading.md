# 阅读代码2

嗯...根据一些很少的反馈, 似乎阅读由反编译器生成的代码时会有一些困难, 那, 这一节会简单说一些反编译器生成的代码与通常的 c# 代码不一样的地方.

## .ctor

你可能会在反编译器中看到这种奇怪的语法:
```cs title="Celeste.FinalBoss (6a 拥抱的 Badeline)"
public void orig_ctor(EntityData e, Vector2 offset)
{
    this..ctor(e.Position + offset, e.NodesOffset(offset), e.Int("patternIndex", 0), e.Float("cameraPastY", 120f), e.Bool("dialog", false), e.Bool("startHit", false), e.Bool("cameraLockY", true));
}
```

嗯...好的, `orig_ctor` 这个名字有点怪, 但是能看, 但是接下来的 `this..ctor` 是什么?! 它甚至是个非法语法!  
其实这并不罕见, 因为 everest 对蔚蓝程序的修改并不是只停留在表面, 而更是深入到了 **IL 代码层**, IL 代码我们会在之后讲述, 在这里你只需要知道它是一种**中间语言**.  
你的 c# 代码会被编译为 IL 由**运行时**来执行, 同样地, 其他的 `.NET系` 语言比如说 `VB.NET` 和 `F#` 也会被编译为 IL 由运行时执行.  
那么既然这里的 IL 是由 c# 编译而来的, 那么这样的 IL 多多少少会有一种 "c# 味", 反编译器就是靠着这种 "c# 味" 来逆推出可能的源码. 但是 everest 直接在 IL 代码层进行了修改,
所以这种 "c# 味" 会被掩盖导致反编译器生成奇奇怪怪的代码.  

好吧上面这一大段可能很难懂, 不过没关系, 我们不如直接告诉介绍上面的这种情况怎么处理:

### .ctor / .cctor

`.ctor` 是一个特殊昵称, 它表示类的构造函数, 比如 `Player.ctor(Vector2 position, PlayerSpriteMode spriteMode)` 就表示 `Player` 仅有的那个构造函数.  
那么, 在我们之后提到的 `ctor` `.ctor` 意思都为 "构造函数".  

`.cctor` 也是一个特殊昵称, 它表示该类的静态构造函数, 在之后我们提到的 `cctor` 与 `.cctor` 都表意为"静态构造函数".

!!! info
    在前面的钩子节我们没有探讨构造函数如何钩取, 那么这里你大概会明白, 钩取名字为 `ctor` 的方法即为钩取构造函数.

### orig_*

一些方法可能以 `orig_` 开头, 这表明 everest 对原方法进行了修改, 或者更为简单一点, 进行了"钩取". 在这里, 比如说 `Player.Update` 方法就被 everest 进行了"钩取",
所谓的钩子就是 `Player.Update`, 而对应我们的钩子的 `orig` 委托在这里就体现为 `orig_Update` 方法.

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

## StateMachine

这个是个 Monocle 的一个 Component, 是一个**状态机**的实现, 我本来打算在 **常见 Celeste, Monocle 类**~在写了.jpg~ 节说的, 但是提前一下使得你能更好的读懂相关代码可能更好一点.  
不过这里我们只说一个东西: `St*` 这一类字段.  
在阅读 `Player` 类的代码时, 你会看到这些奇奇怪怪名字的常量但是"没有被使用":

- const int StNormal = 0;
- const int StClimb = 1;
- const int StDash = 2;
- const int StSwim = 3;
- const int StBoost = 4;
- ......

这些是玩家状态的编号, 至于"没有被使用"是因为在 c# 编译器在编译期就把引用的这些数字内联了, 你看到的只有保留下来的元数据.  
比如这里奇怪的[魔数](https://www.zhihu.com/question/22018894) 24:
```cs title="int Player.FlingBirdUpdate()"
private int FlingBirdUpdate()
{
	base.MoveTowardsX(this.flingBird.X, 250f * Engine.DeltaTime, null);
	base.MoveTowardsY(this.flingBird.Y + 8f + base.Collider.Height, 250f * Engine.DeltaTime, null);
	return 24;
}
```
你肯定很疑惑这个奇怪的 24 是什么, 那么这里你就需要去查玩家的那一堆状态机编号了.  
经过查询, 你会得到编号为 24 的状态是 `StFlingBird `, 即鸟扔状态:
```cs
const int StFlingBird = 24;
```

!!! info
    FlingBirdUpdate 是一个**状态机的** Update 函数, 它的返回值表示下一帧玩家的状态应该是什么.

在这里简单列出一下 `Player` 的所有状态以便你查询:

```cs
// 这里一部分状态我也不知道是什么意思, 感谢可能的pr来完善本表
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
const int StSummitLaunch = 10; // 7ab 上升过场
const int StDummy = 11; // 剧情过场状态?
const int StIntroWalk = 12; // Walk 类型的 Intro (Intro 即玩家进入关卡最开始时的表现)
const int StIntroJump = 13; // Jump 类型的 Intro
const int StIntroRespawn = 14; // Respawn 类型的 Intro
const int StIntroWakeUp = 15; // WakeUp 类型的 Intro (2a awake)
const int StBirdDashTutorial = 16; // 序章教冲刺状态?
const int StFrozen = 17; // 未知
const int StReflectionFall = 18; // 6a-2 掉落剧情段
const int StStarFly = 19; // 羽毛状态
const int StTempleFall = 20; // 5a 镜子后段的掉落
const int StCassetteFly = 21; // 捡到磁带后的泡泡包裹段
const int StAttract = 22; // 6a badeline boss 靠近时的吸引段
const int StIntroMoonJump = 23; // 9a 开场上升剧情段
const int StFlingBird = 24; // 9a 鸟扔状态
const int StIntroThinkForABit = 25; // 9a 的 Intro?
```

// TODO