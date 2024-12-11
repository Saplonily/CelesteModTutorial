# Celeste Everest MonoMod

## Celeste

额, 来这里的应该都知道 Celeste 是什么吧((  
后文中提到的 `Celeste`, `蔚蓝` 都会只指 *Celeste* 这个游戏, 也就是我们正在学习的为其制作 mod 的对象.

## Everest

作为一个蔚蓝的 mod 玩家, 安装 Everest 是必不可少的步骤, 因为我们的 mod 依赖于它所提供的制作 mod 中所必须的东西.  
它开源在 [Github](https://github.com/EverestAPI/Everest) 上.  
可能你还听过 Olympus, 它是一个 Everest 的安装器, 也是一个 mod 管理器.

<!--双波浪号删除线嵌在中文里在 mkdocs 中有解析问题... 所以只能使用 del 了-->
如果你还玩过 **Minecraft** 的话我们可以建立一个这样的<del>奇妙</del>关系:

|蔚蓝侧|MC侧|
|-|-|
|Celeste|Minecraft|
|Everest|Forge/Fabric|
|Olympus|PCL2/HCML|

额外地, Everest, Forge, Fabric 这一类东西我们对其有个统称, 叫做 `ModApi`. 就像 Celeste 和 Minecraft 被统称为游戏本体/原版.

## MonoMod

Everest 底层基于 MonoMod, 在这里你只需要知道 Everest 依赖了 MonoMod, 同样地它也是一个开源项目([Github](https://github.com/MonoMod/MonoMod)).
有趣的是, Everest 的主要维护者之一也是 MonoMod 的主要维护者, 同时 MonoMod 也是一些其他游戏的 mod 底层,
比如 Terraria 的 [tModLoader](https://github.com/blushiemagic/tModLoader),
Fez 的 [FEZMod](https://github.com/0x0ade/FEZMod-Legacy) 等等.
