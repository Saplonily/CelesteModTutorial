# 跨 Mod 交互

有时我们会希望使用其他 Mod 或提供自己 Mod 的功能, 这一节将介绍 `ModInterop` 的使用及一些常见的交互方法.

## 依赖管理

在与其他 Mod 交互前, 我们需要在 `everest.yaml` 中添加相应的依赖.
这里我们以 `GravityHelper` 为例:

```yaml title="everest.yaml"
- Name: MyCelesteMod
  Version: 0.1.0
  DLL: MyCelesteMod.dll
  Dependencies:
    - Name: EverestCore
      Version: 1.4465.0
  OptionalDependencies:
    - Name: GravityHelper
      Version: 1.2.20
```

`everest.yaml` 中的依赖分为以下两种:

- `Dependencies` 必需依赖: 必须在你的 Mod 加载前完成加载.
- `OptionalDependencies` 可选依赖: 只有在被启用时加载, 未启用则会忽略.

通常为了保持 Mod 的轻量性与灵活性, 建议尽可能减少必需依赖的数量.
如果一个依赖是可选的, 我们应该在使用被依赖的功能前检查它是否被成功加载.

一个可能的实现如下:

```cs title="MyCelesteModModule.cs"
public static bool GravityHelperLoaded;

public override void Load()
{
    // 获取 GravityHelperModule 的元数据
    EverestModuleMetadata gravityHelperMetadata = new()
    {
        Name = "GravityHelper",
        Version = new Version(1, 2, 20)
    };
    
    // 判断 GravityHelper 是否成功加载
    GravityHelperLoaded = Everest.Loader.DependencyLoaded(gravityHelperMetadata);
}
```

这样我们就能在使用被依赖的功能前检查 `GravityHelperLoaded` 以确保被依赖的 Mod 成功加载.



## ModInterop

`ModInterop` 是 `MonoMod` 的一项十分强大的功能, 其提供了一种标准化的方式以实现不同 Mod 间的交互, 几乎可以视为我们拥有的最接近 "官方" 的 API.

一个 Mod 可以通过 `ModExportName` 特性导出一组方法, 而其他的 Mod 可以通过 `ModImportName` 特性导入这些方法作为委托以调用.

!!! info
    如果被依赖的 Mod 被禁用, 其通过 `ModExportName` 导出的委托将会是 `null`, 调用它们将导致游戏崩溃.
    我们应该检查被依赖的 Mod 是否启用以决定是否调用.

下面我们将介绍这两种特性的使用.

### ModExportNameAttribute

`ModExportNameAttribute(string name)` 特性用于导出我们希望提供的方法, `name` 参数是我们提供的一系列 API 的唯一标识符, 用于在其他 Mod 中引用此 API.

下面我们新建一个 `MyCelesteModExports` 类进行示例:
```cs title="MyCelesteModExports.cs"
using MonoMod.ModInterop;

// 定义我们希望导出的 ModInterop API
[ModExportName("MyCelesteMod")]
public static class MyCelesteModExports
{
    // 添加于 2.0.2 版本
    public static int GetNumber() => 202;
    // 添加于 1.0.1 版本
    public static int MultiplyByTwo(int num) => num * 2;
    // 添加于 1.0.0 版本
    public static void LogStuff() => Logger.Log(LogLevel.Info, "MyCelesteMod", "Someone is calling this method!");
    // 添加于 1.0.0 版本
    public static void LogNumber(int number) => Logger.Log(LogLevel.Info, "MyCelesteMod", $"Number is {number}!");
    // 添加于 1.0.0 版本
    public static bool TryDoubleIfEven(int number, out int? doubledNumber)
    {
        if (number % 2 == 0)
        {
            doubledNumber = number * 2;
            return true;
        }
        else
        {
            doubledNumber = null;
            return false;
        }
    }
}
```

!!! info
    请记住, API 是一种**契约**. 使用你的 API 的 Mod 作者会期望它至少能在你的 API 下一个主要版本前保持稳定.
    因此, 我们**强烈**建议你记录每个版本 API 的修改, 至少包括每个方法的添加版本.
    这样可以帮助其他 Mod 作者了解哪些 API 是新增的, 哪些是更改过的, 尽可能避免因接口变动而导致的问题.

在完成了上面这些后, 我们还需要在 Mod 的 `Module` 中注册导出的 `ModInterop` API:
```cs title="MyCelesteModModule.cs"
using MonoMod.ModInterop;

public override void Load()
{
    // 注册 ModInterop API
    typeof(MyCelesteModExports).ModInterop();
}
```

这样, 我们就完成 `ModInterop` API 的导出.

### ModImportNameAttribute

`ModImportNameAttribute(string name)` 特性用于在你的 Mod 中引入其他 Mod 导出的 API, `name` 参数是我们导入 API 的唯一标识符, 用于指定我们需要导入的 API.

下面我们新建另一个 Mod `AnotherCelesteMod` 导入 `MyCelesteMod` 提供的 API:

!!! info
    在导入前记得在 `everest.yaml` 中添加 `MyCelesteMod` 的可选依赖.

```cs title="MyCelesteModAPI.cs"
using MonoMod.ModInterop;

// 导入我们希望使用的 ModInterop API
// ModImportName 的参数必须与对应的 ModExportName 的参数匹配
[ModImportName("MyCelesteMod")]
public static class MyCelesteModAPI
{
    // 导出的方法如果有返回值使用 Func
    public static Func<int> GetNumber;
    public static Func<int, int> MultiplyByTwo;

    // 如果没有返回值, 也就是返回值是 void 则使用 Action
    public static Action LogStuff;
    public static Action<int> LogNumber;

    // 如果导出的方法参数中有 in, out 或 ref 需要定义自定义委托类型以进行导入
    // Func 并不支持参数中带有 in, out 或 ref 的情况
    public delegate bool TryDoubleIfEvenDelegate(int number, out int? doubledNumber);
    public static TryDoubleIfEvenDelegate TryDoubleIfEven;
}
```

别忘了在 `Module` 中注册我们导入的 API:
```cs title="AnotherCelesteModModule.cs"
using MonoMod.ModInterop;

public override void Load()
{
    // 注册 ModInterop API
    typeof(MyCelesteModAPI).ModInterop();
}
```

现在我们可以通过 `MyCelesteModAPI` 中导入的委托以调用我们希望使用的功能:
```cs
int myNumber = MyCelesteModAPI.GetNumber();

if (MyCelesteModAPI.MultiplyByTwo(myNumber) > 400)
{
    MyCelesteModAPI.LogStuff();
}

if (MyCelesteModAPI.TryDoubleIfEven(myNumber, out int? doubledNumber))
{
    MyCelesteModAPI.LogNumber(doubledNumber);
}
```

通过这种方式, 我们可以在自己的 Mod 中访问并调用其他 Mod 提供的功能, 而不需要直接依赖该 Mod 的程序集.



## 直接程序集引用

有时候我们需要直接使用目标Mod中的类型和方法, 但目标 Mod 并没有实现 `ModInterop` API.
这种情况下, 我们可以直接引用其他 Mod 的程序集.

下面我们介绍两种方法:

### Cache

Everest 会将所有 Code Mod 的程序集使用 MonoMod 进行 patch 处理后放置到 `Celeste/Mods/Cache/<mod名>.<程序集名>.dll` 中.     
我们可以通过配置模板的 `.csporj` 文件以直接引用它们:

```xml title="MyCelesteMod.csproj" hl_lines="19 20 21 22 23"
<Project Sdk="Microsoft.NET.Sdk">
  <Import Project="CelesteMod.props" />

  <PropertyGroup>
    <RootNamespace>Celeste.Mod.MyCelesteMod</RootNamespace>
    <LangVersion>latest</LangVersion>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <None Include="CelesteMod.props">
      <Visible>false</Visible>
    </None>
    <None Include="CelesteMod.targets">
      <Visible>false</Visible>
    </None>
  </ItemGroup>

<ItemGroup>
	<CelesteModReference Include="GravityHelper" />
	<CelesteModReference Include="ExtendedVariantMode" />
    <CelesteModReference Include="FrostHelper" AssemblyName="FrostTempleHelper" />
</ItemGroup>

  <Import Project="CelesteMod.targets" />
</Project>
```

!!! info
    在引用之前我们需要确认目标 Mod 在 `Cache` 中的是否存在, 以上面引用的 Mod 为例. `Cache` 中应该存在:

    - GravityHelper.GravityHelper.dll
    - ExtendedVariantMode.ExtendedVariantMode.dll
    - FrostHelper.FrostTempleHelper.dll


### lib-stripped

`lib-stripped` 是指剥离了所有方法实现的程序集, 仅保留类型和方法签名.      
我们可以通过 [`NStrip`](https://github.com/bbepis/NStrip) 或 [`BepInEx.AssemblyPublicizer `](https://github.com/BepInEx/BepInEx.AssemblyPublicizer) 的 `strip-only` 模式等工具对目标程序集进行剥离.     
完成后我们可以直接引用被剥离的程序集.



## 通过 EverestModule 反射获取程序集

我们也可以通过 `EverestModule` 反射动态地访问我们希望交互的 Mod 的程序集, 而无需直接引用目标 Mod 的程序集.

下面我们以 [`GravityHelper`](https://github.com/swoolcock/GravityHelper) 为例:
```cs title="MyCelesteModModule.cs"
public static bool GravityHelperLoaded;

public static PropertyInfo PlayerGravityComponentProperty;
public static PropertyInfo IsPlayerInvertedProperty;
public static MethodInfo SetPlayerGravityMethod;

public override void Load()
{
    // 获取 GravityHelperModule 的元数据
    EverestModuleMetadata gravityHelperMetadata = new()
    {
        Name = "GravityHelper",
        Version = new Version(1, 2, 20)
    };

    GravityHelperLoaded = Everest.Loader.DependencyLoaded(gravityHelper);

    // 通过 EverestModule 反射获取 GravityHelper 的程序集
    if (Everest.Loader.TryGetDependency(gravityHelperMetadata, out var gravityModule))
    {
        // 反射获取 Celeste.Mod.GravityHelper.GravityHelperModule 类型
        Assembly gravityAssembly = gravityModule.GetType().Assembly;
        Type gravityHelperModuleType = gravityAssembly.GetType("Celeste.Mod.GravityHelper.GravityHelperModule");

        // 反射获取 GravityHelper.GravityHelperModule.PlayerComponent 属性
        PlayerGravityComponentProperty = gravityHelperModuleType?.GetProperty("PlayerComponent", BindingFlags.NonPublic | BindingFlags.Static);

        // 反射获取 GravityHelper.Components.SetPlayerGravity 方法
        SetPlayerGravityMethod = PlayerGravityComponentProperty?.GetValue(null)?.GetType().GetMethod("SetGravity", BindingFlags.Public | BindingFlags.Instance);

        // 反射获取 GravityHelper.GravityHelperModule.ShouldInvertPlayer 属性
        IsPlayerInvertedProperty = gravityHelperModuleType?.GetProperty("ShouldInvertPlayer", BindingFlags.Public | BindingFlags.Static);
    }
}
```

!!! info
    如果需要反射获取的内容较多建议联系 Mod 作者, 让 Mod 作者添加相应的 `ModInterop` API.

完成这些后我们就可以访问和调用这些东西了:
```cs  title="SampleTrigger.cs"
[CustomEntity("MyCelesteMod/SampleTrigger")]
public class SampleTrigger : Trigger
{
    public SampleTrigger(EntityData data, Vector2 offset)
        : base(data, offset)
    {
        // 判断 GravityHelper 是否成功加载
        if (!MyCelesteModModule.GravityHelperLoaded)
        {
            throw new Exception("SampleTrigger requires GravityHelper as a dependency!")
        }
    }

    public override void OnEnter(Player player)
    {
        base.OnEnter(player);

        // 设置玩家重力
        object[] parameters = [2, 1f, false];
        MyCelesteModModule.SetPlayerGravityMethod.Invoke(MyCelesteModModule.PlayerGravityComponentProperty.GetValue(null), parameters);

        // 获取玩家是否在反重力状态下
        bool isPlayerInverted = (bool)MyCelesteModModule.IsPlayerInvertedProperty.GetValue(null);
        Logger.Log(LogLevel.Info, "MyCelesteMod", $"isPlayerInverted is {isPlayerInverted}!");
    }
}
```

这种方式和 `ModInterop` 类似, 可以在不直接引用目标 Mod 的程序集的情况下进行交互.
不过代码会变得更复杂, 更脆弱, 可读性也会降低.
此外, 目标 Mod 的一些改动可能会导致你的 Mod 不能按预期工作, 从而导致崩溃.

我们只建议只需要轻度交互时使用这种方式, 如果目标 Mod 有 `ModInterop` API 时更推荐去使用 `ModInterop` API.



## 跨 Mod 钩子

我们也可以为另一个 Mod 添加 IL 钩子, 参考 [IL 钩子](../hooks/adv_hooks.md).

不过, 一般不鼓励像这样改变另一个 Mod 的行为. 安装 Mod 的用户通常希望它的行为与描述一致, 因此任何外部更改都应尽量少做.
此外, 这种方法比使用反射调用方法更加脆弱, 因为它依赖于签名和 IL 的相对稳定.
