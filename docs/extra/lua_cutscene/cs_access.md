# C# 交互

从这一小节开始就需要使用一小些 C# 知识了, 不过不需要太多, 你只需要能看懂 C# 侧的函数, 字段, 属性等的定义就行.  

## 引入 C# 类

要引用一个 C# 类, 首先需要在文件顶部使用 require 函数:

```lua
local celeste = require("#Celeste.Celeste")

function onBegin()
    -- ...
end
```

参数需要以 "#<完整类名>" 格式传入, 比如上述代码就会得到一个 C# 类 `Celeste`, 这样我们可以来调用一下产生冻结帧的静态方法:

```lua
local celeste = require("#Celeste.Celeste")

function onBegin()
    celeste.Freeze(0.5)
end
```

就像你在 C# 中所做的一样, 不过这里使用上面获取到的 `celeste` 作为你在 C# 中书写的类名. 上述代码应该会导致你进入 trigger 时冻结 0.5 秒.

## 方法调用, 字段, 属性访问

通常, 如果你需要访问 C# 代码对玩家做一些有趣的变动, 获取玩家类的实例以及在实例上调用方法是必不可少的.  

在 LuaCutscene 中我们可以使用预定义和赋值的 `player` 全局变量, 也就是在任何方法内都能使用的变量, 例如, 在进入 trigger 时将玩家的冲刺设为 2:

```lua
function onBegin()
    player.Dashes = 2
end
```

上述代码访问了 player 全局变量, 并且设置其 `Dashes` 字段为 2, 也就是设置冲刺数为2, 不过这样会导致在空中也恢复为 2, 所以我们加入在是否在安全地面(草莓能结算的那种)上的检测:

```lua
function onBegin()
    if player.OnSafeGround then
        player.Dashes = 2
    end
end
```

上述代码中 `OnSafeGround` 就是一个属性. 不过上面这段代码有一些问题, 当你从上往下掉入 trigger 时, 只有进入的那一帧才会检测并恢复冲刺,
这有时候就不是我们想要的结果, 所以我们使用一个新的特殊函数 `onStay`:

```lua
function onStay()
    if player.OnSafeGround then
        player.Dashes = 2
    end
end
```

这会让这段代码在玩家接触到 trigger 的每一帧都执行代码, 符合我们目前的需求. 除此之外还有另外两个: `onEnter` 和 `onLeave`,
它们都不是协程函数, 前者在玩家进入 trigger 时触发(这与 `onBegin` 不同, 比如在剧情进行时你依然可以控制进出 trigger),
后者在玩家离开 trigger 时执行.  

当然我们还可以调用一些方法, 比如剧情开始时强制丢弃抓取物:

```lua
function onBegin()
    player:Throw()
end
```

注意在调用成员方法时我们需要使用 **:** 符号, 这是到目前为止的一个特例.  

## 私有访问

对于私有成员的访问, 在 Everest Core (截止 4446) 上似乎是有一些问题导致完全不能访问,
经过询问似乎是 Core 的一些缓存问题, 在 Stable 上不会出现, 故这里暂时跳过,
相关私有成员访问可在 C# 侧操作作为替代.

## 协程

lua 与 c# 两侧都有协程的概念, 不过不能直接使用, 需要一定的转换, 例如使用 `Level.ZoomTo` 函数, 它会返回一个将摄像机缩放至某一点的协程:

```lua
function onBegin()
    disableMovement()
    local level = player.Scene
    local c = level:ZoomTo(vector2(160, 90), 1.5, 2.0)
    coroutine.yield(c)
end
```

上述代码调用了 `level` 的 `ZoomTo` 函数, 并将返回值储存起来, 然后使用 `coroutine.yield` 将其转换为 lua 协程并等待.
游戏中的效果则为相机在 2s 内向屏幕中心放大 1.5 倍. 顺便这个函数还有个配套的缩放回来的版本:

```lua
function onBegin()
    disableMovement()
    local level = player.Scene;
    coroutine.yield(level:ZoomTo(vector2(160, 90), 1.5, 2.0))
    coroutine.yield(level:ZoomBack(2.0))
end
```

## 最后

相信如果你没有太多 C# 知识的话, 这一小节你肯定是很困惑不知道发生了什么的,
不过没关系, 你依然可以直接使用后续给出的代码段和现成的函数来做你想做的事.