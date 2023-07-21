# 更多 EC

那么经过前面的阅读, 相信你已经了解到了一些很很很基本的知识, 那么从这一章开始就是一些**零碎且杂乱**的东西了.  
顺便所以, 我还是很建议你去多阅读一下原版的代码以及一些常见**简单**Helper的源码, 毕竟我自己都不知道我需要在这里说些什么_(:з」∠)_

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
所以除非有意的记得在开头调用基类的生命周期实现:
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

## Tag

// TODO