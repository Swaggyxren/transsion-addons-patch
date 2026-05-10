# TranSettings — Transsion Addons Patch

This repo shows exactly how to patch your own `TranSettings.apk` to add the **Transsion Addons** menu (CPU Governor, GPU Governor, Bypass Charging, Thermal Disable, Disable Flag Secure, Laya Battmon, Disable Tap to Rotate, Custom OTA Banner).

> **Tested on Android 16 (TranssionOS — HiOS16 & XOS16).** Other TranssionOS16 ROMs should be able to apply this patch as well. The OTA banner patch (Step 4 in README / Step 5 in TUTORIAL) may differ per device — if yours doesn't match, you can ask AI (e.g. ChatGPT) how to patch your specific `OsVersionController.smali`.

## How to use this repo

**Look at the commit history.** There are two commits:

1. **`base: stock xos16 TranSettings files`** — the unmodified decompiled files
2. **`patch: add Transsion Addons`** — the actual changes

Open the second commit diff on GitHub to see line-by-line exactly what was added, changed, or replaced. Apply the same changes to your own decompiled `TranSettings.apk`.

## Files included

Only the files that are actually modified are included — not the full decompiled APK.

```
TranSettings/
  smali_classes2/com/transsion/settings/deviceinfo/aboutphone/
    OsVersionController.smali          ← patched for custom OTA banner
  smali_classes4/com/android/settings/system/addons/
    AddonsDashboardFragment.smali      ← new (copy-paste)
    AddonsController.smali             ← new (copy-paste)
    CPULittleController.smali          ← new (copy-paste)
    CPUBigController.smali             ← new (copy-paste)
    GPUGovernorController.smali        ← new (copy-paste)
    BypassChargingController.smali     ← new (copy-paste)
    BypassDisconnectReceiver.smali     ← new (copy-paste)
    ThermalDisableController.smali     ← new (copy-paste)
    DisableFlagSecureControlller.smali ← new (copy-paste)
    LayaController.smali               ← new (copy-paste)
    TapRotateListener.smali            ← new (copy-paste)
    CustomBannerEnablerController.smali← new (copy-paste)
    TranCustomBannerOTA.smali          ← new (copy-paste)
  res/xml/
    system_dashboard_fragment.xml      ← add Addons menu entry
  res/layout/
    preference_empty_list.xml          ← replaced with Addons screen layout
```

## Steps

1. Decode your `TranSettings.apk` with [APKTool M](https://apktool-m.en.uptodown.com/android) on your phone
2. Apply the changes shown in the patch commit to your decompiled output
3. For the 13 files in `smali_classes4/com/android/settings/system/addons/` — pure copy-paste, they don't exist in stock
4. For `OsVersionController.smali` — do **not** replace it wholesale, insert only the banner block shown in the diff into your own version
5. Rebuild with APKTool M
6. Delete the `oat/` folder alongside the APK in your ROM (system regenerates it on first boot)

## Renaming "satya" / "kajru"

The sysprops (`persist.sys.satya.*`) and preference keys (`kajru_addons_enabled`, `satya_dfs_key`, etc.) are satyam's identifiers. You can rename them to your own — just do a consistent find-and-replace across all smali files and the XMLs before rebuilding.

## Laya BatteryMonitor (vendor side)

The `LayaController.smali` toggles Laya via `debug.laya.battmon_enabled`. For it to actually work, Laya must be integrated in your vendor. Follow the official guide:
**https://github.com/Laynsb/Laya-BatteryMonitor**

## Credits

- **@satyam_rai1** — Transsion Addons rebuild
- **Layns** — https://github.com/Laynsb
