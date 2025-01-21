# Lua

## 前言

制图软件 `Loenn` 使用 `Lua` 作为开发语言. 相应的, 我们想要 `Loenn` 能加载到自定义实体也需要编写 `Lua` 脚本.

这个额外章节将会介绍<del>如何速通 Lua </del>一些编写 `Loenn` 侧自定义实体的加载脚本所必需的 `Lua` 知识.

## 开发环境

### Lua 安装
!!!info
    `Everest` 集成了 `Lua` 环境, 因此实际开发时无需再次安装 `Lua`. 以下步骤仅用于学习或自定义开发时的 `Lua` 环境安装.

!!!info
    这部分介绍的是 Windows 系统下的 `Lua` 安装, Linux 系统用户请直接访问 [Lua Download](https://www.lua.org/download.html) 下载并安装.

我们可以通过命令行工具 `winget` 安装 `Lua`:
```bat
winget install DEVCOM.Lua
```
安装完成后, 我们可以通过以下命令检查 `Lua` 是否安装成功:
```bat
lua -v
```

如果命令行输出以下错误信息我们需要手动添加 `Lua` 的安装目录至环境变量:
```bat
lua : 无法将“lua”项识别为 cmdlet、函数、脚本文件或可运行程序的名称。请检查名称的拼写，如果包括路径，请确保路径正确，
然后再试一次。
```

默认情况下, `winget` 会将 `Lua` 安装至 `C:\Users\你的用户名\AppData\Local\Programs\Lua\bin`, 这里需要根据你的用户名更改路径, 例如 `C:\Users\AppleSheep\AppData\Local\Programs\Lua\bin`.             

随后在命令行输入以下命令将 `Lua` 安装目录添加至系统环境变量中:
```bat
setx PATH "$env:PATH;C:\Users\AppleSheep\AppData\Local\Programs\Lua\bin"
```

完成后我们可以再次检查 `Lua` 是否安装成功:
```bat
lua -v
```

安装成功会输出:
```bat
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
```

### Visual Studio Code 配置
这一步实际上是可选的, 不过为了更愉快的 `Lua` 脚本的编写,
个人还是觉得挺有必要的.  
在这里我会推荐使用 [Visual Studio Code](https://code.visualstudio.com/Download) 配上 [Lua (sumneko.lua)](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
插件:  
![lua-in-vscode](images/begin/lua_in_vscode.png)

!!! note
    个人不太会配置这种 lua 环境, 所以如果你遇到了大量的未定义警告你可以选择在设置中搜索 `Lua.diagnostics.enable` 并将其关闭.

此外, Lua (sumneko.lua) 插件并不支持 `Lua` 的调试. 个人推荐安装 [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) 插件.

安装完成后我们在右键菜单内点击 `Run Code` 即可运行 `Lua` 脚本:

![vs_code_runner](images/begin/vs_code_runner.png)

运行结果将显示在输出窗口：

![vs_lua_output](images/begin/vs_lua_output.png)