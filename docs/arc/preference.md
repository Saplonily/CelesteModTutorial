# 偏好

在本系列教程中本人可能会偶尔习惯性的使用一些比较新的 C# 语法或者是特性, 通常这是大部分 C# 教程中很少提及的, 所以为了避免困惑我会在这里提及他们.

!!! note
    为了使用这些语法你可能需要安装 [`.NET 8 SDK`](https://dotnet.microsoft.com/zh-cn/download),
    如果你无法理解某些东西,
    没关系, 你依然可以使用同时提及到的等效方法

## 简单了解项目文件

在解决方案资源管理器中, 双击你的项目, 按理来说你应该会打开该项目的 `.csproj` 文件,
通常也叫做项目文件, 它描述了这个项目的各方面的信息, 并且以下几小节的内容也依赖于此.  
如果你使用的是从模板配置的环境, 那么你应该会看到如下内容:

```xml title=".csproj"
<Project Sdk="Microsoft.NET.Sdk">
	<Import Project="CelesteMod.props" />
	<Import Project="Common.props" />
	<PropertyGroup>
		<RootNamespace>$(AssemblyName)</RootNamespace>
		<LangVersion>preview</LangVersion>
	</PropertyGroup>

	<ItemGroup>
		<Reference Include="System" />
		<Reference Include="System.Core" />
		<Reference Include="System.Xml.Linq" />
		<Reference Include="System.Xml" />
	</ItemGroup>

	<Import Project="CelesteMod.targets" />
</Project>

```
!!! note
    这个文件是 XML 格式的, 如果你不熟悉 XML 的话你可以到[这里](../extra/xml/xml_speedrun.md)简单看一下, 免得你不知道我们讨论的东西都是什么

其中我们只需要关注里面的 `PropertyGroup` 以及 `ItemGroup` 节点  
`PropertyGroup` 节点定义了这个项目有哪些属性, 比如项目框架版本, 语言版本, 程序集昵称等  
`ItemGroup` 则定义了这个项目包含什么, 比如引用了哪些程序集、哪些 nuget 包等.

## Implicit Usings (隐式 Using)

!!! note
    对于通过模板构建的项目来说这一步已经完成, 你可以尝试将 `Common.props` 中的 `CommonCelesteUsings` 更改为 `false` 来感受没有启用的效果

现在看看你的源文件头顶是不是充满了一大堆 `using xxx`? 那就对了, 我们可以使用这个特性来让它看起来更简介些.
那么打开你的项目文件, 向你的 `ItemGroup` 中加入这些:

```xml
<Using Include="System"/>
<Using Include="System.Collections.Generic"/>
<Using Include="System.IO"/>
<Using Include="System.Linq"/>
<Using Include="System.Threading"/>
<Using Include="System.Threading.Tasks"/>
```

这个时候你就可以移除你的大部分 `System` 开头的 Using 语句啦, 这被称为 `隐式 Using`, 因为我们是蔚蓝 mod, 所以我们经常也会 Using 以下几个命名空间:

- `Celeste.Mod`: 包含很多 Everest 相关东西
- `Celeste`: 蔚蓝本体所在命名空间
- `Monocle`: 蔚蓝自己的游戏引擎
- `Microsoft.Xna.Framework`: 蔚蓝自己的游戏引擎的底层框架

对这些隐式 Using 我们也向 `ItemGroup` 加入:
```xml
<Using Include="Celeste.Mod"/>
<Using Include="Celeste"/>
<Using Include="Monocle"/>
<Using Include="Microsoft.Xna.Framework"/>
```

现在打开你的代码文件, 你可以将头顶上的大部分 Using 都删除了, 这样, 你的代码文件变的更加的干净整洁:
```cs title="MyModModule.cs"
namespace MyCelesteMod
{
    public class MyModModule : EverestModule
    {
        public override void Load()
        {
            
            Logger.Log(LogLevel.Info, "MyCelesteMod", "Hello World! Hello Everest!");
        }

        public override void Unload()
        {

        }
    }
}
```

## File Scoped Namespaces

对于 namespace 命名空间来说我们通常一个文件只有一个命名空间, 那么最外层的 namespace 的缩进就有些浪费横向空间,
所以我们选择使用 `File Scoped Namespaces`, 这很简单:

- 在 `namespace MyCelesteMod` 后加上一个分号
- 删除 namespace 的两个大括号
- 回退 namespace 下的所有缩进
- 搞定了, 走你!

```cs title="MyModModule.cs"
namespace MyCelesteMod;

public class MyModModule : EverestModule
{
    public override void Load()
    {
        Logger.Log(LogLevel.Info, "MyCelesteMod", "Hello World! Hello Everest!");
    }

    public override void Unload()
    {

    }
}
```

!!! info
    如果你收到错误 `CS8370`, 那你可能需要在 `PropertyGroup` 下添加这一行:  
    ```xml
    <LangVersion>preview</LangVersion>
    ```

## 方法? 函数?

嗯这个是后来加的, 因为我发现我在整个文档里都在混用 "方法" 和 "函数" 这两个名字, 但是修改起来比较麻烦所以我还是选择在这里说几句:  
"函数" 是源自古早的面向过程语言的概念, 后来随着 OOP 面向对象思想的流行, 函数逐渐被封装到类里, 而类里的这些函数在习惯上我们才会称之为 "方法",
但是也有人仍然将这些东西称之为 "函数", 所以实际上在面向对象的语言里你可以将 "方法" 和 "函数" 看为一个东西, 或者仅在本文档中这么看.