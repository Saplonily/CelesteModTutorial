## LuaCutscene 函数

在前面的小节中我们已经提到过 LuaCutscene 提供了[大量的函数](https://maddie480.ovh/lua-cutscenes-documentation/modules/helper_functions.html),
那么这里我们将介绍其中常用的一部分(之前已介绍过的将不再提及).

### wait

`wait(duration)`  

协程函数, 暂停函数执行几秒

- duration: 要暂停的时间(秒)

### walkTo

`walkTo(x, walkBackwards=false, speedMultiplier=1.0, keepWalkingIntoWalls=false)`  

协程函数, 让玩家行走到坐标 x

- x: 目标 x 绝对坐标, 单位 px
- walkBackwards: 是否播放为倒走动画
- speedMultiplier: 速度倍率
- keepWalkingIntoWalls: 撞墙时是否保持状态直到墙被移除

如果在行走过程中碰到墙那么该函数会立即结束执行, 除非 `keepWalkingIntoWalls` 被设置为 `true`,
如果不幸地碰到了不可能会被移除的墙, 例如前景砖, 那么剧情就会永久卡住.

### walk

`walkTo(x, walkBackwards=false, speedMultiplier=1.0, keepWalkingIntoWalls=false)`  

与 [`walkTo`](#walkto) 相同, 但 x 为相对值, 例如 `100` 会使得玩家向右行走 100 px

### runTo

`runTo(x, fastAnimation=false)`

协程函数, 让玩家跑到坐标 x

- x: 目标 x 绝对坐标, 单位 px
- fastAnimation: 是否使用快跑的动画

与 [`walkTo`](#walkto) 类似, 但是动画变为跑步. 注意此函数没有同等的 `keepWalkingIntoWalls` 参数, 其等效于为 `true` 的情况,
也就是撞墙后不会结束该函数的执行.

### run

`run(x, fastAnimation=false)`

与 [`runTo`](#runto) 相同, 但 x 为相对值.

### postcard

`postcard(dialog, sfxIn, sfxOut=nil)`

协程函数, 向玩家显示明信片

- dialog: 明信片所使用的 dialog id, 与 `say` 的是同一种 id
- sfxIn: 展示明信片时播放的音频 event id.
- sfxOut: 明信片移开时播放的音频 event id.

对于音频相关的内容, 例如获取 event id, 可参考电箱制图教程中的:

- [av986769059 - 自定义音乐(基础篇)](https://www.bilibili.com/video/av986769059)
- [av604397615 - 自定义音乐(进阶篇)](https://www.bilibili.com/video/av60439761)
- [av517096099 - 自定义音乐(拓展篇)](https://www.bilibili.com/video/av517096099)

在明信片出现时尝试暂停并跳过剧情会使关卡处于一种很奇怪的状态, 你可以选择禁用关卡的暂停来避免它.

> 截止 `0.2.11`, `postcard` 函数存在编码问题, 个人已开 [pr](https://github.com/Cruor/LuaCutscenes/pull/7) 修复

### choice

`choice(...)`

协程函数, 向玩家展示几个对话选项(类似 6a 开头那种), 返回玩家选择的对话序号(注意从 1 开始).

- ...: dialog id

这是一个可变参数的函数, 例如以下使用:

```lua
local chosen = choice("CHOICE_1", "CHOICE_2", "CHOICE_3");
say("CHOICE_SAY_" .. tostring(chosen));
```

会向玩家展示三个选项, 并且在玩家选择完后展示对应序号对应的对话:

- `CHOICE_1` -> `CHOICE_SAY_1`
- `CHOICE_2` -> `CHOICE_SAY_2`
- `CHOICE_3` -> `CHOICE_SAY_3`

### die

`die(direction={0, 0}, evenIfInvincible=false, registerDeathInStats=true)`

非协程函数, 杀死玩家

- direction: 死亡方向, 例如 `{1, 0}` 表示水平向右, `{-1, -1}` 表示左上方
- evenIfInvincible: 是否在玩家是无敌时也杀死
- registerDeathInStats: 是否记录本次死亡, 否则本次死亡不会增加存档死亡数

就如此函数所做的, 直接杀死玩家, 不过此函数调用后依然会执行后面的代码, 虽然同时后面的代码会被玩家死亡后的自动重开直接打断.

### jump

`jump(duration=2.0)`

**非**协程函数, 使玩家跳跃

- duration: 跳跃时长, 等价于你按跳键的时长

有趣的是, 此函数即使玩家在空中也会起效, 不过此函数导致的跳不会触发 super 与 hyper 等机制.

### waitUntilOnGround

`waitUntilOnGround()`

协程函数, 等待玩家触碰到地板

### changeRoom

`changeRoom(name)`
`changeRoom(name, spawnX, spawnY)`

非协程函数 ,更改玩家所在面

- name: 目标面名称
- spawnX: 新重生点 x 坐标
- spawnY: 新重生点 y 坐标

如果不传入新重生点坐标则默认为房间左下角. 不过经个人测试这个重生点的设置会马上就被新面的进入而覆盖,
不过有趣的是, 此函数允许传入一个 filler 面, 此时重生点就不会被覆盖了.

### teleportTo

`teleportTo(x, y)`

非协程函数, 传送玩家到目标位置

- x: 目标 x 坐标
- y: 目标 y 坐标
 
此外这个函数还有另外两个重载, 不过我个人还没弄懂它的用法, 故这里就不写了.

### teleport

与 [`teleportTo`](#teleportto) 相同, 但是坐标是相对坐标

### instantTeleportTo

`instantTeleportTo(x, y)`

非协程函数, 立即传送玩家到目标位置

- x: 目标 x 坐标
- y: 目标 y 坐标

此函数与 [`teleportTo`](#teleportto) 类似, 但是它会在传送的同时立即调整视野, 也就是摄像机的位置.  
此外这个函数也有另外一个有关面的重载(`(x, y, room)`), 但是传入其他面后玩家会进入一种奇怪的剧情状态.

### instantTeleport

与 [`instantTeleportTo`](#instantteleportto) 相同, 但是坐标是相对坐标

### completeArea

`completeArea(spotlightWipe=false, skipScreenWipe=false, skipCompleteScreen=false)`

非协程函数, 结束当前章节, 此函数调用后会重新允许玩家移动.

- `spotlightWipe`: `true` 时为聚光灯型切换到黑屏, `false` 为渐变型.
- `skipScreenWipe`: 是否跳过切换到黑屏的过程
- `skipCompleteScreen`: 是否跳过结算屏

### giveKey

`giveKey()`

非协程函数, 给予玩家一把钥匙.

### makeUnskippable

`makeUnskippable()`

非协程函数, 使当前剧情无法跳过  

有些时候你的剧情过于复杂, 以至于你无法良好地预测直接跳过剧情应该做什么, 比如玩家到底移动到哪了,
那么使它无法跳过可能是个不错的选择.

### disableRetry / enableRetry

`enableRetry()`
`disableRetry()`

非协程函数, 禁用 / 启用 重试功能.  

注意此函数的效果在剧情结束后不会恢复, 建议手动在 `onEnd()` 处重新启用.

### disablePause / enablePause

`helpers.disablePause()`
`helpers.enablePause()`

非协程函数, 禁用 / 启用 暂停功能.  

注意此函数的效果在剧情结束后不会恢复, 建议手动在 `onEnd()` 处重新启用.

### endCutscene

`endCutscene()`

非协程函数, 结束当前剧情.  

注意该函数调用后后面的代码**依然会执行**, 直到遇到一个协程函数, 或者函数被返回或到达末尾.