# 例子

在这一小节中会更多地介绍一些预定义函数, 以及一些工具函数等等,
在后面的节中还会包含一些 helper 在 C# 侧协助实现的函数.

## 一些介绍

就如之前所说的, 移动的禁止状态并不会在剧情结束时自动解除, 在分支复杂容易在末尾忘记调用 `enableMovement` 的情况下, 通常建议在 `onEnd` 函数中重新允许移动:

```lua
function onEnd()
    enableMovement()
end
```

对于部分要求绝对坐标的函数, 你可以通过按下键盘上的 `~` 键来打开调试面板, 在界面左上角会有一栏类似如下的信息:

```
Area: 04 @ 12 (SID: Celeste/Saplonily/Test)
Cursor @
  screen: 792, 407
  world:       -618, 213
  level:       1142, 397
  level, /8:   142, 49
  level, snap: 1136, 392
```

其中 `Area: 04 @ 12` 中的 `04` 为当前房间名, `12` 为当前章节 ID, 通常对于 B 面它还会以 `H` 结尾, C 面以 `HH` 结尾. 
`screen` 表示目前光标所在的屏幕坐标, `(0, 0)` 表示屏幕左上角. `level` 表示目前光标所在的世界坐标, 也就是 `walkTo` 等函数要求我们传入的绝对坐标.
`level, /8` 表示光标所在的世界坐标除以 8 取整的结果, 这通常用于定位以 8px 为单位的 tile. `level, snap` 的值为 `level, /8` 的值乘以 8,
在数值上表现为光标所在世界坐标与 8x8 网格进行对齐的结果.  

在装了 `CelesteTAS` mod 的情况下, 你还可以左击地图上的实体来获取更多信息:

```
Area: 04 @ 12 (SID: Celeste/Saplonily/Test)
Cursor @
  screen: 792, 407
  entity type: Celeste.Glider
  entity name: glider
  entity id  : 04:14
  mod name   : Celeste
  world:       -618, 213
  level:       1142, 397
  level, /8:   142, 49
  level, snap: 1136, 392
```

其中 `entity type` 为左击到的实体的实体类名, 也即代码类名. `entity name` 为实体的名称, 也是在地图文件中实际保存的名字, 通常在与代码类名相似的使用场景中会用到.
`entity id` 为实体的 ID, 通常用于某些需要传入实体 ID 参数的 helper 实体. `mod name` 为该实体所属 mod 名, 对于原版实体为 `Celeste`.

以防你还不知道, 游戏的坐标系与常规的数学坐标系不同, 其 y 坐标经过了竖直翻转:

![game-coord](../../coding_challenges/images/simple_entity/game_coord.png) 

## 片段

### 播放玩家动画

```lua
function playSprite(sprite, duration)
    player.Sprite:Play(sprite, false, false)
    if duration then
        wait(duration)
    end
end
```

上述代码封装了一个函数, 使得你可以向玩家播放一个动画并等待几秒, 例如让玩家播放 `swimIdle`, 也就是在水中时播放的动画:

```lua
player.DummyAutoAnimate = false
playSprite("swimIdle", 1)
player.DummyAutoAnimate = true
```

在玩家被禁止移动后游戏依然会处理玩家的动画, 所以我们的 `swimIdle` 动画会立刻被替换为默认动画,
这可以通过设置 `DummyAutoAnimate` 为 `false` 来禁止这一行为.

此外还可以有反向播放动画:

```lua
function playSpriteReversed(sprite, duration, from)
    player.Sprite:Reverse(sprite, false)
    -- from 还要再 +1, 避免游戏跳过最后一帧而从倒数第二帧开始
    player.Sprite:SetAnimationFrame(from + 1)
    if duration then
        wait(duration)
    end
end
```

蔚蓝的引擎 `Monocle` 的 `Sprite` 有个反向播放的方法, 但是它只会修改方向为反方向,
不会跳到最后一帧开始, 所以这里你可能需要手动查询你想要反向播放的动画的最后一帧的位置.  

例如让玩家抬头, 结束后等待 0.5 秒然后再低头然后结束剧情:

```lua
function onBegin()
    disableMovement()
    local level = player.Scene;
    player.DummyAutoAnimate = false
    playSprite("lookUp", 0.5)
    wait(0.5)
    -- <Anim id="lookUp" path="lookUp" delay="0.1" frames="2-7"/>, 最后一帧是 7
    playSpriteReversed("lookUp", 0.5, 7)
    player.DummyAutoAnimate = true
end
```

此外你还会发现此时依然有重力, 但是你依然想让玩家在空中游动(~~陆游~~), 你可以这样禁用重力:

```lua
function onBegin()
    disableMovement()
    local level = player.Scene;
    player.DummyAutoAnimate = false
    player.DummyGravity = false
    playSprite("swimIdle", 0.5)
    player.DummyGravity = true
    player.DummyAutoAnimate = true
end
```

上述例子的完整 lua 文件:

```lua title="testCutscene.lua"
function playSprite(sprite, duration)
    player.Sprite:Play(sprite, false, false)
    if duration then
        wait(duration)
    end
end

function playSpriteReversed(sprite, duration, from)
    player.Sprite:Reverse(sprite, false)
    player.Sprite:SetAnimationFrame(from + 1)
    if duration then
        wait(duration)
    end
end

function onBegin()
    disableMovement()
    local level = player.Scene;
    waitUntilOnGround()
    wait(1)
    player.DummyAutoAnimate = false
    player.DummyGravity = false
    playSprite("swimIdle", 0.5)
    player.DummyGravity = true
    player.DummyAutoAnimate = true
end

function onEnd()
    enableMovement()
end
```