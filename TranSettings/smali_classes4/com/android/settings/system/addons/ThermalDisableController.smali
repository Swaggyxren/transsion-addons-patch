.class public Lcom/android/settings/system/addons/ThermalDisableController;
.super Lcom/android/settings/core/c;

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 3

    const-string v0, "thermal_disable"

    invoke-direct {p0, p1, v0}, Lcom/android/settings/core/c;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method private isThermalDisabled()Z
    .registers 3

    const-string v0, "init.svc.thermald"

    const-string v1, "running"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "stopped"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method private safeSetProp(Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    :try_start_0
    invoke-static {p1, p2}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_5} :catch_5

    :catch_5
    return-void
.end method

.method private setThermalDisabled(Z)V
    .registers 5

    if-eqz p1, :cond_start

    const-string v0, "ctl.stop"

    goto :goto_set

    :cond_start
    const-string v0, "ctl.start"

    :goto_set
    const-string v1, "thermald"

    invoke-direct {p0, v0, v1}, Lcom/android/settings/system/addons/ThermalDisableController;->safeSetProp(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "thermalloadalgod"

    invoke-direct {p0, v0, v1}, Lcom/android/settings/system/addons/ThermalDisableController;->safeSetProp(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 5

    invoke-super {p0, p1}, Lcom/android/settings/core/c;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    const-string v0, "thermal_disable"

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceScreen;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object v1

    check-cast v1, Landroidx/preference/SwitchPreference;

    if-eqz v1, :cond_end

    invoke-direct {p0}, Lcom/android/settings/system/addons/ThermalDisableController;->isThermalDisabled()Z

    move-result v2

    invoke-virtual {v1, v2}, Landroidx/preference/SwitchPreference;->setChecked(Z)V

    invoke-virtual {v1, p0}, Landroidx/preference/SwitchPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    :cond_end
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    const/4 v0, 0x0

    return v0
.end method

.method public getPreferenceKey()Ljava/lang/String;
    .registers 2

    const-string v0, "thermal_disable"

    return-object v0
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 4

    check-cast p2, Ljava/lang/Boolean;

    invoke-virtual {p2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/settings/system/addons/ThermalDisableController;->setThermalDisabled(Z)V

    const/4 v0, 0x1

    return v0
.end method

.method public updateState(Landroidx/preference/Preference;)V
    .registers 4

    invoke-super {p0, p1}, Lcom/android/settings/core/c;->updateState(Landroidx/preference/Preference;)V

    move-object v0, p1

    check-cast v0, Landroidx/preference/TwoStatePreference;

    invoke-direct {p0}, Lcom/android/settings/system/addons/ThermalDisableController;->isThermalDisabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Landroidx/preference/TwoStatePreference;->setChecked(Z)V

    return-void
.end method
