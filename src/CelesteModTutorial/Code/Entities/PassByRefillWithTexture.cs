using Celeste.Mod.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CelesteModTutorial.Entities;

[Tracked]
[CustomEntity("CelesteModTutorial/PassByRefillWithTexture")]
public class PassByRefillWithTexture : Entity
{
    public int Dashes = 0;

    public PassByRefillWithTexture(Vector2 position, int dashes)
    {
        Position = position;
        Collider = new Hitbox(64f, 64f);
        Dashes = dashes;

        // 获取材质
        MTexture tex = GFX.Game["objects/PassByRefill/pass_by_refill"];

        // 向实体添加 Image 组件
        Image image = new(tex);
        Add(image);
    }

    public PassByRefillWithTexture(EntityData data, Vector2 offset)
        : this(data.Position + offset, data.Int("dashes"))
    { 
    
    }

    public override void Update()
    {
        base.Update();

        // 获取 Player 实例 (别害怕!)
        var player = Scene.Tracker.GetEntity<Player>();

        // 检测是否与玩家碰撞
        if (player is not null && CollideCheck(player))
        {
            // 如果碰撞了, 那么设置它的冲刺数
            player.Dashes = Dashes;
        }
    }
}
