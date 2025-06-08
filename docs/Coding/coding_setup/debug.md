# Debug 调试

只要写程序就免不了 bug, 所以我们需要强有力的 debug 手段.

![code_joke](images/debug/code_joke.jpg)

## 热重载

为了方便我们的调试, 我们需要让蔚蓝打开的同时打开控制台, 这一步很简单:

- 找到蔚蓝根目录下的 `everest-launch.txt`, 没有的话新建一个空的就行了.
- 向里面写入 `--console`.

!!!info
    `--console` 项只在 `Windows` 系统上有用.

```txt title="everest-launch.txt" hl_lines="7"
# Add any Everest launch flags here.
# Lines starting with # are ignored.
# All options here are disabled by default.
# Full list: https://github.com/EverestAPI/Resources/wiki/Command-Line-Arguments

# Windows only: open a separate log console window.
--console

# FNA only: force OpenGL (might be necessary to bypass a load crash on some PCs).
#--graphics OpenGL

# Change default log level (verbose will print all logs).
#--loglevel verbose
```

现在, 重新编译项目, 启动蔚蓝, 你应该能看到同时启动的命令行窗口.  

在经过如上的配置后, 你会发现在蔚蓝启动的时候, 进行编译并复制资源时会报错, 
这是因为 Everest 锁定占用了它们, 导致你不得不让这一切在蔚蓝关闭时进行,
同时由于蔚蓝的重启速度不是很理想, 这大大的拉低了 Mod 开发效率.  
不过好在 Everest 提供了一个技术叫做 `code hot reload`,
即热重载, 它允许在游戏运行期间替换你的代码并重载资源.
要开启这项功能, 首先到蔚蓝根目录下的 `Saves` 目录, 找到并打开 `modsettings-Everest.celeste` 这个文件,
翻到大概中间的位置, 找到属性 `CodeReload_WIP`, 将其更改为 `true`.

```yaml title="modsettings-Everest.celeste" hl_lines="11"
# 其他设置

PhotosensitiveMode: false
PhotosensitivityDistortOverride: false
PhotosensitivityGlitchOverride: false
PhotosensitivityLightningOverride: false
PhotosensitivityScreenFlashOverride: false
PhotosensitivityTextHighlightOverride: false
QuickRestart: 
ShowManualTextOnDebugMap: true
CodeReload_WIP: true
UseInGameCrashHandler: true
CrashHandlerAlwaysTeabag: false
CurrentVersion: 1.4465.0
CurrentBranch: updater_src_stable
LogLevels: {}

# 其他设置
```

完成设置后重新编译项目, 你应该就不会再得到任何错误, 并且 Everest 也正确地热重载了你的 Mod 和你的 Mod 资源.

## Logger

`Logger` 是一个蔚蓝 `Everest` 的一个工具类, 它帮助你打印输出一些调试信息,
通常这些信息会被打印进控制台的同时写入游戏的 `log.txt` 文件中, 
这也解释了为什么你遇到各种问题时别人总要求你发送你的 `log.txt`.  

`Logger.Log` 有两个重载, 其中一个的签名是:
```cs
public static void Log(LogLevel logLevel, string tag, string str)
```
它会以 `logLevel` 的日志等级打印一个标签为 `tag` 的消息 `str`,
另一个重载不要求你传入 `logLevel` 但会默认你的 `logLevel` 为 `LogLevel.Verbose`.

`LogLevel` 包含以下枚举, 以优先级从低到高排序:

- `Verbose`: 一般用于输出冗余的日志信息.
- `Debug`: 一般用于输出较多的调试信息.
- `Info`: 一般用于输出普通日志.
- `Warn`: 一般用于输出一些错误但不影响游戏进行的信息.
- `Error`: 一般用于输出一些致命性错误.

一般地, 游戏只会打印 `Info` 优先级及以上的日志, 你可以通过在 `everest-launch.txt` 中加入`--loglevel {等级}`来指定过滤等级.

下面是一些使用示例:

```cs
Logger.Log(LogLevel.Info, "MyCelesteMod", "Hello my Celeste!");
Logger.Log(LogLevel.Info, "YourCelesteMod", "Hello your Celeste!");
Logger.Log(LogLevel.Warn, "MyCelesteMod", "This is a warn!");
Logger.Log(LogLevel.Error, "MyCelesteMod", "Fatal error!");
```

这会在控制台输出:

```log
(01/19/2025 15:19:00) [Everest] [Info] [MyCelesteMod] Hello my Celeste!
(01/19/2025 15:19:00) [Everest] [Info] [YourCelesteMod] Hello your Celeste!
(01/19/2025 15:19:00) [Everest] [warn] [MyCelesteMod] This is a warn!
(01/19/2025 15:19:00) [Everest] [Error] [MyCelesteMod] Fatal error!
```

## 附加到进程

最常见的 debug 手段是通过 `Logger.Log()`, 能解决大部分问题, 但当项目做大, 嵌套变多, `Logger` 输出的信息已经满足不了我们的时候(甚至我们都不知道这个 bug 哪儿来的), 我们一般就要使用断点来调试, 步骤如下:

* 打开蔚蓝
* 在你的 IDE 上 debug 选项附近选择**附加到进程**, 然后选择 `Celeste.exe`, 这里以 `Visual Studio` 为例:

![p1](images/debug/debug_p1_1.png)


这里我们新建一个 `SampleTrigger` 进行演示:

```cs title="SampleTrigger.cs"
[CustomEntity("MyCelesteMod/SampleTrigger")]
public class SampleTrigger : Trigger
{
    private int num;

    public SampleTrigger(EntityData data, Vector2 offset)
        : base(data, offset)
    {
        num = 0;
    }

    public override void OnStay(Player player)
    {
        base.OnStay(player);

        num++;
        if (num > 60)
        {
            Logger.Log(LogLevel.Info, "MyCelesteMod", "Number has passed 60! Now reset to 0.");
            num = 0;
        }
    }
}
```

我们在旁边打上红红的断点:

![vs_breakpoint](images/debug/vs_breakpoint.png)

* 然后当 Madeline 碰到 `SampleTrigger` 时, 游戏进程就会被锁住, 接着你可以通过步进, 步入, 步出等方式进行调试, 获取想要的信息
例如获取 `num` 的值:

![vs_local_varible](images/debug/vs_local_varible.png)

* 调试完成后, 你可以直接停止调试, 或者把断点点掉然后点击"恢复程序运行", 之后再打上断点继续调试
