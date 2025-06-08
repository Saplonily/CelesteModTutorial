# Session, Settings, SaveData

<del>这部分内容在 Everest Wiki 里是在配置环境的同时说的, 我个人认为应该推后一点但是似乎现在推后的有点过头.</del>

你应该还记得我们最开始的那个继承于 `EverestModule` 的类 `MyCelesteModModule`, 到目前为止我们只使用了它的 `Load` 方法和 `Unload` 方法用于加载初始化我们的钩子.
当然, 这肯定是不止的, 那么这一节将会聚焦于 `EverestModule` 的更多的内容.

## Settings

### 基本

Settings, 顾名思义就是选项的意思. Everest 为我们封装了一个非常便利的系统, 我们要做的只是简单地加入属性,
然后装饰几个简单的特性, 就能创建出易用的菜单选项, 剩下的 ui 方面和保存读取的工作都由 Everest 负责.

在此之前, 我们先保存一下我们的 `EverestModule` 实例以方便我们访问它的实例(Everest 会确保它是单例的):

```cs
public sealed class MyCelesteModModule : EverestModule
{
    public static MyCelesteModModule Instance { get; private set; }

    public override void Load()
    {
        Instance = this;
    }

    public override void Unload()
    {
    }
}
```

然后新建一个名字最好以 mod 开头, `Settings` 结尾的 `MyCelesteModSettings` 类并继承 `EverestModuleSettings`:

```cs
public sealed class MyCelesteModSettings : EverestModuleSettings
{

}
```

然后在 module 类里这样注册这个类:

```cs hl_lines="5-6"
public sealed class MyCelesteModModule : EverestModule
{
    public static MyCelesteModModule Instance { get; private set; }

    public override Type SettingsType => typeof(MyCelesteModSettings);
    public static MyCelesteModSettings Settings => (MyCelesteModSettings)Instance._Settings;

    public override void Load()
    {
        Instance = this;
    }

    public override void Unload()
    {
    }
}
```

现在, 我们向选项中新加一条**公开**的 bool 类型的属性:

```cs
public sealed class MyCelesteModSettings : EverestModuleSettings
{
    public bool AnInterestingSwitch { get; set; }
}
```

现在直接编译你的项目, 然后你应该会看到 Everest 为你在 mod 选项中生成了这样一条有趣的设置:

![interesting-switch](images/session_settings_savedata/interesting-switch.png)

随后你就能在你 mod 的任何地方用 `MyCelesteModSettings.Settings.AnInterestingSwitch` 来访问这个开关了.

除此之外 Everest 还支持枚举, 字符串和数字, 它们分别会生成这样的选项:

```cs
public sealed class MyCelesteModSettings : EverestModuleSettings
{
    public bool AnInterestingSwitch { get; set; }

    [SettingRange(0, 100)]
    public int AnInteger { get; set; }

    public string AString { get; set; }

    public DayOfWeek DayOfWeek { get; set; }
}
```

![more-options](images/session_settings_savedata/more-options.png)

!!! info
    `AString` 那条选项是一个按钮, 按下后会进入文字输入界面, 冒号后面会跟玩家输入了的文字.  
    `DayOfWeek` 选项允许你左右选择 `DayOfWeek` 枚举中的每一项.

其中 int 那条属性需要装饰 `SettingRange` 特性并指定最大最小值, 否则 Everest 会拒绝生成它, 此外它还有个参数可以用来指定该选项是否需要 "大的范围" (`LargeRange`),
如果指定为 true, 则长按调整该值时的增长速度会慢慢增加以便快速调整至更大/小的值.  

除了 `SettingRange` 特性, 还有更多其他的特性用于指示该选项的一些性质:

- `SettingNeedsRelauch`: 指示该选项需要重启游戏生效.
- `SettingNumberInput`: 如果该选项对应的属性是个数字(int, float), 那么使用输入文字的菜单来输入数字而不是左右切换数字.
    - `allowNegatives`: 是否允许负数
    - `maxLength`: 字符串最大长度
- `SettingMaxLength`: 设置该字符串选项的最大长度. 否则默认 12 个字符.
    - `max`: 最大长度
- `SettingInGame`: 指示该选项是否出现在游戏内(图内)菜单中.
    - `inGame`: 如上.
- `SettingIgnore`: 指示是否忽略该选项被加入菜单, 注意忽略后依然会被 Everest 正常读取保存.
- `YamlIgnore`: 指示是否忽略该属性的保存.

!!! note
      `YamlIgnore` 位于命名空间 `YamlDotNet.Serialization` 内.

----

### 本地化

你可能会发现默认生成的选项名字就是属性名, 尽管我们通常能猜到它的意思以及它会干什么, 但是玩家们通常不会, 所以我们还得为其配置本地化,
其就包含了我们通常讲的 "汉化", "中文翻译".  

在这里, 我们需要的本地化键名是 `modoptions_{类名}_{属性名}`, 例如如下类:

```cs
public sealed class MyCelesteModSettings : EverestModuleSettings
{
    public bool EnableFunnyThing { get; set; }
}
```

其中那条属性对应的本地化键名则是: `modoptions_mycelestemod_enablefunnything`, 所以我们将其写在 Dialog 文件里:

<!--别问为啥是 ini 高亮-->
```ini title="ModFolder/Dialog/Simplified Chinese.txt"
modoptions_mycelestemod_enablefunnything=开启有趣的东西
```

```ini title="ModFolder/Dialog/english.txt"
modoptions_mycelestemod_enablefunnything=Enable funny thing
```

<!--TODO 写一篇介绍 dialog 的-->
!!! note
    如果你不知道 dialog 文件是什么的话, 你可以询问 mapper 们, 或者在这里你就干脆照做, 也就是新建如其标题所展示的文件然后粘贴对应内容.
    
此外, mod 选项的大标题也有个本地化键名, 相对于上面的键名只是将属性名换成了 `title`, 例如以下 dialog 文件:

```ini title="ModFolder/Dialog/Simplified Chinese.txt"
modoptions_mycelestemod_enablefunnything=开启有趣的东西
modoptions_mycelestemod_title=我的有趣 mod 的设置 (MyCelesteMod)
```

```ini title="ModFolder/Dialog/english.txt"
modoptions_mycelestemod_enablefunnything=Enable funny thing
modoptions_mycelestemod_title=funny MyCelesteMod
```

!!! note
    时刻记得填充 `english.txt`, 因为如果其他语言没找到这个键名会默认回退到 `english`, 如果再没有的话就会直接展示丑陋的键名.

![dialog](images/session_settings_savedata/dialog.png)

本地化键名并不是固定的, 你可以使用 `SettingName` 装饰到类上或者属性上来修改它, 不过我个人不是很建议修改它, 因为默认的值作为键名完全够用,
此外还有一个 `SettingSubText` 特性, 它可以向该选项被选中时在底下显示一行小字, 它的参数同样是个本地化键名,
类似的还有 `SettingSubHeader` 特性, 它会向该选项之前加入一个小标题.

对于枚举每一项的值可以使用 `modoptions_{类名}_{属性名}_{枚举项名}` 来指定, 例如对于 `DayOfWeek` 枚举类型的 `Day` 属性:

```ini title="ModFolder/Dialog/Simplified Chinese.txt"
modoptions_mycelestemod_day_sunday=星期日
modoptions_mycelestemod_day_monday=星期一
modoptions_mycelestemod_day_tuesday=星期二
modoptions_mycelestemod_day_wednesday=星期三
modoptions_mycelestemod_day_thursday=星期四
modoptions_mycelestemod_day_friday=星期五
modoptions_mycelestemod_day_saturday=星期六
```

!!! info
    如果你实际测试的话你会发现 `三` 字和 `五` 字没有渲染出来, 这是正常的, 因为蔚蓝的字库中没有这两个字,
    这里我就不赘述如何解决这个问题了, 具体可以咨询 mapper 们. ([日常偷懒.jpg](https://www.bilibili.com/video/BV1A14y1W7hr))

### 最后

或许你也已经猜到了, Everest 正是使用的 Yaml 来序列化/反序列化你的 `Settings` 类,
所以请务必不要在你的 `Settings` 类中放置奇怪的类和结构体! 如果你要这么做请确保 Everest 能正确地序列化/反序列化你的 `Settings` 类,
否则你的设置将**不会**被正常保存, 永远都是默认值.

<!--TODO 高级 Settings, 例如自定义菜单之类的-->

## Session

### 基本

Session 是一个蔚蓝中保存数据的概念, 它用于保存 "保存并退出" 按钮按下后所保存的数据, 例如当前已激活的 Flag, 重生点, 已拾取的钥匙, 草莓, 核心的模式等.
在自定义你自己的 `Session` 后, 你可以在这里保存你自己独有的收集物信息, 或者是一些实体需要临时保存于关卡的数据.  
与 Settings 相同, 我们需要先创建一个继承于 `EverestModuleSession` 的类, 然后在模块类中声明它:

```cs title="MyCelesteModSession.cs"
public sealed class MyCelesteModSession : EverestModuleSession
{
}
```

```cs title="MyCelesteModModule.cs"
public sealed class MyCelesteModModule : EverestModule
{
    public static MyCelesteModModule Instance { get; private set; }

    public override Type SettingsType => typeof(MyCelesteModSettings);
    public static MyCelesteModSettings Settings => (MyCelesteModSettings)Instance._Settings;

    public override Type SessionType => typeof(MyCelesteModSession);
    public static MyCelesteModSession Session => (MyCelesteModSession)Instance._Session;

    public override void Load()
    {
        Instance = this;
    }

    public override void Unload()
    {
    }
}
```

然后我们就可以在任何游戏处于关卡内的时候使用 `MyCelesteModModule.Session` 来访问我们的 Session 了.
如果你尝试在游戏不在关卡内时读取它, 那么你会得到一个 `null` 值.  

假设我们碰了 `SetPassByRefillDashesTrigger` 之后又碰到 `ChangeRespawnTrigger` 改变了重生点, 用 `Save And Quit`
退出了游戏, 再次进入时你会发现重生点是新的, 而 `PassByRefill` 的冲刺数又变回 `1` 了, 所以接下来我们尝试通过 `Session` 来修正这个错误.  

```cs title="MyCelesteModSession.cs"
public sealed class MyCelesteModSession : EverestModuleSession
{
    public Dictionary<string, int> RoomIdToPassByRefillDashes = new();  // 我们将记录每个房间名对应的PassByRefill的冲刺数
}
```

```cs title="SetPassByRefillDashesTrigger.cs"
[CustomEntity("MyCelesteMod/SetPassByRefillDashesTrigger")]
public class SetPassByRefillDashesTrigger : Trigger
{
    public int Dashes;

    public SetPassByRefillDashesTrigger(EntityData data, Vector2 offset)
        : base(data, offset)
    {
        Dashes = data.Int("dashes");
    }

    public override void OnEnter(Player player)
    {
        base.OnEnter(player);
        MyCelesteModModule.Session.RoomIdToPassByRefillDashes[SceneAs<Level>().Session.LevelData.Name] = Dashes;
    }
}
```

```cs title="PassByRefill.cs"
[CustomEntity("MyCelesteMod/PassByRefill")]
public class PassByRefill : Entity
{
    private int _dashes = 1;

    public int Dashes => MyCelesteModModule.Session.RoomIdToPassByRefillDashes.GetValueOrDefault(SceneAs<Level>().Session.LevelData.Name, _dashes);

    private Image image;

    public PassByRefill(Vector2 position, int dashes)
    {
        Depth = 1;
        Dashes = dashes;
        Position = position;
        Hitbox hitbox = new(64, 64);
        Collider = hitbox;

        MTexture tex = GFX.Game["MyCelesteMod/pass_by_refill"];
        image = new(tex);
        Add(image);
    }

    public PassByRefill(EntityData data, Vector2 offset)
        : this(data.Position + offset, data.Int("dashes"))
    {
    }

    public override void Update()
    {
        base.Update();
        var player = Scene.Tracker.GetEntity<Player>();
        if (player is not null && CollideCheck(player))
        {
            player.Dashes = Dashes;
        }
    }
}
```

## SaveData

顾名思义, `SaveData` 用来保存一些持久化数据, 例如当前存档总时间, 总死亡数, 总草莓数等.
使用它与使用 `Session` 极其相似:

```cs title="MyCelesteModSaveData.cs"
public sealed class MyCelesteModSaveData : EverestModuleSaveData
{
}
```

```cs title="MyCelesteModModule.cs"
public sealed class MyCelesteModModule : EverestModule
{
    public static MyCelesteModModule Instance { get; private set; }

    public override Type SettingsType => typeof(MyCelesteModSettings);
    public static MyCelesteModSettings Settings => (MyCelesteModSettings)Instance._Settings;

    public override Type SessionType => typeof(MyCelesteModSession);
    public static MyCelesteModSession Session => (MyCelesteModSession)Instance._Session;

    public override Type SaveDataType => typeof(MyCelesteModSaveData);
    public static MyCelesteModSaveData SaveData => (MyCelesteModSaveData)Instance._SaveData;

    public override void Load()
    {
        Instance = this;
    }

    public override void Unload()
    {
    }
}
```