namespace Celeste.Mod.CelesteModTutorial;

public sealed class CelesteModTutorialModule : EverestModule
{
    public static CelesteModTutorialModule Instance { get; private set; }

    public override Type SettingsType => typeof(CelesteModTutorialSettings);
    public static CelesteModTutorialSettings Settings => (CelesteModTutorialSettings)Instance._Settings;

    public override Type SessionType => typeof(CelesteModTutorialSession);
    public static CelesteModTutorialSession Session => (CelesteModTutorialSession)Instance._Session;

    public override Type SaveDataType => typeof(CelesteModTutorialSaveData);
    public static CelesteModTutorialSaveData SaveData => (CelesteModTutorialSaveData)Instance._SaveData;

    public override void Load()
    {
        Instance = this;

        Logger.Log(LogLevel.Info, "CelesteModTutorial", "Hello, Celeste!");
    }

    public override void Unload()
    {
    }
}