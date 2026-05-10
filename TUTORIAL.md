# Transsion Addons — Porting Tutorial (Updated, Battle-Tested)

> **satyam** originally built this feature for XOS16. This guide is an
> updated, debugged port covering CPU little/big governors, **GPU governor**,
> **Bypass Charging (with auto-disable on unplug)**, **Thermal Disable** (now
> stops MTK thermal services for an actual throttling kill-switch), Laya Battmon,
> Disable Flag Secure, Disable Tap-to-Rotate, and a custom OTA banner.
>
> **Tested on Android 16 (TranssionOS — HiOS16 & XOS16).** Other TranssionOS16 ROMs should work too.
>
> Lessons learned through actual flashing & logcat-debugging are baked in —
> read the **"Things that bit us"** section at the bottom before you start.

---

## What you'll change

**In `TranSettings.apk`** — 4 things:

1. `classes4.dex` — inject 13 new classes under `com/android/settings/system/addons/`
2. `res/xml/system_dashboard_fragment.xml` — add the Addons entry to the System settings menu
3. `res/layout/preference_empty_list.xml` — replace with the Addons preference screen
4. `classes2.dex` — patch `OsVersionController` for the custom OTA banner *(optional)*

**In the vendor partition** — 1 thing:

5. `vendor/etc/init/hw/init.<soc>.rc` — add `chown`/`chmod` lines so Settings can write the GPU governor sysfs node (CPU governor + charger nodes are usually already chowned in stock).

**Optional: vendor SELinux** — only if you go back to enforcing. See "SELinux notes".

---

## Per-feature prerequisites — read this first

Each feature needs specific things on the device side to actually function. Copy this checklist before flashing — verify each row on **your** device with `ls -lZ` and `getprop`.

| Feature | Needs sysfs node | Needs init.rc chown/chmod | Needs sepolicy edit (enforcing only) | Needs vendor service / daemon |
|---|---|---|---|---|
| **Master toggle (Enable Addons)** | — | — | — | — |
| **CPU Little Governor** | `/sys/devices/system/cpu/cpufreq/policy0/scaling_governor` | Usually stock — verify is `system:system 0660` | Yes if enforcing — `system_app` needs `sysfs_devices_system_cpu` write | — |
| **CPU Big Governor** | `/sys/devices/system/cpu/cpufreq/policy6/scaling_governor` | Usually stock — verify is `system:system 0660` | Yes if enforcing — `system_app` needs `sysfs_devices_system_cpu` write | — |
| **GPU Governor** | `/sys/devices/platform/<mali>/devfreq/<mali>/governor` (+ `available_governors`) | **YES** — must add to `init.<soc>.rc` (see Part 2) | Yes if enforcing — `system_app` needs sysfs write access to devfreq node | — |
| **Bypass Charging** | `/sys/devices/platform/charger/tran_aichg_disable_charger` | Usually stock — verify is `system:system 0666` | — | — |
| **Disable Thermal** | None — uses `ctl.stop`/`ctl.start` | — | Yes if enforcing — `system_app` → `ctl_default_prop` set | `thermald`, `thermalloadalgod` must exist on the device |
| **Disable Flag Secure** | None — sysprop `persist.sys.satya.dfs_active` only useful if your ROM's screen recorder/screenshot framework reads it | — | — | — |
| **Laya Battmon** | None — sysprop `debug.laya.battmon_enabled` | — | — | **Laya must be installed on vendor side** (Part 4) |
| **Disable Tap to Rotate** | None — `Settings.Secure show_rotation_suggestions` | — | — | — |
| **Custom OTA Banner** | `/data/data/com.android.settings/files/banner.png` (auto-managed) | — | — | Requires Step 5 patch in `OsVersionController` |

What to do if a feature doesn't work:
- **Path doesn't exist** → wrong smali path for your device. See "Device-specific path quick reference".
- **Owner is `root:root`** → add `chown system system` + `chmod 0664` for that path in vendor `init.<soc>.rc`. See Part 2.
- **Thermal service missing** (`getprop init.svc.thermald` returns nothing) → edit `ThermalDisableController.smali` to use whatever service name your device uses (find it via `getprop | grep init.svc | grep -i thermal`).
- **Mali path differs from `13000000.mali`** → update `GPUGovernorController.smali` and the vendor init.rc lines accordingly.

---

## Tools

- **[APKTool M](https://apktool-m.en.uptodown.com/android)** — Android app for decoding/rebuilding APKs directly on your phone. Handles binary XML decode and rebuild without aapt2 mismatch issues.
- **MIO Kitchen** or any unpacker to repack `system_ext.img` and `vendor.img`
- **adb / logcat / dmesg** — for debugging when things break
- **Termux + tsu** (or root + a terminal) — for permission checks and toggle testing

---

## Customize — rename the satyam identifiers

All system properties and preference keys contain `satya` / `kajru`
(satyam's identifiers). Replace with your own everywhere
**before** injecting anything.

| Original | What it is |
|---|---|
| `persist.sys.satya.addons_enabled` | sysprop |
| `persist.sys.satya.littlegov` | sysprop |
| `persist.sys.satya.biggov` | sysprop |
| `persist.sys.satya.gpugov` | sysprop |
| `persist.sys.satya.dfs_active` | sysprop |
| `persist.sys.satya.banner.source` | sysprop |
| `persist.sys.satya.banner.enabler` | sysprop |
| `kajru_addons_enabled` | preference key |
| `satya_dfs_key` | preference key |
| `os_satya_banner_enabler` | preference key |
| `os_satya_banner_selector` | preference key |
| `By Kajru Kashyap` | UI summary text |

A missed key in one place = a dead toggle. Search/replace across the
smali tree before touching the dex.

---

## Part 1 — Patch TranSettings.apk

### Step 1: Inject the new classes into `classes4.dex`

```
smali/classes4/com/android/settings/system/addons/
    AddonsDashboardFragment.smali
    AddonsController.smali
    CPULittleController.smali
    CPUBigController.smali
    GPUGovernorController.smali            ← GPU governor
    BypassChargingController.smali         ← Bypass charging
    BypassDisconnectReceiver.smali         ← Auto-disable bypass on unplug
    ThermalDisableController.smali         ← Thermal disable (stops MTK daemons)
    DisableFlagSecureControlller.smali     ← triple L, intentional (matches obfuscator output)
    LayaController.smali
    TapRotateListener.smali
    CustomBannerEnablerController.smali
    TranCustomBannerOTA.smali
smali/classes2/com/transsion/settings/deviceinfo/aboutphone/
    OsVersionController.smali              ← reference copy with banner patch applied
```

Inject all 13 classes into `classes4.dex` at:

```
com/android/settings/system/addons/
```

Decode the APK with APKTool M, then drop the files into `smali_classes4/com/android/settings/system/addons/` and rebuild.

**Renaming satya/kajru:** before injecting, replace strings:

```bash
# From the tutorial root:
grep -rl 'satya\|kajru\|Kajru Kashyap' smali/
sed -i 's/satya/yourname/g; s/kajru/yourkey/g; s/Kajru Kashyap/Your Name/g' \
       $(grep -rl 'satya\|kajru\|Kajru Kashyap' smali/)
```

---

### Step 2: Edit `res/xml/system_dashboard_fragment.xml`

XML files in APKs are stored in binary AXML — decode with APKTool M first.

Find the language/region entry:

```xml
<Preference
    android:title="@string/tran_language_settings"
    android:key="language_and_region_settings"
    android:order="70"
    android:fragment="com.android.settings.language.LanguageAndRegionSettings"
    settings:controller="com.android.settings.language.LanguageAndRegionPreferenceController"/>
```

Add immediately after it:

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

> Position in XML doesn't matter — Android orders by `android:order` value.

---

### Step 3: Replace `res/layout/preference_empty_list.xml`

> **Important:** the controllers cast to `androidx.preference.SwitchPreference`,
> NOT `SwitchPreferenceCompat`. Use plain `<SwitchPreference>` in the XML.
> If you mix the Compat variant with these controllers you get
> `ClassCastException` and Settings crashes the moment you tap Addons.
> See the "Things that bit us" section.

Replace the entire file with:

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
            android:persistent="true"
            settings:controller="com.android.settings.system.addons.CPULittleController"/>

        <ListPreference
            android:title="CPU Big Governor"
            android:key="cpu_big_gov"
            android:persistent="true"
            settings:controller="com.android.settings.system.addons.CPUBigController"/>

        <ListPreference
            android:title="GPU Governor"
            android:key="gpu_gov"
            android:persistent="true"
            settings:controller="com.android.settings.system.addons.GPUGovernorController"/>

        <SwitchPreference
            android:title="Bypass Charging"
            android:key="bypass_charging"
            android:summary="Disable charging while connected to charger."
            settings:controller="com.android.settings.system.addons.BypassChargingController"/>

        <SwitchPreference
            android:title="Disable Thermal"
            android:key="thermal_disable"
            android:summary="Disable thermal throttling."
            settings:controller="com.android.settings.system.addons.ThermalDisableController"/>
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

> All three governor `ListPreference`s have `android:persistent="true"` —
> without it the picker won't remember its value across reopens.

---

### Step 4: Put the edited XMLs back in the APK

**A) APKTool M rebuild (recommended)** — decode the APK with APKTool M, make your edits, then rebuild. APKTool M handles binary XML and aapt2 automatically.

**B) Manual zip replacement (fallback)**

```bash
staging/classes4.dex
staging/res/layout/preference_empty_list.xml
staging/res/xml/system_dashboard_fragment.xml

cd staging
7z a -tzip ../TranSettings.apk \
   classes4.dex \
   res/layout/preference_empty_list.xml \
   res/xml/system_dashboard_fragment.xml
```

> XMLs must be in **binary AXML** when inserted back. If you decoded with
> APKTool M the output is already binary. If you hand-wrote plain
> XML, run it through aapt2 first.

---

### Step 5 *(optional)*: Patch `OsVersionController` for the custom OTA banner

Skip if you don't want the custom banner card.

> **Note:** The OTA banner patch may differ per device. If your `OsVersionController.smali`
> doesn't match the one shown here, you can ask AI (e.g. ChatGPT) to help you patch your
> specific version.

In `classes2.dex` → `com.transsion.settings.deviceinfo.aboutphone.OsVersionController`,
in `displayPreference(Landroidx/preference/PreferenceScreen;)V`, find the label
just before the final `return-void` and insert:

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

    const/high16 v7, 0x41200000    # 10.0f
    const/high16 v8, 0x41200000    # 10.0f
    sget-object v9, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;
    invoke-static {v7, v8, v9}, Landroid/graphics/RenderEffect;->createBlurEffect(FFLandroid/graphics/Shader$TileMode;)Landroid/graphics/RenderEffect;
    move-result-object v7
    invoke-virtual {v6, v7}, Landroid/widget/ImageView;->setRenderEffect(Landroid/graphics/RenderEffect;)V

    sget-object v7, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v6, v7}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    :cond_custom_end
```

Then bump `.registers` by 5 to fit `v5`–`v9` (e.g. `.registers 7` → `.registers 12`).

---

### Step 6: Place in the ROM and repack TranSettings

```
system_ext/priv-app/TranSettings/TranSettings.apk
```

Optionally delete `system_ext/priv-app/TranSettings/oat/` so Android regenerates
the odex on first boot. You can also leave it — Android will regenerate when it
notices the dex changed.

---

## Part 2 — Vendor init: fix sysfs permissions for GPU governor

The Settings app runs as the `system` UID. Several sysfs nodes that the addon
controllers need to write are owned `root:root` with mode `0644` in stock,
which means **only root can write**, not Settings. Toggling the switch silently
fails because the `FileWriter.write()` call throws and the controller's
try/catch eats it.

### Find the right paths and check permissions

Run this as root **on your actual device** before assuming the tutorial paths
match yours. Paths vary between SoCs.

```bash
ls -lZ /sys/class/thermal/thermal_zone0/mode
ls -lZ /sys/devices/platform/charger/tran_aichg_disable_charger
ls -lZ /sys/class/devfreq/<your-mali-name>/governor
ls -lZ /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
ls -lZ /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
```

Look at the **owner** column. If it's `root:root`, the Settings app can read
but **not write**, and you need a vendor init.rc fix. If it's `system:system`
with a write bit (e.g. `0660` or `0664`), it's already good.

### Find the right Mali devfreq path

```bash
ls /sys/class/devfreq/
```

Common Transsion/MediaTek values: `13000000.mali`, `gpufreq`, `mtkgpufreq`. The
controller uses the Mali devfreq. Note that `/sys/class/devfreq/<name>` is a
symlink to `/sys/devices/platform/<name>/devfreq/<name>` — init.rc must use the
**real** device path, not the symlink. Get it with:

```bash
readlink -f /sys/class/devfreq/13000000.mali
```

### Find the right thermal zone (you may not actually need it)

The new `ThermalDisableController` does NOT write to thermal_zone sysfs anymore
(see Part 3 below). But for reference:

```bash
for z in /sys/class/thermal/thermal_zone*; do
  printf '%-45s type=%s\n' "$z" "$(cat $z/type 2>/dev/null)"
done
```

On Transsion + MediaTek the throttle-relevant zones are usually
`mtktscpu`, `mtktsAP`, `mtktspa`. **`thermal_zone0` is often `mtk-master-charger`,
which is useless to disable for performance.**

### Edit the vendor init.rc

Find the right vendor init file:

```bash
grep -rln 'cpufreq/policy0/scaling_governor' \
   /your/extracted/rom/vendor/etc/init/
# typically: vendor/etc/init/hw/init.<soc>.rc, e.g. init.mt6833.rc
```

Add lines next to the existing CPU governor `chown`/`chmod` block. Example
for an MT6833 device with a Mali GPU at `13000000.mali`:

```
    # Stock — already in init.<soc>.rc on most Transsion ROMs
    chown system system /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
    chmod 0660 /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
    chown system system /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
    chmod 0660 /sys/devices/system/cpu/cpufreq/policy6/scaling_governor

    # Transsion Addons - GPU governor (ADD THIS)
    chown system system /sys/devices/platform/13000000.mali/devfreq/13000000.mali/governor
    chmod 0664 /sys/devices/platform/13000000.mali/devfreq/13000000.mali/governor
    chown system system /sys/devices/platform/13000000.mali/devfreq/13000000.mali/available_governors
    chmod 0664 /sys/devices/platform/13000000.mali/devfreq/13000000.mali/available_governors
```

> Replace `13000000.mali` with whatever you got from `readlink -f`. Comments
> starting with `#` are valid in init.rc.

You don't need any thermal_zone chown/chmod — the new thermal controller
doesn't touch sysfs (Part 3).

### Repack `vendor.img` and flash

In MIO Kitchen, repack the modified vendor partition. Verify after boot:

```bash
ls -l /sys/devices/platform/13000000.mali/devfreq/13000000.mali/governor
# expect: -rw-rw-r-- system system ... 0664
```

---

## Part 3 — How Thermal Disable actually works on MTK

> **MTK doesn't throttle through `thermal_zone*/mode`.** Disabling a zone
> only stops kernel sensor monitoring on that zone. Throttling is performed
> by **userspace daemons** that read temperatures and adjust CPU/GPU
> frequencies via the governor.

The actual throttle daemons on Transsion + MediaTek:

- `thermald`
- `thermalloadalgod`

Sometimes a third HAL service (`vendor.thermal-hal-2-0.mtk`) exists, but
**plat → vendor `ctl.*` is blocked by init's property service even in
permissive SELinux**, so the Settings app cannot stop it. Don't try.

The new `ThermalDisableController.smali` (in this tutorial's smali folder)
does this:

| Action | What it sets |
|---|---|
| Toggle ON | `ctl.stop` ← `thermald`, `ctl.stop` ← `thermalloadalgod` |
| Toggle OFF | `ctl.start` ← `thermald`, `ctl.start` ← `thermalloadalgod` |
| State display | Reads `init.svc.thermald` — if `stopped`, switch shows ON |

Each `SystemProperties.set` is wrapped in a try/catch (`safeSetProp`)
so a single failure (sepolicy, missing service) doesn't crash the
toggle. If a daemon name is different on your device, only that one
is silently skipped — the others still apply.

### Adapting the controller for a different device

If your device's thermal daemons have different names, edit the two
`const-string v1, "thermald"` / `"thermalloadalgod"` lines in
`ThermalDisableController.smali`. Check what's running:

```bash
getprop | grep -E '^\[init\.svc\.[^]]+\]:.*\b(running|stopped|restarting)\b' | grep -i thermal
ps -A | grep thermal
```

Common MTK service names:
- `thermald`
- `thermalloadalgod`
- `mtkPowerService` (don't stop this — it powers other things)

> **Caveat:** with thermal disabled the SoC will get genuinely hot under load.
> It's a momentary boost toggle, not always-on. Long sessions will hit a kernel
> emergency limit or hurt battery health.

---

## Part 4 — Laya BatteryMonitor (vendor side)

Follow the official guide:

> **https://github.com/Laynsb/Laya-BatteryMonitor**

`LayaController.smali` toggles Laya via `debug.laya.battmon_enabled` —
that matches what Laya listens for, so no extra Settings-side wiring.

---

## Things that bit us (read this before you start)

These are real bugs we hit while porting + debugging this tutorial.
Prevent them by following the steps above.

### 1. `SwitchPreferenceCompat` vs `SwitchPreference`

Symptom: tapping Addons crashes Settings instantly with:

```
ClassCastException: androidx.preference.SwitchPreference cannot be cast
                    to androidx.preference.SwitchPreferenceCompat
```

Cause: the XML uses `<SwitchPreference>` but the controllers were originally
written to cast `findPreference(...)` to `SwitchPreferenceCompat`. They're
different classes in androidx.

Fix: in `BypassChargingController`, `ThermalDisableController`, and
`BypassDisconnectReceiver`, replace every `Landroidx/preference/SwitchPreferenceCompat;`
with `Landroidx/preference/SwitchPreference;`. The methods (`setChecked`,
`setOnPreferenceChangeListener`) are inherited so call sites still work.
The smali in this tutorial is already fixed.

### 2. `.registers` collision in `displayPreference`

Symptom: `VerifyError`/`ClassCastException` when the screen tries to load a
controller, with low-level register-related errors.

Cause: a method had `.registers N` low enough that `vN-2` aliased the `p0` /
`this` register. Then `move-result vN-2` (from a `Z` return) overwrote `this`
with a primitive, and the next `invoke-virtual {v1, p0}` passed an int where
an interface reference was required → verifier rejects the class.

Fix: bump `.registers` by 1 so the local register is no longer the same as
the parameter slot. Examples (already applied to the smali in this tutorial):

| File | Method | Old | New |
|---|---|---|---|
| `BypassChargingController` | `displayPreference` | `.registers 5` | `.registers 6` |
| `ThermalDisableController` | `displayPreference` | `.registers 4` | `.registers 5` |

### 3. Hardcoded resource ID — verify before assuming

`AddonsDashboardFragment.getPreferenceScreenResId()` returns a hardcoded
`0x7f0e02d9`. That happens to map to `R.layout.preference_empty_list`
in stock TranSettings on the build satyam ported — and on the
build I tested. If your TranSettings is from a different OEM/version,
verify by decoding with APKTool M and check `res/values/public.xml`:

```bash
grep 'preference_empty_list' decoded/res/values/public.xml
# expect: <public type="layout" name="preference_empty_list" id="0x7f0e02d9" />
```

If the id differs, update the smali.

### 4. Sysfs reads/writes silently fail because of UNIX file owner

Symptom: toggle clicks work without crashing, but the underlying
hardware state never changes. Reading `cat <node>` shows the same
value before and after.

Cause: sysfs node is `root:root 0644`. Settings can't write.

Fix: vendor `init.<soc>.rc` chown/chmod the node. See Part 2.

> Even on permissive SELinux this still applies — UNIX permissions
> are enforced regardless.

### 5. `thermal_zone0/mode` is the charger, not the CPU

Symptom: toggle "Disable Thermal" — sysfs writes succeed, `mode` flips
to `disabled`, but performance is unchanged.

Cause: on Transsion + MediaTek, `thermal_zone0` is typically
`mtk-master-charger`. CPU throttling is driven by userspace daemons,
not zone monitoring. **Disabling zone0 does effectively nothing.**

Fix: don't write thermal_zone sysfs. Stop the daemons. See Part 3.

### 6. plat `system_app` cannot `ctl.*` a vendor service

Symptom: toggling Disable Thermal crashes with:

```
RuntimeException: failed to set system property "ctl.start" to
"vendor.thermal-hal-2-0-mtk" (check logcat for reason)
```

Cause: `vendor.*` services live on the vendor partition. Init's property
service blocks plat domains (system_app) from controlling vendor services
**even in permissive SELinux** — this is a runtime check separate from
SELinux.

Fix: don't try to ctl vendor services. Only target plat daemons
(`thermald`, `thermalloadalgod`). The smali in this tutorial only
ctl's plat services and wraps the call in try/catch as defense.

### 7. Existing sysfs perms vary widely

Don't assume any node is writable. **Always run** `ls -lZ` on each path
the controllers use, on your actual device, before flashing. Compare
to the controller's behavior; either fix the smali path or fix the
init.rc perms.

### 8. Controllers might not be in `createPreferenceControllers()` — that's fine

Newer controllers (`GPUGovernorController`, `BypassChargingController`,
`ThermalDisableController`) are NOT explicitly added to
`AddonsDashboardFragment.createPreferenceControllers()`. They don't
need to be — `DashboardFragment` auto-loads any controller declared
via `settings:controller="..."` in the preference XML, because the
base class `Lcom/android/settings/core/c;` is `BasePreferenceController`
(confirmed by the `getAvailabilityStatus()` + `(Context, String)`
constructor signature). XML wiring is sufficient.

### 9. `getprop` ≠ sysfs

If you're checking whether a toggle "worked", check the right thing:

- **CPU governor / GPU governor / charger / thermal_zone** → `cat /sys/...`
- **Service running state / persist.sys.* props** → `getprop`

Mixing the two (e.g. checking `getprop | grep thermal` after toggling a
sysfs-based control) just confuses you.

---

## SELinux notes

The smali setprop calls work in **permissive SELinux**. If you go back
to enforcing, you may need to allow `system_app` to set the `ctl.*`
properties. Add to `vendor/etc/selinux/vendor_sepolicy.cil`:

```cil
; Transsion Addons — let system_app stop/start init services (Thermal Disable)
(allow system_app_31_0 ctl_default_prop (property_service (set)))
(allow system_app_31_0 ctl_default_prop (file (read open map getattr)))

; Transsion Addons — let system_app read/write sysfs nodes (GPU governor, etc.)
(allow system_app sysfs (file (getattr)))
(allow system_app sysfs (file (open)))
(allow system_app sysfs (file (read)))
(allow system_app sysfs (file (write)))

; Transsion Addons — let system_app write CPU governor sysfs node
(allow system_app sysfs_devices_system_cpu (file (write)))
```

The version suffix (`_31_0`) must match your platform — grep your
existing cil for `system_app_` to find the right one. Some rules use
`system_app` (without suffix) because the sysfs types are not versioned.

> **Watch out:** the vendor folder also has `precompiled_sepolicy` (binary).
> If its SHA matches `precompiled_sepolicy.*.sha256`, init loads the binary
> blob and ignores your `.cil` edits. Either delete the precompiled blob
> (slower boot, edits take effect) or recompile it with `secilc`. Detail:
>
> ```bash
> # Easiest: delete and let init compile from .cil at boot
> rm vendor/etc/selinux/precompiled_sepolicy
> rm vendor/etc/selinux/precompiled_sepolicy.*.sha256
> ```

For sustained development, prefer the `secilc` recompile path so boot
stays fast.

---

## Device-specific sysfs path quick reference

If a feature doesn't work on your device, check these paths first.

### CPU governors
- Little: `/sys/devices/system/cpu/cpufreq/policy0/scaling_governor`
- Big: `/sys/devices/system/cpu/cpufreq/policy6/scaling_governor`
- Edit in: `CPULittleController.smali`, `CPUBigController.smali`

### GPU governor (Mali devfreq)
- Default: `/sys/class/devfreq/13000000.mali/{governor,available_governors}`
- Verify: `ls /sys/class/devfreq/`
- Edit in: `GPUGovernorController.smali`
- Don't forget vendor init.rc chown/chmod (Part 2)

### Bypass charging
- Default: `/sys/devices/platform/charger/tran_aichg_disable_charger`
- `1` = bypass, `0` = normal
- The `BypassDisconnectReceiver` listens for `ACTION_POWER_DISCONNECTED`
  and forces the toggle off when the charger is unplugged.
- Verify: `find /sys -name '*disable*charg*' 2>/dev/null`

### Thermal services (NOT thermal_zone)
- Daemons: `thermald`, `thermalloadalgod`
- Verify: `getprop | grep init.svc | grep thermal`

---

## Feature summary

| # | Feature | Preference key | Controller | Mechanism |
|---|---|---|---|---|
| 1 | Enable Addons (master) | `kajru_addons_enabled` | `AddonsController` | sysprop |
| 2 | CPU Little Governor | `cpu_little_gov` | `CPULittleController` | sysfs write |
| 3 | CPU Big Governor | `cpu_big_gov` | `CPUBigController` | sysfs write |
| 4 | GPU Governor | `gpu_gov` | `GPUGovernorController` | sysfs write |
| 5 | Bypass Charging | `bypass_charging` | `BypassChargingController` + `BypassDisconnectReceiver` | sysfs write + broadcast |
| 6 | Disable Thermal | `thermal_disable` | `ThermalDisableController` | `ctl.stop`/`ctl.start` daemons |
| 7 | Disable Flag Secure | `satya_dfs_key` | `DisableFlagSecureControlller` | sysprop |
| 8 | Laya Battmon | `laya_addon_enabled` | `LayaController` | `debug.laya.battmon_enabled` |
| 9 | Disable Tap to Rotate | `disable_tap_rotate` | `TapRotateListener` | `Settings.Secure` |
| 10 | Use Custom OTA Banner | `os_satya_banner_enabler` | `CustomBannerEnablerController` | sysprop |
| 11 | Select custom image | `os_satya_banner_selector` | `TranCustomBannerOTA` | file picker → `files/banner.png` |

Plus the classes2 patch for `OsVersionController` so the banner is rendered.

---

## Final test checklist

After flashing the patched APK + modified vendor:

```bash
# 1. APK installed cleanly
adb logcat -d -b crash | grep com.android.settings | tail -20
# (should be empty; no FATAL EXCEPTION)

# 2. Addons screen opens without crashing
# Tap Settings → System → Addons. Should render.

# 3. Sysfs perms applied (post-reboot, no Magisk script needed)
ls -l /sys/devices/platform/13000000.mali/devfreq/13000000.mali/governor \
      /sys/devices/system/cpu/cpufreq/policy0/scaling_governor \
      /sys/devices/system/cpu/cpufreq/policy6/scaling_governor \
      /sys/devices/platform/charger/tran_aichg_disable_charger
# all four: system:system, with a write bit

# 4. Thermal toggle stops daemons
getprop init.svc.thermald init.svc.thermalloadalgod
# expect: running running
# (toggle ON in Settings)
getprop init.svc.thermald init.svc.thermalloadalgod
# expect: stopped stopped

# 5. GPU governor toggle changes the value
cat /sys/class/devfreq/13000000.mali/governor
# (change in Settings)
cat /sys/class/devfreq/13000000.mali/governor
# expect: different value

# 6. CPU governor toggle changes the value
cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
# (change in Settings)
cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
# expect: different value
```

If anything fails, capture logcat and dmesg:

```bash
adb logcat -d -b crash | tail -50      # crashes
adb logcat -d | grep -iE 'addons|thermal|charger|mali' | tail -50
adb shell su -c 'dmesg | grep -i avc'  # SELinux denials (informational on permissive)
```

---

## Credits

- **@satyam_rai1** — Transsion Addons rebuild
- **Layns** — https://github.com/Laynsb
