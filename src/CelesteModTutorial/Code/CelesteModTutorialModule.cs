using MonoMod.ModInterop;
using System.Reflection;

namespace CelesteModTutorial;

public class CelesteModTutorialModule : EverestModule
{
    public static CelesteModTutorialModule Instance { get; private set; }

    public override Type SettingsType => typeof(CelesteModTutorialSettings);
    public static CelesteModTutorialSettings Settings => (CelesteModTutorialSettings)Instance._Settings;

    public override Type SessionType => typeof(CelesteModTutorialSession);
    public static CelesteModTutorialSession Session => (CelesteModTutorialSession)Instance._Session;

    public override Type SaveDataType => typeof(CelesteModTutorialSaveData);
    public static CelesteModTutorialSaveData SaveData => (CelesteModTutorialSaveData)Instance._SaveData;



    public override void LoadContent(bool firstLoad)
    {
        base.LoadContent(firstLoad);
    }

    public override void Load()
    {
        Instance = this;
    }

    public override void Unload()
    {

    }
}