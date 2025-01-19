# Lua

## 前言

制图软件 `Loenn` 使用 `Lua` 作为开发语言. 相应的, 我们想要 `Loenn` 能加载到自定义实体也需要编写 `Lua` 脚本.

这个额外章节将会介绍<del>如何速通 Lua </del>一些编写 `Loenn` 侧自定义实体的加载脚本所必需的 `Lua` 知识.

## 开发环境

这一步实际上是可选的, 不过为了更愉快的 `Lua` 脚本的编写,
个人还是觉得挺有必要的.  
在这里我会推荐使用 [VSCode](https://code.visualstudio.com/Download) 配上 [Lua (sumneko.lua)](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
插件:  
![lua-in-vscode](images/begin/lua_in_vscode.png)

!!! note
    我个人不太会配置这种 lua 环境, 所以如果你遇到了大量的未定义警告你可以选择在设置中搜索 `Lua.diagnostics.enable` 并将其关闭.