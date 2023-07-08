# 偏好 - sdk-styled csproj

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
- 删除 `Project` 节点下的两个 `Import`
- 删除 `Project` 节点的所有属性
- 重新在 `Project` 节点上加入属性: `Sdk = "Microsoft.NET.Sdk"`
- `TargetFrameworkVersion` 更改为新版的 `TargetFramework`, `v4.5.2` 更改为 `net452`

!!! note
    不用担心删掉这么多东西会出现问题, 实际上我们删掉的东西只是合并入 `Sdk = "Microsoft.NET.Sdk"` 这一句了而已

这个时候整个文件清晰可读:

- 根节点的 `Project` 下挂载着 `PropertyGroup` 以及 `ItemGroup`,
- `PropertyGroup` 描述了我们项目的一些通用属性, 比如输出类型, 命名空间, 程序集昵称以及项目框架版本,
- `ItemGroup` 则描述了我们项目中的一些引用等.

在这里提及这个是因为在后面部分我们会需要修改 `.csproj` 文件,
通过对比你可以发现这两个 xml 文件都有 `PropertyGroup` 和 `ItemGroup` 节点 (如果有多个节点的话, 任意一个都行),
所以我们之后对项目文件的修改的描述都会基于**这两个节点**.

!!! warning
    记得删除 `Properties` 文件夹里的 cs 文件, 它可能会与 sdk-styled csproj 自动生成的文件相冲突