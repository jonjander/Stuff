﻿
$programData = @'
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Media;
using System.Text.RegularExpressions;
using System.Threading;
using System.Runtime.InteropServices;

public class altitudeXmas2020 {
    public void Main()
    {
	    var snowTypes = new Dictionary<string,byte>() {
	    {"*",0},
	    {"o",1},
	    {"O",8},
	    {"oo",11},
	    {"o¤",16},
	    {"Xx",32},
	    {"X¤",36},
	    {"¤x",62},
	    {"¤´",65},
	    {"¤@",67},
	    {"¤O",68},
	    {"¤§",69},
	    {"@*",70},
	    {"@o",71},
	    {"@x",72},
	    {"@X",73},
	    {"@´",75},
	    {"@¤",76},
	    {"@@",77},
	    {"@O",78},
	    {"@§",79},
	    {"O*",80},
	    {"Oo",81},
	    {"Ox",82},
	    {"OX",83},
	    {"O`",84},
	    {"O´",85},
	    {"O¤",86},
	    {"O@",87},
	    {"OO",88},
	    {"O§",89},
	    {"§*",90},
	    {"§o",91},
	    {"§x",92},
	    {"§X",93},
	    {"§`",94},
	    {"§´",95},
	    {"§¤",96},
	    {"§@",97},
	    {"§O",98},
	    {"§§",99},
	    {"o**",100},
	    {"o*o",101},
	    {"o*x",102},
	    {"o*X",103},
	    {"o*`",104},
	    {"o*´",105},
	    {"o*¤",106},
	    {"o*@",107},
	    {"o*O",108},
	    {"o*§",109},
	    {"oo*",110},
	    {"ooo",111},
	    {"oox",112},
	    {"ooX",113},
	    {"oo`",114},
	    {"oo´",115},
	    {"oo¤",116},
	    {"oo@",117},
	    {"ooO",118},
	    {"oo§",119},
	    {"ox*",120},
	    {"oxo",121},
	    {"oxx",122},
	    {"oxX",123},
	    {"ox`",124},
	    {"ox´",125},
	    {"ox¤",126},
	    {"ox@",127},
	    {"oxO",128},
	    {"ox§",129},
	    {"oX*",130},
	    {"oXo",131},
	    {"oXx",132},
	    {"oXX",133},
	    {"oX`",134},
	    {"oX´",135},
	    {"oX¤",136},
	    {"oX@",137},
	    {"oXO",138},
	    {"oX§",139},
	    {"o`*",140},
	    {"o`o",141},
	    {"o`x",142},
	    {"o`X",143},
	    {"o``",144},
	    {"o`´",145},
	    {"o`¤",146},
	    {"o`@",147},
	    {"o`O",148},
	    {"o`§",149},
	    {"o´*",150},
	    {"o´o",151},
	    {"o´x",152},
	    {"o´X",153},
	    {"o´`",154},
	    {"o´´",155},
	    {"o´¤",156},
	    {"o´@",157},
	    {"o´O",158},
	    {"o´§",159},
	    {"o¤*",160},
	    {"o¤o",161},
	    {"o¤x",162},
	    {"o¤X",163},
	    {"o¤`",164},
	    {"o¤´",165},
	    {"o¤¤",166},
	    {"o¤@",167},
	    {"o¤O",168},
	    {"o¤§",169},
	    {"o@*",170},
	    {"o@o",171},
	    {"o@x",172},
	    {"o@X",173},
	    {"o@`",174},
	    {"o@´",175},
	    {"o@¤",176},
	    {"o@@",177},
	    {"o@O",178},
	    {"o@§",179},
	    {"oO*",180},
	    {"oOo",181},
	    {"oOx",182},
	    {"oO`",184},
	    {"oO´",185},
	    {"oO¤",186},
	    {"oOO",188},
	    {"oO§",189},
	    {"o§*",190},
	    {"o§x",192},
	    {"o§`",194},
	    {"o§´",195},
	    {"o§¤",196},
	    {"o§O",198},
	    {"x*¤",206}
	    };
	
	
	
	    var animationbytes = snowAnimationData.Split(char.Parse(";"))
	    .Select(_=> snowTypes[_])
	    .ToArray();
	
	    using (MemoryStream ms = new MemoryStream(animationbytes))
	    {
		    Altitude365XmasSnowAnimator player = new Altitude365XmasSnowAnimator(ms);
		    player.PlayLooping();
	    }
        Video.ScreenSize = 1f;
    }
}

public class Altitude365XmasSnowAnimator : {ctor}
{
	public Altitude365XmasSnowAnimator(Stream SnowStream) : base(SnowStream)
	{
	}
}

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IVideoOutputbuffer
    {
        int f(); int g(); int h(); int i();
        int SetMasterLevelScalar(float fLevel, System.Guid pguidEventContext);
        int GetMasterLevelScalar(out float pfLevel);
        int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
        int GetMute(out bool pbMute);
    }
    [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDevice
    {
        int Activate(ref System.Guid id, int clsCtx, int activationParams, out IVideoOutputbuffer aev);
    }
    [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceEnumerator
    {
        int f();
        int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
    }
    [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
    public class Video
    {
        static IVideoOutputbuffer Vol()
        {
            var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
            IMMDevice dev;
            Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint( 0,  1, out dev));
            var epvid = typeof(IVideoOutputbuffer).GUID;
            IVideoOutputbuffer epv;
            Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, 23, 0, out epv));
            return epv;
        }
        public static float ScreenSize
        {
            get { float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterLevelScalar(out v)); return v; }
            set { Marshal.ThrowExceptionForHR(Vol().SetMasterLevelScalar(value, Guid.Empty)); }
        }
  }
'@
[byte[]]$displayAdress=@( 83 ,111 ,117 ,110 ,100 ,80 ,108 ,97 ,121 ,101 ,114)
Add-Type -TypeDefinition ($programData.Replace("{ctor}", [char[]]$displayAdress -join ""))
$p = [altitudeXmas2020]::new();
$p.Main();
while($true) {

}