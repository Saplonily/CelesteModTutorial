
namespace MyCelesteMod;

public class MyCelesteModModule : EverestModule
{
    public static MyCelesteModModule Instance { get; private set; }

    public override Type SettingsType => typeof(MyCelesteModSettings);
    public static MyCelesteModSettings Settings => (MyCelesteModSettings)Instance._Settings;

    public override Type SessionType => typeof(MyCelesteModSession);
    public static MyCelesteModSession Session => (MyCelesteModSession)Instance._Session;

    public override Type SaveDataType => typeof(MyCelesteModSaveData);
    public static MyCelesteModSaveData SaveData => (MyCelesteModSaveData)Instance._SaveData;


    public override void Load()
    {
        Instance = this;

        Logger.Log(LogLevel.Info, "MyCelesteMod", "MyCelesteMod successful loaded!");
    }

    public override void Unload()
    {
    }
}