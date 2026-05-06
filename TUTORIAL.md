# Transsion Addons — Proper Porting Tutorial

> This guide explains how to **manually patch your own TranSettings.apk** to add a
> "Transsion Addons" menu. You patch your own APK so it works with your ROM's signing
> key and dex version — no copy-pasting someone else's APK.

---

## Overview of Changes Needed

**In TranSettings.apk** — 4 things to patch:

1. `classes4.dex` — inject 9 new smali classes (the Addons controllers)
2. `res/xml/system_dashboard_fragment.xml` — add the Addons entry to the System settings menu
3. `res/layout/preference_empty_list.xml` — replace with the Addons preference screen layout
4. `classes2.dex` — patch `OsVersionController` for the custom OTA banner feature

**In vendor** — follow the official Laya BatteryMonitor guide (see Part 2)

---

## Tools You Need

- **apktool** — decode/encode APK resources (binary XML ↔ readable XML)
  https://apktool.org/
- **baksmali / smali** — disassemble/reassemble dex files
  https://github.com/JesusFreke/smali/releases
- **signapk** or **apksigner** — re-sign APK with your platform key
- **MIO Kitchen** or any tool to unpack/repack `system_ext.img` and `vendor.img`

---

## Customization — Rename "satya" to Your Own Name

All the system property names and preference keys in this feature contain `satya` (supersatyam's
name) and `kajru` (his nickname). You can and should rename these to your own identifier.

The strings to rename are:

| Original string | What it is | Example replacement |
|---|---|---|
| `persist.sys.satya.addons_enabled` | sysprop | `persist.sys.yourname.addons_enabled` |
| `persist.sys.satya.littlegov` | sysprop | `persist.sys.yourname.littlegov` |
| `persist.sys.satya.biggov` | sysprop | `persist.sys.yourname.biggov` |
| `persist.sys.satya.dfs_active` | sysprop | `persist.sys.yourname.dfs_active` |
| `persist.sys.satya.banner.source` | sysprop | `persist.sys.yourname.banner.source` |
| `persist.sys.satya.banner.enabler` | sysprop | `persist.sys.yourname.banner.enabler` |
| `kajru_addons_enabled` | preference key | `yourname_addons_enabled` |
| `satya_dfs_key` | preference key | `yourname_dfs_key` |
| `os_satya_banner_enabler` | preference key | `os_yourname_banner_enabler` |
| `os_satya_banner_selector` | preference key | `os_yourname_banner_selector` |
| `By Kajru Kashyap` | UI summary text | your own credit |

These appear in:
- The 9 smali files in `smali/classes4/` (replace in the `.smali` files before assembling)
- `OsVersionController.smali` in `smali/classes2/` (banner sysprops)
- The XML blocks in Steps 3 and 4 below

**Important:** wherever you use a string in the smali files, make sure you replace it consistently
everywhere — both the `const-string` lines that define the key and any dependency references in
the XML.

---

## Part 1 — Patch TranSettings.apk

### Step 1: Decode the APK with apktool

```bash
apktool d TranSettings.apk -o TranSettings_patched/
```

---

### Step 2: Inject the new smali classes into classes4

Inside `TranSettings_patched/smali_classes4/`, create the directory:
```
com/android/settings/system/addons/
```

Copy all 9 `.smali` files from the `smali/classes4/com/android/settings/system/addons/`
folder of this package into that directory. These are **brand new files** that don't exist
in any stock TranSettings APK, so it's a straight copy-paste — no conflicts, no merging needed.

> If you want to rename `satya`/`kajru` to your own name, do your find-and-replace
> on these smali files **before** copying them in.

The 9 files are:
- `AddonsDashboardFragment.smali`
- `AddonsController.smali`
- `CPULittleController.smali`
- `CPUBigController.smali`
- `DisableFlagSecureControlller.smali` ← triple L, intentional
- `LayaController.smali`
- `TapRotateListener.smali`
- `CustomBannerEnablerController.smali`
- `TranCustomBannerOTA.smali`

---

### Step 3: Add the Addons entry to the System settings menu

Open:
```
TranSettings_patched/res/xml/system_dashboard_fragment.xml
```

Find this existing block:
```xml
<Preference
    android:title="@string/tran_language_settings"
    android:key="language_and_region_settings"
    android:order="70"
    android:fragment="com.android.settings.language.LanguageAndRegionSettings"
    settings:controller="com.android.settings.language.LanguageAndRegionPreferenceController"/>
```

Add the following **immediately after** it (before `<PreferenceCategory android:order="90"/>`):

```xml
<PreferenceCategory
    android:title="Addons"
    android:order="80">
    <Preference
        android:title="Addons"
        android:key="addons_screen"
        android:summary="By Your Name Here"
        android:fragment="com.android.settings.system.addons.AddonsDashboardFragment"/>
</PreferenceCategory>
```

---

### Step 4: Replace `preference_empty_list.xml` with the Addons screen layout

Open:
```
TranSettings_patched/res/layout/preference_empty_list.xml
```

Replace the **entire file content** with:

```xml
<?xml version="1.0" encoding="utf-8"?>
<PreferenceScreen xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:settings="http://schemas.android.com/apk/res-auto"
    android:title="Transsion Addons"
    android:key="addons_screen">

    <PreferenceCategory android:key="addons_enabler">
        <SwitchPreference
            android:title="Enable Addons"
            android:key="kajru_addons_enabled"
            android:defaultValue="false"
            settings:controller="com.android.settings.system.addons.AddonsController"/>
    </PreferenceCategory>

    <PreferenceCategory
        android:title="Kernel Manager"
        android:key="addons_category_kernel"
        android:dependency="kajru_addons_enabled">
        <ListPreference
            android:title="CPU Little Governor"
            android:key="cpu_little_gov"
            settings:controller="com.android.settings.system.addons.CPULittleController"/>
        <ListPreference
            android:title="CPU Big Governor"
            android:key="cpu_big_gov"
            settings:controller="com.android.settings.system.addons.CPUBigController"/>
    </PreferenceCategory>

    <PreferenceCategory
        android:title="Miscellaneous"
        android:key="addons_category_misc"
        android:dependency="kajru_addons_enabled">
        <SwitchPreference
            android:title="Disable Flag Secure"
            android:key="satya_dfs_key"
            android:summary="Allow screenshot and screen recordings in protected apps."
            settings:controller="com.android.settings.system.addons.DisableFlagSecureControlller"/>
        <SwitchPreference
            android:title="Laya Battmon"
            android:key="laya_addon_enabled"
            settings:controller="com.android.settings.system.addons.LayaController"/>
        <SwitchPreference
            android:title="Disable Tap to Rotate"
            android:key="disable_tap_rotate"
            android:summary="Hide the manual rotation button on the navigation bar."
            settings:controller="com.android.settings.system.addons.TapRotateListener"/>
        <SwitchPreference
            android:title="Use Custom OTA Banner"
            android:key="os_satya_banner_enabler"
            android:summary="Use your own image as the OTA banner card."
            settings:controller="com.android.settings.system.addons.CustomBannerEnablerController"/>
        <Preference
            android:title="Select custom image now"
            android:key="os_satya_banner_selector"
            android:dependency="os_satya_banner_enabler"
            settings:controller="com.android.settings.system.addons.TranCustomBannerOTA"/>
    </PreferenceCategory>

</PreferenceScreen>
```

> Replace `kajru_addons_enabled`, `satya_dfs_key`, `os_satya_banner_enabler`,
> `os_satya_banner_selector` with your custom names if you renamed them in Step 2.
> Keep the `dependency` attributes consistent with your renamed keys.

> **Why `preference_empty_list`?**
> supersatyam reused this existing resource ID as the container for the Addons screen.
> `AddonsDashboardFragment.getPreferenceScreenResId()` returns `R.layout.preference_empty_list`,
> so the system loads this XML as the Addons screen without needing a new resource ID.

---

### Step 5: Patch `OsVersionController.smali` in classes2 — custom OTA banner support

This patch makes the OTA banner card on the About Phone screen load your custom `banner.png`
when `persist.sys.satya.banner.source=custom` is set.

> **Important — do NOT blindly copy-paste this file.**
> Unlike the 9 addons classes in Step 2, `OsVersionController.smali` already exists in your
> APK. Your version may differ from supersatyam's depending on your ROM's base. Replacing it
> wholesale could break About Phone or cause a crash if the rest of the class differs.
>
> The provided file in `smali/classes2/` is there as a reference only. You should instead
> **add just the banner block** to your own `OsVersionController.smali`.

**How to do it safely:**

1. Open your own decoded file:
   ```
   TranSettings_patched/smali_classes2/com/transsion/settings/deviceinfo/aboutphone/OsVersionController.smali
   ```

2. Find the method that handles the OTA card display. Look for a `.registers` line followed
   shortly by a reference to an `ImageView` field named `mCardBackground`. The method will
   have a label like `:cond_XX` somewhere after the image-loading logic.

3. Before that final `:cond_XX` label in that method, insert this block:

   ```smali
       const-string v5, "persist.sys.satya.banner.source"
       const-string v6, "wallpaper"
       invoke-static {v5, v6}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
       move-result-object v5
       const-string v6, "custom"
       invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
       move-result v5
       if-eqz v5, :cond_custom_end
       new-instance v5, Ljava/io/File;
       iget-object v6, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;
       invoke-virtual {v6}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
       move-result-object v6
       const-string v7, "banner.png"
       invoke-direct {v5, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
       invoke-virtual {v5}, Ljava/io/File;->exists()Z
       move-result v6
       if-eqz v6, :cond_custom_end
       invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
       move-result-object v5
       invoke-static {v5}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;
       move-result-object v5
       iget-object v6, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mCardBackground:Landroid/widget/ImageView;
       invoke-virtual {v6, v5}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V
       const/high16 v7, 0x41200000
       const/high16 v8, 0x41200000
       sget-object v9, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;
       invoke-static {v7, v8, v9}, Landroid/graphics/RenderEffect;->createBlurEffect(FFLandroid/graphics/Shader$TileMode;)Landroid/graphics/RenderEffect;
       move-result-object v7
       invoke-virtual {v6, v7}, Landroid/widget/ImageView;->setRenderEffect(Landroid/graphics/RenderEffect;)V
       sget-object v7, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
       invoke-virtual {v6, v7}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
       :cond_custom_end
   ```

4. Bump `.registers` by 5 (e.g. `.registers 7` → `.registers 12`) to accommodate the new
   local registers `v5`–`v9` used in the block.

5. If you renamed `satya` to your own name, replace `persist.sys.satya.banner.source` and
   `persist.sys.satya.banner.enabler` accordingly in the inserted block.

> The reference file in `smali/classes2/` shows exactly where this block sits in context
> if you want to compare it against your own version.

---

### Step 6: Rebuild the APK

```bash
apktool b TranSettings_patched/ -o TranSettings_new.apk
```

---

### Step 7: Re-sign with your platform key

```bash
java -jar signapk.jar platform.x509.pem platform.pk8 TranSettings_new.apk TranSettings_signed.apk
```

> You **must** sign with your ROM's platform key. TranSettings lives in `priv-app` and Android
> checks the signature against the platform cert at load time.

---

### Step 8: Place in your ROM and repack

Replace:
```
system_ext/priv-app/TranSettings/TranSettings.apk
```

Delete the `oat/` folder (since you rebuilt the APK, the old odex/vdex is stale):
```
system_ext/priv-app/TranSettings/oat/   ← delete this
```

The system regenerates it on first boot. Repack `system_ext.img` in MIO Kitchen.

---

## Part 2 — Laya BatteryMonitor (vendor side)

Follow the official guide at:

> **https://github.com/Laynsb/Laya-BatteryMonitor**

The `guide.txt` in that repo covers everything — binary placement, init script, and SELinux rules.
Download the latest release binary from the Releases page.

The `LayaController.smali` included in this package toggles Laya via the
`debug.laya.battmon_enabled` property, which matches exactly what Laya uses — so no extra
wiring is needed on the Settings side once Laya is integrated in vendor.

---

## Troubleshooting

**Settings crashes when opening Transsion Addons:**
Check logcat: `adb logcat | grep AndroidRuntime`
Usually means smali classes weren't assembled correctly or a key name mismatch between smali and XML.

**Addons menu doesn't appear in System settings:**
The `system_dashboard_fragment.xml` edit wasn't applied. Verify and rebuild.

**Laya toggle does nothing:**
Laya isn't integrated in your vendor yet. Follow the Laya guide first.

**CPU Governor picker is empty:**
Your device's sysfs paths may differ. Check: `adb shell ls /sys/devices/system/cpu/cpufreq/`
The smali uses `policy0` (little cluster) and `policy6` (big cluster). Update the paths in
`CPULittleController.smali` and `CPUBigController.smali` if needed.

**Custom OTA banner doesn't show:**
Verify `persist.sys.satya.banner.source=custom` (or your renamed property) and that
`data/data/com.android.settings/files/banner.png` exists (the image picker in Addons saves it there).

---

## Credits

- **supersatyam** — original Transsion Addons implementation
- **Laynsb (@Laynsb on Telegram)** — Laya BatteryMonitor (https://github.com/Laynsb/Laya-BatteryMonitor)
- **@kaminarich** — inspiration for Laya (battery honey developer)
