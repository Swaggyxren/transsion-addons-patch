.class public Lcom/android/settings/system/addons/AddonsDashboardFragment;
.super Lcom/android/settings/dashboard/DashboardFragment;
.source "AddonsDashboardFragment.java"


# static fields
.field public static final SEARCH_INDEX_DATA_PROVIDER:Ll8/a;

.field private static final TAG:Ljava/lang/String; = "AddonsDashboard"


# direct methods
.method public static constructor <clinit>()V
    .registers 1

    const/4 v0, 0x0

    sput-object v0, Lcom/android/settings/system/addons/AddonsDashboardFragment;->SEARCH_INDEX_DATA_PROVIDER:Ll8/a;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lcom/android/settings/dashboard/DashboardFragment;-><init>()V

    return-void
.end method


# virtual methods
.method protected createPreferenceControllers(Landroid/content/Context;)Ljava/util/List;
    .registers 4

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    new-instance v1, Lcom/android/settings/system/addons/AddonsController;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/AddonsController;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/CPULittleController;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/CPULittleController;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/CPUBigController;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/CPUBigController;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/DisableFlagSecureControlller;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/DisableFlagSecureControlller;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/LayaController;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/LayaController;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/TapRotateListener;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/TapRotateListener;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/TranCustomBannerOTA;

    invoke-direct {v1, p1, p0}, Lcom/android/settings/system/addons/TranCustomBannerOTA;-><init>(Landroid/content/Context;Lcom/android/settings/system/addons/AddonsDashboardFragment;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    new-instance v1, Lcom/android/settings/system/addons/CustomBannerEnablerController;

    invoke-direct {v1, p1}, Lcom/android/settings/system/addons/CustomBannerEnablerController;-><init>(Landroid/content/Context;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method

.method protected getLogTag()Ljava/lang/String;
    .registers 2

    const-string v0, "AddonsDashboard"

    return-object v0
.end method

.method public getMetricsCategory()I
    .registers 2

    const/16 v0, 0x1e

    return v0
.end method

.method protected getPreferenceScreenResId()I
    .registers 2

    const v0, 0x7f0e02d9

    return v0
.end method

.method public onActivityResult(IILandroid/content/Intent;)V
    .registers 11

    invoke-super {p0, p1, p2, p3}, Lcom/android/settings/dashboard/DashboardFragment;->onActivityResult(IILandroid/content/Intent;)V

    const/16 v0, 0x65

    if-ne p1, v0, :cond_49

    const/4 v0, -0x1

    if-ne p2, v0, :cond_49

    if-eqz p3, :cond_49

    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v1

    if-eqz v1, :cond_49

    :try_start_12
    new-instance v2, Ljava/io/File;

    invoke-virtual {p0}, Lcom/android/settings/system/addons/AddonsDashboardFragment;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    const-string v4, "banner.png"

    invoke-direct {v2, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/android/settings/system/addons/AddonsDashboardFragment;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-static {v1, v3}, Lcom/android/settings/system/addons/TranCustomBannerOTA;->copyStream(Ljava/io/InputStream;Ljava/io/OutputStream;)V

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    invoke-virtual {v3}, Ljava/io/OutputStream;->close()V

    invoke-virtual {p0}, Lcom/android/settings/system/addons/AddonsDashboardFragment;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "Banner updated."

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    :try_end_49
    .catch Ljava/lang/Exception; {:try_start_12 .. :try_end_49} :catch_4a

    :cond_49
    :goto_49
    return-void

    :catch_4a
    move-exception v0

    const-string v1, "AddonsDashboard"

    const-string v2, "Error updating banner"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_49
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .registers 2

    invoke-super {p0, p1}, Lcom/android/settings/dashboard/DashboardFragment;->onCreate(Landroid/os/Bundle;)V

    return-void
.end method

.method public selectCustomBanner()V
    .registers 4

    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.OPEN_DOCUMENT"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "android.intent.category.OPENABLE"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "image/*"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const/16 v1, 0x43

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const/16 v1, 0x65

    invoke-virtual {p0, v0, v1}, Lcom/android/settings/system/addons/AddonsDashboardFragment;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method
