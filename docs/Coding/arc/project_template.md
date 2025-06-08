!!! info
    在蔚蓝国外社区流行着另一个 mod 项目模板, 不过我个人不太喜欢它, 不过你需要的话[这是 Github 主页](https://github.com/EverestAPI/CelesteModTemplate)
    所以这里主要使用我个人制作也是个人最常用的一个.  

\_(:з」∠)\_  
根据一些反馈我们发现旧的手动配置环境的方式非常的复杂难操作(  
所以呢这里就推荐一种新的配置环境的方式 - **使用模板**  
考虑到 nuget 安装模板也需要一定的命令行基础...  
所以这里考虑[提供直接的下载链接](https://hongshitieli.lanzouj.com/iJfRz1l0iffg),
或者你也可以选择使用 `dotnet cli` 从 nuget 上的模板安装:

!!! note
    你可能还需要安装 `.NET 8 SDK` 来使用该模板, 你可以[在这里](https://get.dot.net)找到它

??? info "使用 dotnet cli 从模板新建项目"
    首先在一个你喜欢的位置放置你的项目文件夹, 名字即为你的项目名, 例如 `MyCelesteMod`:
    ```bat
    mkdir MyCelesteMod
    cd MyCelesteMod
    ```
    然后在此位置安装 nuget 上我的 mod 模板(如果你没有安装的话):
    ```bat
    dotnet new install Saladim.CelesteModTemplate
    ```
    然后你就能使用这条指令直接创建项目了:
    ```bat
    dotnet new sapcelestemode
    ```
    名字即为上层文件夹名, 或者你可以使用 `-n` 参数重写项目名字:
    ```bat
    dotnet new sapcelestemod -n MySuperCelesteMod
    ```
    模板目前默认不会创建针对 Everest Core 的 Code Mod, 如果你需要的话你可以传入 `--core-only true` 参数:
    ```bat
    dotnet new sapcelestemod --core-only true
    ```

完成后使用你喜欢的编辑器打开项目(对于 vs 直接打开 .csproj 文件), 那么按理来说你会看到这几个文件:

- CelesteMod.props
- CelesteMod.targets
- Common.props
- MyCelesteModModule.cs
- MyCelesteMod.csproj
    
以及你的项目, 它的名字是 `MyCelesteMod`, 不同于旧的方法, 在这里你的配置过程很简单:

- 首先打开 `Common.props`, **将里面的 `CelesteRootPath` 内的内容改成你的蔚蓝安装位置**

```xml hl_lines="3"
<Project>
    <PropertyGroup>
        <CelesteRootPath>C:\Program Files (x86)\Steam\steamapps\common\Celeste</CelesteRootPath>
        <CommonCelesteUsings>true</CommonCelesteUsings>
        <CommonCelesteReferences>true</CommonCelesteReferences>
        <ModAssetsFolderName>ModFolder</ModAssetsFolderName>
    </PropertyGroup>
</Project>
```

现在你可以按下 `Ctrl+B` 或者手动点击 `生成->生成解决方案`,
如果你在你的 vs 输出里面看到了类似这两句:

```
1>MyCelesteMod -> D:\User\temp\cm\bin\x86\Debug\net452\MyCelesteMod.dll
1>MyCelesteMod -> C:/Program Files (x86)/Steam/steamapps/common/Celeste/Mods/MyCelesteMod_copy/MyCelesteMod.dll
```

并且你在你的蔚蓝 Mod 目录下找到了这个被创建的目录,
那么你的环境就算是配完了, 如果你很感兴趣这之中发生了什么, 要引用哪些程序集, 这个模板背后干了什么, 你可以去看那复杂的旧的配置方法.
!!! note
    这个模板使用 `msbuild` 帮助了你很多事!  
    比如当你编译完项目之后它会复制编译结果到项目目录的 `ModFolder` 目录下,
    然后将整个 `ModFolder` 复制到蔚蓝的 `Mods\{你的mod名}_copy` 文件夹下!
    所以当我们需要更改一些比如说 loenn 的配置文件, `everest.yaml` 的内容, 你的测试地图等时, 
    你只需要简单地重新编译一遍项目, 然后等待模板来帮你做剩下的活!  


## 更改细节

通过模板的话依然有些东西需要自行更改, 比如这个 Mod 的名字.  
更改 Mod 的名字很简单, 你只需要简单地在 vs 里重命名项目的名字
比如我想叫做 `MyAwesomeMod`, 那么你可以通过这样:  
![awesome mod!](rename_proj.png)

顺便别忘了把类似 `MyCelesteModModule.cs` 的文件名也改成类似 `MyAwesomeModModule.cs`,
以及改名后清理一下 ModFolder 下面可能有的一些以过去名字命名的 .dll 和 .pdb 文件!  