using Celeste.Mod.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyCelesteMod.Entities;

[CustomEntity("MyCelesteMod/SampleEntity")]
public class SampleEntity : Entity
{
    public SampleEntity(Vector2 posotion, Vector2 size)
        : base(posotion)
    {
        Position = posotion;
        Collider = new Hitbox(size.X, size.Y);
    }

    public SampleEntity(EntityData data, Vector2 offset)
        : this(data.Position + offset, new Vector2(data.Width, data.Height))
    {

    }

    public override void Update()
    {
        base.Update();
    }

    public override void Render()
    {
        base.Render();
    }
}
