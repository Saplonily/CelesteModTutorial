using Celeste.Mod.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyCelesteMod.Triggers;

[CustomEntity("MyCelesteMod/SampleTrigger")]
public class SampleTrigger : Trigger
{
    public SampleTrigger(EntityData data, Vector2 offset)
        : base(data, offset)
    {

    }

    public override void Update()
    {
        base.Update();
    }

    public override void OnEnter(Player player)
    {
        base.OnEnter(player);
    }

    public override void OnStay(Player player)
    {
        base.OnStay(player);
    }

    public override void OnLeave(Player player)
    {
        base.OnLeave(player); 
    }

}
