# 偏好

在本系列教程中本人可能会偶尔习惯性的使用一些比较新的 C# 语法或者是特性, 通常这是大部分 C# 教程中很少提及的, 所以为了避免你的困惑我会在这里提及他们.
!!! note
    为了使用这些语法你可能需要安装 [`.NET 6 SDK`](https://dotnet.microsoft.com/zh-cn/download),
    如果你无法理解某些东西,
    没关系, 你依然可以使用同时提及到的等效方法

## Sdk-style csproj

现在打开你的项目目录中的 `.csproj` 文件(通常也会被叫作\*项目文件\*), 它用于组织描述你的项目是什么样子的, 你可能会发现非常的杂乱不可读, 就像:

```xml title=".csproj" hl_lines="8 10-12 34-50"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{100E625E-04C6-434F-865C-3E6E50A379B5}</ProjectGuid>
    <OutputType>Library</OutputType>
    <AppDesignerFolder>Properties</AppDesignerFolder>
    <RootNamespace>MyCelesteMod</RootNamespace>
    <AssemblyName>MyCelesteMod</AssemblyName>
    <TargetFrameworkVersion>v4.5.2</TargetFrameworkVersion>
    <FileAlignment>512</FileAlignment>
    <Deterministic>true</Deterministic>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <Optimize>false</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Celeste">
      <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\Celeste.exe</HintPath>
    </Reference>
    <Reference Include="FNA">
      <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\FNA.dll</HintPath>
    </Reference>
    <Reference Include="MMHOOK_Celeste">
      <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\MMHOOK_Celeste.dll</HintPath>
    </Reference>
    <Reference Include="YamlDotNet">
      <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\YamlDotNet.dll</HintPath>
    </Reference>
    <Reference Include="System" />
    <Reference Include="System.Core" />
    <Reference Include="System.Xml.Linq" />
    <Reference Include="Microsoft.CSharp" />
    <Reference Include="System.Xml" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="MyModModule.cs" />
    <Compile Include="Properties\AssemblyInfo.cs" />
  </ItemGroup>
  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
</Project>
```
!!! note
    对于此部分的内容你可能需要阅读了解一下 `XML` 格式文件

实际上对于我们真正经常修改的属性只有上面标亮的行, 那么如果这时候使用 `Sdk-style csproj` 会好很多, 它看上去是这样的:

```xml title="Sdk-style csproj"
<Project Sdk="Microsoft.NET.Sdk">

    <PropertyGroup>
        <OutputType>Library</OutputType>
        <RootNamespace>MyCelesteMod</RootNamespace>
        <AssemblyName>MyCelesteMod</AssemblyName>
        <TargetFramework>net452</TargetFramework>
    </PropertyGroup>

    <ItemGroup>
        <Reference Include="Celeste">
            <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\Celeste.exe</HintPath>
        </Reference>
        <Reference Include="FNA">
            <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\FNA.dll</HintPath>
        </Reference>
        <Reference Include="MMHOOK_Celeste">
            <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\MMHOOK_Celeste.dll</HintPath>
        </Reference>
        <Reference Include="YamlDotNet">
            <HintPath>..\..\..\..\..\..\Program Files (x86)\Steam\steamapps\common\Celeste\YamlDotNet.dll</HintPath>
        </Reference>
        <Reference Include="System" />
        <Reference Include="System.Core" />
        <Reference Include="System.Xml.Linq" />
        <Reference Include="Microsoft.CSharp" />
        <Reference Include="System.Xml" />
    </ItemGroup>

</Project>
```

你会发现其实这里只留下了我们上面标黄的东西,
是的, 这就是 `Sdk-style csproj` 的优点.  
迁移至 `Sdk-style csproj` 非常简单, 你只需要:

- 删除 `PropertyGroup` 和 `ItemGroup` 及旁边的非标黄节点
- 在 `Project` 节点上加入属性: `Sdk = "Microsoft.NET.Sdk"`
- `TargetFrameworkVersion` 更改为新版的 `TargetFramework`, `v4.5.2` 更改为 `net452`

这个时候整个文件清晰可读:

- 根节点的 `Project` 下挂载着 `PropertyGroup` 以及 `ItemGroup`,
- `PropertyGroup` 描述了我们项目的一些通用属性, 比如输出类型, 命名空间, 程序集昵称以及项目框架版本,
- `ItemGroup` 则描述了我们项目中的一些引用等.

在这里提及这个是因为在后面部分我们会需要修改 `.csproj` 文件,
通过对比你可以发现这两个 xml 文件都有 `PropertyGroup` 和 `ItemGroup` 节点 (如果有多个节点的话, 任意一个都行),
所以我们之后对项目文件的修改的描述都会基于**这两个节点**.

## Implicit Usings (隐式 Using)

现在看看你的源文件头顶是不是充满了一大堆 `using xxx`? 那就对了, 我们可以使用这个特性来让它看起来更简介些.
那么打开你的项目文件, 向 `PropertyGroup` 加入一句 `<ImplicitUsings>true</ImplicitUsings>`,
这个时候你就可以移除你的大部分 `System` 开头的 Using 语句啦, 因为我们是蔚蓝 mod, 所以我们经常也会 Using 以下几个命名空间:

- `Celeste.Mod`: 包含很多 Everest 相关东西
- `Celeste`: 蔚蓝本体所在命名空间
- `Monocle`: 蔚蓝自己的游戏引擎
- `Microsoft.Xna.Framework`: 蔚蓝自己的游戏引擎的底层框架

那么对这些自定义的隐式 Using 我们需要向 `ItemGroup` 加入这些:
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

> 这个是我的个人偏好, 你可以选择直接忽略

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

> 如果你收到警告 `CS8370`, 那你就需要在 `PropertyGroup` 下添加这一行:
> ```xml
> <LangVersion>preview</LangVersion>
> ```

最后修改: 2023-7-7