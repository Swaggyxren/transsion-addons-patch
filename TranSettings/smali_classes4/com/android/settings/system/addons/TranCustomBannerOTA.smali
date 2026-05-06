.class public Lcom/android/settings/system/addons/TranCustomBannerOTA;
.super Lcom/android/settings/core/c;


# instance fields
.field private mParent:Lcom/android/settings/system/addons/AddonsDashboardFragment;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 3

    const-string v0, "os_satya_banner_selector"

    invoke-direct {p0, p1, v0}, Lcom/android/settings/core/c;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/settings/system/addons/AddonsDashboardFragment;)V
    .registers 4

    const-string v0, "os_satya_banner_selector"

    invoke-direct {p0, p1, v0}, Lcom/android/settings/core/c;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    iput-object p2, p0, Lcom/android/settings/system/addons/TranCustomBannerOTA;->mParent:Lcom/android/settings/system/addons/AddonsDashboardFragment;

    return-void
.end method

.method public static copyStream(Ljava/io/InputStream;Ljava/io/OutputStream;)V
    .registers 6

    if-eqz p0, :cond_13

    if-eqz p1, :cond_13

    const/16 v0, 0x1000

    new-array v1, v0, [B

    :goto_8
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-ltz v2, :cond_13

    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, v2}, Ljava/io/OutputStream;->write([BII)V

    goto :goto_8

    :cond_13
    return-void
.end method


# virtual methods
.method public getAvailabilityStatus()I
    .registers 2

    const/4 v0, 0x0

    return v0
.end method

.method public getPreferenceKey()Ljava/lang/String;
    .registers 2

    const-string v0, "os_satya_banner_selector"

    return-object v0
.end method

.method public handlePreferenceTreeClick(Landroidx/preference/Preference;)Z
    .registers 4

    invoke-virtual {p1}, Landroidx/preference/Preference;->getKey()Ljava/lang/String;

    move-result-object v0

    const-string v1, "os_satya_banner_selector"

    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_15

    iget-object v0, p0, Lcom/android/settings/system/addons/TranCustomBannerOTA;->mParent:Lcom/android/settings/system/addons/AddonsDashboardFragment;

    if-eqz v0, :cond_15

    invoke-virtual {v0}, Lcom/android/settings/system/addons/AddonsDashboardFragment;->selectCustomBanner()V

    const/4 v0, 0x1

    return v0

    :cond_15
    invoke-super {p0, p1}, Lcom/android/settings/core/c;->handlePreferenceTreeClick(Landroidx/preference/Preference;)Z

    move-result v0

    return v0
.end method
