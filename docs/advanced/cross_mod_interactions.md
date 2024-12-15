# 跨 Mod 交互

有时我们会希望使用其他 Mod 或提供自己 Mod 的功能, 这一节将介绍 `ModInterop` 的使用及一些常见的交互方法.

## 依赖管理

在与其他 Mod 交互前, 我们需要在 `everest.yaml` 中添加相应的依赖.
这里我们以 `GravityHelper` 为例:

```yml title="everest.yaml"
- Name: MyCelesteMod
  Version: 0.1.0
  DLL: MyCelesteMod.dll
  Dependencies:
    - Name: Everest
      Version: 1.4000.0
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
    EverestModuleMetadata gravityHelper = new()
    {
        Name = "GravityHelper",
        Version = new Version(1, 2, 22)
    };
    
GravityHelperLoaded = Everest.Loader.DependencyLoaded(gravityHelper);
}
```

这样我们就能在使用被依赖的功能前检查 `GravityHelperLoaded` 以确保被依赖的 Mod 成功加载.



## ModInterop

`ModInterop` 是 `MonoMod` 的一项十分强大的功能, 其提供了一种标准化的方式以实现不同 Mod 间的交互, 几乎可以视为我们拥有的最接近 "官方" 的 API.

一个 Mod 可以通过 `ModExportName` 特性导出一组方法, 而其他的 Mod 可以通过 `ModImportName` 特性导入这些方法作为委托以调用.
下面我们将介绍这两种特性的使用.

### ModExportName

`ModExportName(string name)` 特性用于导出我们希望提供的方法, `name` 参数是我们提供的一系列 API 的唯一标识符, 用于在其他 Mod 中引用此 API.

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
    public static void LogStuff() => Logger.Log(LogLevel.Info, "MyCelesteMod", "Someone is calling this delegate!");
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

### ModImportName

`ModImportName(string name)` 特性用于在你的 Mod 中引入其他 Mod 导出的 API，`name` 参数是我们导入 API 的唯一标识符, 用于指定我们需要导入的 API.

下面我们新建另一个 Mod `AnotherCelesteMod` 导入 `MyCelesteMod` 提供的 API:
```cs title="MyCelesteModAPI.cs"
using MonoMod.ModInterop;

// 导入我们希望使用的 ModInterop API
// ModImportName 的参数必须与对应的 ModExportName 的参数匹配
[ModImportName("MyCelesteMod")]
public static class MyCelesteModAPI
{
    public static Func<int> GetNumber;
    public static Func<int, int> MultiplyByTwo;
    public static Action LogStuff;
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
int myNumber = MyCelesteModAPI.GetNumber?.Invoke();

if (MyCelesteModAPI.MultiplyByTwo?.Invoke(myNumber) > 400)
{
    MyCelesteModAPI.LogStuff?.Invoke();
}
```

!!! warning
    如果被依赖的 Mod 被禁用, 其通过 `ModExportName` 导出的委托将会是 `null`. 
    在调用之前，请**务必**检查委托是否为 `null` 以避免游戏崩溃.

通过这种方式, 我们可以在自己的 Mod 中访问并调用其他 Mod 提供的功能, 而不需要直接依赖该 Mod 的程序集.

<!--
## 直接程序集引用

### Cache

### lib-stripped

### 反射获取

!!! info
    如果需要反射获取的内容较多建议联系 Mod 作者, 让 Mod 作者添加相应的 [`ModInterop`](#modinterop) API.

## 跨 Mod 钩子
-->