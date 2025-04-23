# 简单贴图

嗯... 那么到这一章我们该给我们实体上点贴图了, 以及还有 Loenn 侧的贴图, 那么结束这一章后你应该会觉得我们的实体是个"像样"的实体了.  
这里我们会使用这个 64x64 的**超级丑陋**的贴图:  

<figure markdown>
  ![FuckingUglyTexture](images/simple_texturing/fucking_ugly_texture.png){ width=150 }
  <figcaption>啊它真的太丑陋了</figcaption>
</figure>

你可以在这里下载它: [fucking_ugly_texture.png](images/simple_texturing/fucking_ugly_texture.png)


## 禁止我们的实体缩放

在这里我们的贴图是正方形的, 所以这里为了方便起见暂时让我们的实体不能缩放,
那么在代码这边的表现就是直接删去与 Size 有关的东西并将碰撞箱硬编码成 64x64 大小:

=== "After"
    ```cs title="PassByRefill.cs"
    public PassByRefill(Vector2 position, int dashes)
    {
        Dashes = dashes;
        Position = position;
        Hitbox hitbox = new(64, 64);
        Collider = hitbox;
    }

    public PassByRefill(EntityData data, Vector2 offset)
        : this(data.Position + offset, data.Int("dashes"))
    {

    }
    ```
=== "Before"
    ```cs title="PassByRefill.cs"
    public PassByRefill(Vector2 position, Vector2 size, int dashes)
    {
        Dashes = dashes;
        Position = position;
        Hitbox hitbox = new(size.X, size.Y);
        Collider = hitbox;
    }

    public PassByRefill(EntityData data, Vector2 offset)
        : this(data.Position + offset, new Vector2(data.Width, data.Height), data.Int("dashes"))
    { 

    }
    ```

!!! info
    在 Loenn 那边我们待会再说, 如果你现在就删除 width 和 height 属性的话你会发现你放置不了这个实体

## 贴图以及 Monocle.Image

### 蔚蓝侧

ok 那么现在我们该在代码这边来点贴图了, 这里我们会用到之前提到的 `Component` 的概念及对应的一个新的类 `Monocle.Image`, 它的作用就是绘制贴图.  
首先我们得让游戏找到并加载到我们的贴图, 这一步很简单并类似, 只需要套几层文件夹:

- ModFolder
    - Graphics
        - Atlases
            - Gameplay
                - objects
                    - PassByRefill
                        - pass_by_refill.png

`pass_by_refill.png` 即我们的贴图, 如果你同时也是一位 mapper 的话你一定很熟悉这个文件夹套套乐!  
在代码这边, 我们使用 `GFX.Game["objects/PassByRefill/pass_by_refill"]` 来获取这个贴图, 它是一个 `MTexture` 类型的实例, 在获取到这个贴图后,
我们 `new` 一个 `Monocle.Image`, 然后在构造函数中传入它, 然后使用 `this.Add` 函数挂载到我们的这个实体上, 总的代码应该是这样的:
```cs title="PassByRefill.cs"
public PassByRefill(Vector2 position, int dashes)
{
    Dashes = dashes;
    Position = position;
    Hitbox hitbox = new(64, 64);
    Collider = hitbox;

    MTexture tex = GFX.Game["objects/PassByRefill/pass_by_refill"];
    Image image = new(tex);
    this.Add(image);
}
```

!!! info
    `GFX` 是蔚蓝中的一个管理贴图的类, 我们用它获取到一个贴图组 `Game`, 然后向它检索一个名为 `objects/PassByRefill/pass_by_refill` 的贴图, 你可能会疑惑为什么这里的路径只需要后半部分,
    
    这是因为 `GFX.Game` 只会检索 `Graphics/Atlases/Gameplay` 中的内容.  
    同样的, `GFX.Portraits` 只会检索 `Graphics/Atlases/Portraits` 中的内容.

顺便记得删掉我们重写的 `Render` 函数, 我们不再需要它了. 总的类应该是这样的:
```cs title="PassByRefill.cs"
[CustomEntity("MyCelesteMod/PassByRefill")]
[Tracked]
public class PassByRefill : Entity
{
    public int Dashes = 0;

    public PassByRefill(Vector2 position, int dashes)
    {
        Dashes = dashes;
        Position = position;
        Hitbox hitbox = new(64, 64);
        Collider = hitbox;

        MTexture tex = GFX.Game["objects/PassByRefill/pass_by_refill"];
        Image image = new(tex);
        this.Add(image);
    }

    public PassByRefill(EntityData data, Vector2 offset)
        : this(data.Position + offset, data.Int("dashes"))
    {

    }

    public override void Update()
    {
        base.Update();
        var player = Scene.Tracker.GetEntity<Player>();
        if (player is not null && this.CollideCheck(player))
        {
            player.Dashes = this.Dashes;
        }
    }
}
```

### Loenn 侧

在 Loenn 侧这边也非常简单, 首先我们先大胆的删掉 width 和 height 属性:

=== "After"
    ```lua title="PassByRefill.lua"
    local entity = {}

    entity.name = "MyCelesteMod/PassByRefill"
    entity.placements = {
        name = "normal",
        data = {
            dashes = 2
        }
    }

    entity.fieldInformation = 
    {
        dashes = {
            fieldType = "integer"
        }
    }

    return entity
    ```
=== "Before"
    ```lua title="PassByRefill.lua"
    local entity = {}

    entity.name = "MyCelesteMod/PassByRefill"
    entity.placements = {
        name = "normal",
        data = {
            width = 16,
            height = 16,
            dashes = 2
        }
    }

    entity.fieldInformation = 
    {
        dashes = {
            fieldType = "integer"
        }
    }

    return entity
    ```

然后设置 entity 的 `texture` 属性, 这会让 Loenn 为其设置贴图:
```lua
entity.texture = "objects/PassByRefill/pass_by_refill"
```
顺便设置贴图原点为左上角, 否则 Loenn 中的显示可能会与实际游戏中的不同:
```lua
entity.justification = { 0.0, 0.0 }
```
这里的路径与我们之前在代码中的类似.  
那么现在总体上看上去应该是这样的:
```lua
local entity = {}

entity.name = "MyCelesteMod/PassByRefill"
entity.placements = {
    name = "normal",
    data = {
        dashes = 2
    }
}

entity.fieldInformation = 
{
    dashes = {
        fieldType = "integer"
    }
}

entity.texture = "objects/PassByRefill/pass_by_refill"
entity.justification = { 0.0, 0.0 }

return entity
```

### 最后

最后编译我们的项目, 打开或者重启 Loenn, 你就会看到我们的实体有着一个不怎么好看的贴图了!  
现在进入到游戏中你也会看到这个不怎么好看的贴图了!