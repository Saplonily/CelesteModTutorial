# 蔚蓝 Code Mod 教程

个人的一些经验写成的教程, 仅此.  
好像就没啥要说的了(?  
目前 host 在两个位置:

https://saplonily.top/celeste_mod_tutorial  
https://sapcelestemod.netlify.app  

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

此外还有插件:

```sh
pip install mkdocs-git-revision-date-localized-plugin
pip install mkdocs-git-authors-plugin
```

开放网页服务:

```sh
mkdocs serve
```

你可以先注释掉 `mkdocs.yml` 中约第 10 行的 `plugins` 的所有项来加快本地的生成,
因为它会在每次生成时读取整个 git 历史来生成更新时间, 修改时间以及作者.

默认开放在 `localhost:8000`.

----

本系列内容依据 [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) 许可证进行授权
