# Flag, Tag, Tracker

## Flag

### 即一个`bool`状态, 我们可以通过`string`来区分不同的`flag`, 用`Dictionary<string, bool>`来存储`flag`的状态(这样可能好理解点), 以让我们在某个时机做某件事(详情见`Session`).

### 然后Everest已经为我们提供了一个简单的`FlagTrigger`, 让`player`碰到`trigger`的时候触发某个`flag`, 接着我们就可以在`Session`里读取, 这样对于非常简单的需求就不需要自己写个`trigger`了, 例如"`player`碰到`FlagTrigger`就跳一下"这个需求: 我们可以不断读取`flag`, 如果拿到`true`就删除`flag`并执行跳的动作.

## Tag(BitTag)

### 简单理解

* #### Global: 永久保留(死亡不销毁)
* #### Persistent: 切板保留(死亡销毁)
* #### HUD: 画UI的,切板后销毁
* #### TransitionUpdate: 切板过程继续更新(或者说时间流速正常), 切板后销毁
* #### FrozenUpdate: 在Frozen状态下还能更新的实体
* #### PauseUpdate: 在Pause状态下还能更新的实体

###### 注意有些标签只是暂时使用, 所以我一般会用"xxx的时候"来描述, 列出来的实体也仅仅是跟这个标签有关, 由于实体很多很杂会有疏漏, 如果你觉得哪里不对或者感兴趣, 直接去看代码就好了

### Global(该 Entity 是否是全局的, 一个非全局实体在关卡重试后会消失, 全局 Tag 可以避免这件事, 通常全局 Tag 最常见的用法是和 HUD 结合在一起, 这样你就拥有了一个在游戏内持久的 ui 部件了.)

###### 由于本质上只是在该卸载的时候取消卸载, 所以如果再次加载场景, 对象依旧会被new一个

###### 所以要么是在new的时候逻辑上判断(参考`CassetteBlockManager`)以消除错误(有点单例的感觉)

###### 要么是用代码在Scene上手动添加一个类似Manager的东西, 由于其他场景原先没有摆放你这个对象, 自然也不会被加载多次

#### 例如

* 背景砖`BackgroundTiles`
* 节奏块管理器`CassetteBlockManager`(你会发现节奏面重生后轴有点怪, 因为manager不会reset)
* 4a玩家被镜子吸入的cutscene`CS04_MirrorPortal`(因为背景是个黑场过渡, 玩家又传送了(或者说在另一个room重生了), 所以要用global标签才能保持fadeout)
* 7a结尾的cutscene(同上)`CS07_Credits`
* 被`DetachStrawberryTrigger`(如果Global属性开了的话)作用的`Follower`
* 为煤球绘制描边的`DustEdges`
* 6a下落面的速度线`FallEffects`
* 吃心弹出poem后底下的黑色panel`FormationBackdrop`
* Pause界面下方的草莓记录 `GameplayStats`
* 作用于`GlassBlock`的`GlassBlockBg`(官图好像`没出现过)
* Grab模式为Toggle的时候的辅助显示对象`GrabbyIcon`
* 会在第8章cold模式下在core前景砖上附上冰霜的`IceTileOverlay`
* 绘制电网里的闪电`LightningRenderer`
* 绘制镜子上的画面`MirrorSurfaces`
* 3a和Theo对话完后Theo爬进管道后可以在隔壁看见`NPC03_Theo_Escaping`
* `OldSiteChaseMusicHandler`
* 冲刺辅助指示器`PlayerDashAssist`
* 保存并退出时右下角的Icon`SaveLoadIcon`
* 管理Barrier的外部渲染(里面粒子是Barrier自己的)`SeekerBarrierRenderer`
* 新浪在的时候RGB分离效果`SeekerEffectsController`
* 前景砖`SolidTiles`
* 计时器`SpeedrunTimerDisplay`
* `TempleEndingMusicHandler`
* 草莓计数`TotalStrawberriesDisplay`
* 残影`TrailManager`和`TrailManager.Snapshot`

### Persistent(表示需要持久化在场, 切板不卸载的实体, 死亡会卸载, 一般在`Coroutine`里用来暂时保存下状态)

#### 例如

* `birdNPC`最后一次飞走的时候
* `Booster`把player吐出切板的时候
* 撞碎`DashBlock`掉落的`Debris`
* 所有被`DetachStrawberryTrigger`(带金草莓的月梅面会用到)解绑的`Follower`
* 所有被玩家拾起的`Follower`(`Strawberry`, `Key`等)
* 所有被玩家拾起的`Holdable`(`TheoCrystal`, `Glider(Jellyfish)`等)
* 7a 7b 显示500m 1000m的实体`HeightDisplay`
* `LightningBreakerBox`电箱被撞裂的时候
* `MoonGlitchBackgroundTrigger`扫描线Glitch触发的时候(记得把CelesteTAS碰撞箱和光敏模式关了, 不然看不到(乐))
* Player自身(显而易见)
* 第八章的`SandwichLava`熔岩霜冻夹心
* `SoundEmitter`(感觉就比直接用Audio多了个切板销毁)
* `StrawberryPoints`草莓得分点数
* 第七章撞碎`SummitGem`时的闪光
* `TalkComponentUI`(玩家靠近时弹出的prompt, 例如望远镜`Lookout`上的那个) (但它又是由`TalkComponent`控制的, 所以好像它的persistent没用?)

### HUD(即是否是 UI 层, 此项就会改变 `Entity.Render` 的绘制逻辑(**注意`Position`不变**), 使绘制坐标基于屏幕坐标(`1920 x 1080`)而不是世界坐标绘制, 并调整绘制顺序使其置于顶层)

###### 本质上选择HUD Tag后游戏会在绘制时通过矩阵把坐标从屏幕空间转化到世界空间(参考`HiresRenderer`, 线性代数最有用的一集~)

#### 例如

* 鸟的教程框`BirdTutorialGui`
* 6a的深呼吸~`BreathingMinigame`
* 吃到磁带b面解锁画面`UnlockedBSide UnlockedRemixDisplay`
* 2a Awake最上面的诗`CS02_Journal.PoemPage`
* 3a(11-a) 的倒闭通知`CS03_Memo.MemoPage`
* 6a 的和好抱抱`CS06_BossEnd`
* 6a 篝火前和的Theo对话选项`CS06_Campfire.Option`
* 7a通关的制作人员名单`CS07_Credits`
* 尾声里的草莓蛋糕`CS08_Ending`
* 9a尾声 `CS10_Ending`
* 收集完草莓籽的合成动画 `CSGEN_StrawberrySeeds`(但这个类本身并没有render, 所以好像没用?)
* 启动游戏时一开始出现的credits 和 logo`GameLoader.handler`
* Pause界面下方的草莓记录 `GameplayStats`
* 7a 7b 显示500m 1000m的实体`HeightDisplay`
* `HudRenderer`(管UI显隐的)
* B面入场插磁带`BSideTitle`
* 开镜画面`Lookout.Hud`
* 纪念碑文字`MemorialText`
* 6a badeline迷你对话框`MiniTextbox`
* 各种Oui, 各种panel
* 吃心后显示的文字`Poem`
* 明信片`Postcard`
* prologue结尾`PrologueEndingText`(You can do this!)
* 自拍照`Selfie`
* 计时器`SpeedrunTimerDisplay`
* 草莓计数`TotalStrawberriesDisplay`
* `TalkComponentUI`
* 对话框`Textbox`
* 凌波微步, 快乐的舞步~`WaveDashPresentation`

### TransitionUpdate(切板过程继续更新(或者说时间流速正常), 切板后销毁)(注意: 标签可作用于要被load的或者是要被unload的对象)

#### 例如(有的实现上可能只调整了音效之类的)

* 第七章管上升切板的`AscendManager`(好像就对应Loenn里的`SummitBackgroundManager`)
* 6a从主世界cutscene切到6a第二章所用的黑场过渡`BackgroundFadeIn`
* 6a瀑布`BigWaterfall`
* 9a的`BirdPath`
* 篝火`Bonfire`
* 红(绿)泡泡`Booster`
* 第四章各种旗帜`CliffsideWindFlag`
* 3a收拾杂物`ClutterAbsorbEffect`
* 3a收拾完杂物把门堵住的那个果冻`ClutterDoor`
* 圆刺`CrystalStaticSpinner`
* `DustEdges`
* 火球`FireBall`
* 岩浆墙`FireBarrier`
* `GameplayStats`
* `GrabbyIcon`
* 尾声右侧鸟巢`InvisibleBarrier`
* 比如6a蓝心房左边的左边那个房间里的一缕缕光`LightBeam`
* 改房间灯光的透明度`LightFadeTrigger`
* `LightningRenderer`
* 锁块被解锁后`LockBlock`
* `MiniTextbox`
* 9a小蝌蚪`MoonCreature`
* 移动快撞停后掉落的碎片`MoveBlock.Debris`
* `NPC03_Theo_Vents`
* 5a穿过镜子从上面落下来后的badeline`NPC05_Badeline`
* `OldSiteChaseMusicHandler`
* pico-8游戏机`PicoConsole`
* 6a触手`ReflectionTentacles`
* `SandwichLava`
* `SeekerBarrierRenderer`
* `SoundEmitter`
* `SpeedrunTimerDisplay`
* 草莓收集的时候`Strawberry`
* `StrawberryPoints`
* 5a尾声管音乐的`TempleEndingMusicHandler`
* Theo`TheoCrystal`
* 初见Theo水晶的底座`TheoCrystalPedestal`
* `TotalStrawberriesDisplay`
* 传送带`WallBooster`
* 水`Water`
* 瀑布`WaterFall`
* 9a教凌波的那个堡`WaveDashTutorialMachine`
* 第4章管风力和风向的`WindController`

### FrozenUpdate(Frozen只是Level里的一个冻结状态(或者说一个bool变量, 而不是真的让游戏freeze的那个冻结帧))

#### 例如

* 吃水晶溅射的白球`AbsorbOrb`
* 磁带`Cassette`
* 草莓籽合成动画`CSGEN_StrawberrySeeds`
* `FormationBackdrop`
* 解锁1a水晶之心过程`ForsakenCitySatellite`
* 水晶之心`HeartGem`
* 水晶之心上的文字`Poem`
* 保存并退出时右下角的Icon`SaveLoadIcon`
* `StrawberryPoints`
* `StrawberrySeed`
* `Textbox`
* 残影`TrailManager.Snapshot`

### PauseUpdate(在Pause状态下还能更新的实体)

#### 例如

* `Cassette.UnlockedBSide`(由于它是由Cassette控制的, 所以相当于自带一个FrozenUpdate, 但是它在被调用前Pause已经被锁住了, 所以这个状态貌似白加了🤔)
* 尾声`CS08_Ending`
* `GameplayStats`
* `GrabbyIcon`
* `LanguageSelectUI`
* 1a尾, 2a头的纪念碑`Memorial`(用到标签的地方主要是2a纪念碑上的乱码)
* `MemorialText`(因为paused的时候不能显示)
* `OuiChapterSelectIcon`
* `OuiFileSelectSlot`
* `PicoConsole`
* `SaveLoadIcon`
* `SpeedrunTimerDisplay`
* `Textbox`
* 应该是开始菜单`TextMenu`
* `TotalStrawberriesDisplay`
* `UnlockedPico8Message`
* `ViewportAdjustmentUI`


## Tracker
### `Tracker`由`Scene`管理, 在我们使用`Scene.Add(new Entity())`的时候, 会通过`EntityList`向`Tracker`加入`Entity`(当然还有`Component`, 但在后面只提及`Entity`).
### 所有需要被`Tracked`(或者说被记录) 的`Entity` 需要加上`[Tracked]`特性.
### 你还可以通过`[TrackedAs(typeof(xxx))]`特性让一个`A`类型被同时当作`B`类型, 这样就可以使用`Scene.Tracker.GetEntity<B>()`来同时拿到`A`和`B`了.
