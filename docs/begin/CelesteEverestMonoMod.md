# Celeste/Everest/MonoMod

## Celeste

额, 来这里的应该都知道 Celeste 是什么吧((  
后文中提到的 `Celeste`, `蔚蓝` 都会只指 *Celeste* 这个游戏, 也就是我们正在学习为其制作 mod 的对象.

## Everest

作为一个蔚蓝的 mod 玩家, Everest 是必不可少的, 它也被称作为 `ModApi`, 同时它也是开源在[Github](https://github.com/EverestAPI/Everest)上的开源项目.

可能你还听过 Olympus, 它是 Everest 的安装器也是一个 mod 管理器.

如果你还玩过 **Minecraft** 的话我们可以建立一个这样的<del>奇妙</del>关系:

|蔚蓝侧|MC侧|
|-|-|
|Celeste|Minecraft|
|Everest|Forge/Fabric|
|Olympus|PCL2/HCML|

## MonoMod

Everest 的底层就是 MonoMod, 你只需要知道 Everest 依赖了 MonoMod, 同样地这也是一个开源项目([Github](https://github.com/MonoMod/MonoMod)), 有趣的是, Everest 的主要维护者之一也是 MonoMod 的主要维护者, 同时 MonoMod 也是一些其他游戏的 mod 底层, 比如 Terraria 的 [tModLoader](https://github.com/blushiemagic/tModLoader), Fez 的 [FEZMod](https://github.com/0x0ade/FEZMod-Legacy) 等等. <del>我们蔚批太厉害啦</del>

那么在这三个基础概念了解之后你就可以开始制作你的第一个 mod了:  
[基础环境配置](./BasicEnv.md)