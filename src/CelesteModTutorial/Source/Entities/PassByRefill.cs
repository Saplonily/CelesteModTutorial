using Celeste.Mod.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Celeste.Mod.CelesteModTutorial.Entities;

[Tracked]
[CustomEntity("CelesteModTutorial/PassByRefill")]
public class PassByRefill : Entity
{
    public int Dashes = 0;

    public PassByRefill(Vector2 position, Vector2 size, int dashes)
    {
        Position = position;
        Collider = new Hitbox(64f, 64f);
        Dashes = dashes;
    }

    public PassByRefill(EntityData data, Vector2 offset)
        : this(data.Position + offset, new Vector2(data.Width, data.Height), data.Int("dashes"))
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

    public override void Render()
    {
        base.Render();

        Color c = Color.Red;
        c.A = 127;
        Draw.Rect(Position, Width, Height, c);
    }
}
