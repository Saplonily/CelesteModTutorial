using Celeste.Mod.CelesteModTutorial.Entities;
using Celeste.Mod.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Celeste.Mod.CelesteModTutorial.Triggers;

[CustomEntity("CelesteModTutorial/SetPassByRefillDashesTrigger")]
public class SetPassByRefillDashesTrigger : Trigger
{
    public int Dashes;

    public SetPassByRefillDashesTrigger(EntityData data, Vector2 offset)
        : base(data, offset)
    {
        Dashes = data.Int("dashes");
    }

    public override void OnEnter(Player player)
    {
        base.OnEnter(player);

        // 获取所有的 PassByRefill
        var refills = Scene.Tracker.GetEntities<PassByRefill>().Cast<PassByRefill>();
        foreach (var refill in refills)
        {
            refill.Dashes = Dashes;
        }

        // 获取所有的 PassByRefillWithTexture
        var refillsWithTexture = Scene.Tracker.GetEntities<PassByRefillWithTexture>().Cast<PassByRefillWithTexture>();
        foreach (var refillWithTexture in refillsWithTexture)
        {
            refillWithTexture.Dashes = Dashes;
        }
    }
}
