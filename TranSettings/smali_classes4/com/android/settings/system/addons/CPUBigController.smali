.class public Lcom/android/settings/system/addons/CPUBigController;
.super Lcom/android/settings/core/c;

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 3

    const-string v0, "cpu_big_gov"

    invoke-direct {p0, p1, v0}, Lcom/android/settings/core/c;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method private readCurrentGov()Ljava/lang/String;
    .registers 4

    :try_start_0
    const-string v0, "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor"

    new-instance v1, Ljava/io/BufferedReader;

    new-instance v2, Ljava/io/FileReader;

    invoke-direct {v2, v0}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    if-eqz v0, :cond_16

    return-object v0

    :cond_16
    const-string v0, "sugov_ext"

    return-object v0
    :try_end_19
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_19} :catch_19

    :catch_19
    const-string v0, "sugov_ext"

    return-object v0
.end method

.method private readGovList()[Ljava/lang/String;
    .registers 7

    :try_start_0
    const-string v0, "/sys/devices/system/cpu/cpufreq/policy6/scaling_available_governors"

    new-instance v1, Ljava/io/BufferedReader;

    new-instance v2, Ljava/io/FileReader;

    invoke-direct {v2, v0}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    if-eqz v3, :cond_1c

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    return-object v5

    :cond_1c
    const/4 v0, 0x0

    return-object v0
    :try_end_1e
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_1e} :catch_1e

    :catch_1e
    const/4 v0, 0x0

    return-object v0
.end method

.method private writeBigGov(Ljava/lang/String;)V
    .registers 5

    :try_start_0
    new-instance v0, Ljava/io/FileWriter;

    const-string v1, "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor"

    invoke-direct {v0, v1}, Ljava/io/FileWriter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/io/FileWriter;->write(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/FileWriter;->close()V
    :try_end_d
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_d} :catch_d

    :catch_d
    return-void
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 7

    invoke-super {p0, p1}, Lcom/android/settings/core/c;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    const-string v0, "cpu_big_gov"

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceScreen;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object v1

    check-cast v1, Landroidx/preference/ListPreference;

    if-eqz v1, :cond_2c

    invoke-direct {p0}, Lcom/android/settings/system/addons/CPUBigController;->readGovList()[Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_19

    const-string v3, "sugov_ext"

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v2

    :cond_19
    invoke-virtual {v1, v2}, Landroidx/preference/ListPreference;->setEntries([Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v2}, Landroidx/preference/ListPreference;->setEntryValues([Ljava/lang/CharSequence;)V

    invoke-direct {p0}, Lcom/android/settings/system/addons/CPUBigController;->readCurrentGov()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroidx/preference/ListPreference;->setValue(Ljava/lang/String;)V

    invoke-virtual {v1, v4}, Landroidx/preference/ListPreference;->setSummary(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, p0}, Landroidx/preference/ListPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    :cond_2c
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    const/4 v0, 0x0

    return v0
.end method

.method public getPreferenceKey()Ljava/lang/String;
    .registers 2

    const-string v0, "cpu_big_gov"

    return-object v0
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 5

    move-object v0, p2

    check-cast v0, Ljava/lang/String;

    const-string v1, "persist.sys.satya.biggov"

    invoke-static {v1, v0}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p1, v0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    invoke-direct {p0, v0}, Lcom/android/settings/system/addons/CPUBigController;->writeBigGov(Ljava/lang/String;)V

    const/4 v1, 0x1

    return v1
.end method

.method public updateState(Landroidx/preference/Preference;)V
    .registers 4

    invoke-super {p0, p1}, Lcom/android/settings/core/c;->updateState(Landroidx/preference/Preference;)V

    move-object v0, p1

    check-cast v0, Landroidx/preference/ListPreference;

    invoke-direct {p0}, Lcom/android/settings/system/addons/CPUBigController;->readCurrentGov()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/preference/ListPreference;->setValue(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroidx/preference/ListPreference;->setSummary(Ljava/lang/CharSequence;)V

    const-string v0, "persist.sys.satya.biggov"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
