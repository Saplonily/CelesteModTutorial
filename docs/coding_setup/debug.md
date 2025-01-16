# Debug调试

只要写程序就免不了bug, 所以我们需要强有力的debug手段

![code_joke](images/debug/code_joke.jpg)

最常见的debug手段是通过 `Logger.Log()`, 能解决大部分问题, 但当项目做大, 嵌套变多, `Logger` 输出的信息已经满足不了我们的时候(甚至我们都不知道这个 bug 哪儿来的), 我们一般就要使用断点来调试, 步骤如下:

* 打开蔚蓝
* 在你的IDE上debug选项附近选择**附加到进程**, 然后选择蔚蓝, 这里以 `Visual Studio` 为例:

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
