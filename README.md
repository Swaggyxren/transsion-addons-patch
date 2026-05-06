# TranSettings — Transsion Addons Patch

This repo shows exactly how to patch your own `TranSettings.apk` to add the **Transsion Addons** menu (CPU Governor, Disable Flag Secure, Laya Battmon, Disable Tap to Rotate, Custom OTA Banner).

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

1. Decompile your `TranSettings.apk` with apktool:
   ```
   apktool d TranSettings.apk -o TranSettings_patched/
   ```
2. Apply the changes shown in the patch commit to your decompiled output
3. For the 9 files in `smali_classes4/com/android/settings/system/addons/` — pure copy-paste, they don't exist in stock
4. For `OsVersionController.smali` — do **not** replace it wholesale, insert only the banner block shown in the diff into your own version
5. Rebuild and re-sign with your platform key:
   ```
   apktool b TranSettings_patched/ -o TranSettings_new.apk
   java -jar signapk.jar platform.x509.pem platform.pk8 TranSettings_new.apk TranSettings_signed.apk
   ```
6. Delete the `oat/` folder alongside the APK in your ROM (system regenerates it on first boot)

## Renaming "satya" / "kajru"

The sysprops (`persist.sys.satya.*`) and preference keys (`kajru_addons_enabled`, `satya_dfs_key`, etc.) are satyam's identifiers. You can rename them to your own — just do a consistent find-and-replace across all smali files and the XMLs before rebuilding.

## Laya BatteryMonitor (vendor side)

The `LayaController.smali` toggles Laya via `debug.laya.battmon_enabled`. For it to actually work, Laya must be integrated in your vendor. Follow the official guide:
**https://github.com/Laynsb/Laya-BatteryMonitor**

## Credits

- **supersatyam** — original Transsion Addons implementation
- **Laynsb** — Laya BatteryMonitor (https://github.com/Laynsb/Laya-BatteryMonitor)
- **@kaminarich** — inspiration for Laya
