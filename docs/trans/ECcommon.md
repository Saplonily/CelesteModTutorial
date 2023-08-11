# 更多 EC

那么经过前面的阅读, 相信你已经了解到了一些很很很基本的知识, 那么从这一章开始就是一些**零碎且杂乱**的东西了.  
顺便所以, 我还是很建议你去多阅读一下原版的代码以及一些常见**简单**Helper的源码, 毕竟我自己都不知道我需要在这里说些什么(

!!! note "\_(:з」∠)\_"
    \_(:з」∠)\_ 摆烂了这节可能会很不明所以(

## 生命周期

在前面我们已经了解到了 `Update` 函数和 `Render` 函数, `Update` 与 `Render` 每帧都会被调用,
对于逻辑的更新我们应在 `Update` 中做, 而有关绘制的任务我们应该在 `Render` 中做, 这是因为即使你在 `Update` 中进行了绘制的调用,
在 `Render` 开始之前也会被蔚蓝清空. 类似地, 游戏中的暂停的实现原理是停止每帧 `Update` 的调用而保留 `Render` 的调用,
那么自然如果你在 `Render` 里进行逻辑更新你会破坏掉游戏原有的暂停.  

ok那么我们 balabala 说了一大堆, 接下来介绍几个会被蔚蓝调用的函数, 这些函数也叫做`生命周期`函数.

### 对于 Entity

- `Update`
- `Render`
- `DebugRender`: 该函数会在蔚蓝调试控制台被打开时被每帧被调用作为 debug 渲染, 即 everest 默认 \~ 键打开的那个, 它的默认行为是绘制该实体的碰撞箱,
在这里你可以做一些调试用的标识的绘制, 就比如说你的实体的作用范围什么的.
- `Added`: 当该实体被以 `Scene.Add` 函数调用加入到场景上时调用, 在这里你可以读取场景的一些状态或者 flag 之类的并更改它的行为.
- `Awake`: 该函数与 `Added` 行为相同, 但是当一帧之内有多个实体被加入场景时它们的 `Awake` 会在这些实体都被加入后再批量调用, 而 `Added` 则是加入一个就调用一个.
一个很好的在官图中运用的例子是浮动块的连接, 这是在场景开始时做的, 为了防止遗漏某些浮动块间的连接就需要在实体都被加入后再调用.
- `Removed`: 当该实体被以 `Scene.Remove` 函数调用移除场景时调用, 你可以在这里取消一些实体对场景的一些作用, 比如说背景的变化.
- `SceneBegin`: 当场景被调用 `Scene.Begin` 的同时调用
- `SceneEnd`: 当场景被调用 `Scene.End` 的同时调用

### 对于 Component

对于 Component 来说大部分函数与 Entity 的类似, 只不过名字前加个了 Entity.
比如实体的 `Awake` 对应 Component 的 `EntityAwake`, 通常这些函数被调用的地方是对应的 Entity 的生命周期函数的默认实现,
所以除非有意而为之记得在开头调用基类的生命周期实现:
```cs title="MyInterestingEntity.cs"
public override void Awake()
{
    // ensure `Awake`s of its components has been called
    base.Awake();
    // do other thing...
}
```

### 对于 Scene

嗯... 对应 Scene 的一些生命周期函数我个人也不是很了解毕竟我们大部分的时间都在 gameplay 的场景上, 所以这节就暂时咕了(。_。)

### 常见的方法与属性

- `Scene.Add`: 将一个实体加入到场景中
- `Entity.Add`: 将一个 Component 挂载到实体上
- `Scene.Remove`: 将一个实体移出场景
- `Entity.Remove`: 将一个 Component 移出实体
- `Entity.RemoveSelf`: 将 Entity 自身移出自身所在场景
- `Component.RemoveSelf`: 将 Component 自身移出所在实体
- `Scene.Entities`: 获取当前场景上的实体列表
- `Entity.Components`: 获取当前实体的 Component 列表

#### Entity

`Entity` 本身有四个公开的字段:

- `Active`, 该 `bool` 字段表示该 `Entity` 是否 "存活", 否则为 "失活", "失活" 的 `Entity` 将不会被调用 `Update` 方法直到 `Active` 为 `true`
- `Collidable`, 该 `bool` 字段表示该 `Entity` 是否 "可碰撞", 不可碰撞的实体与任何实体进行碰撞检测时都会返回 `false`, 所以你可以使用该自动禁用它的碰撞箱
- `Visible`, 该 `bool` 字段表示该 `Entity` 是否 "可见", 不可见的实体不会被调用 `Render` 方法, 注意即使不可见它的碰撞箱依然存在.
- `Position`, 该 `Vector2` 字段表示该 `Entity` 的位置, 注意这个位置相对的坐标系是不同的, 对于 HUD 实体来说它的坐标系是一个 1922 x 1092 的原点左上角的屏幕坐标, 对于 gameplay 实体来说它是相对于世界原点的分度值为 1px 的坐标. 这个行为可以通过后面所说的 `Tag` 来配置.

## Tag

:thinking:  
除此之外呢还有一个小东西叫 `Tag`, 语义上来说它表示这个实体的一些标签属性, 你可以通过 `Entity.Tag` 属性来访问它, 它是一个 32 位整数,
它的每一位表示一个该实体的"属性", 我们通常会使用 `AddTag` 以及 `RemoveTag` 来操作它.  
要获取场景中所有拥有某一 `Tag` 的实体, 我们需要访问 `Scene` 的 `TagLists` 而不是 `Tracker`, 然后使用它的索引器(形如 `tagList[yourtag]` 的运算符)来检索,
或者你也可以使用简便的方法---直接访问 `Scene` 的索引器.  
一般的话, 我对于 `Tag` 的应用很少, 最近一次是将一个 `Entity` 标记为 ui 层, 它的代码看起来是这样的:
```cs
this.AddTag(Tags.HUD);
```
当你的实体拥有这个 Tag 后, 蔚蓝会将你的实体绘制在 ui 层, 比较常见的例子就是左上角的计时器, 它在构造器内就给自己打上了 `Tags.HUD` 的标签.  
也如上面所说的, 一些蔚蓝常见的所有 Tag 你都可以在 `Celeste.Tags` 类内找到.

以下是一些可能地常见的 Tag:

- `PauseUpdate`: 是否在暂停期间依然被调用 `Update`, 通常用于 ui 层的实体上
- `FrozenUpdate`: 是否在 `Frozen` 状态下依然被调用 `Update` (比如草莓籽动画过程, 1a蓝心解密成功过程, 注意此状态与冻结帧无关)
- `TransitionUpdate`: 是否在关卡切板时依然被调用 `Update`, 通常用于在切板时更新一些视觉上的东西(比如电网的 "放电" 动画不会在切板时静止)
- `HUD`: 即是否是 ui 层, 此项就会更改 `Entity` 的 `Position` 的相对坐标系
- `Global`: 该 Entity 是否是全局的, 一个非全局实体在关卡重试后会消失, 全局 Tag 可以避免这件事, 通常全局 Tag 最常见的用法是和 HUD 结合在一起,
这样你就拥有了一个在游戏内持久的 ui 部件了.