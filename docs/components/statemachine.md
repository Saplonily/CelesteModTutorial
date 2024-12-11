# StateMachine

这是 Monocle 中的一个 Component 类, 是一个**状态机**的实现, 具体的用法我会在 **常见 Celeste, Monocle 类**~在写了.jpg~ 节说, 这里仅是方便你阅读一下相关的代码:

## `St*` 类字段  
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
const int StHitSquash = 6; // 红泡泡撞墙或撞地
const int StLaunch = 7; // 被 弹球, 鱼 弹开
const int StPickup = 8; // 捡起抓取物
const int StDreamDash = 9; // 穿果冻
const int StSummitLaunch = 10; // badeline最后一次上抛
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