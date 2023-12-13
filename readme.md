# 蔚蓝CodeMod教程

个人的一些经验写成的教程, 仅此.  
好像就没啥要说的了(?

## 自行 host

文档网页使用 python 工具 `mkdocs` 构建, 自行 host 很简单:

首先 clone 仓库:

```sh
git clone https://github.com/Saplonily/CelesteModTutorial
```

记得子模块也要拉下来:

```sh
git submodule update --init --recursive
```

安装 `mkdocs` python 工具环境, 如果你还没有的话:

```sh
pip install mkdocs
pip install mkdocs-material
```

开放网页服务:

```sh
mkdocs serve
```

默认开放在 `localhost:8000`.

----

本系列内容依据[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)许可证进行授权