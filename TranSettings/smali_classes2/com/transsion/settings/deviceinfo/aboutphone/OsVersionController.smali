.class public Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;
.super Lcom/android/settings/core/c;
.source "SourceFile"

# interfaces
.implements Le5/e;
.implements Lf5/h;
.implements Lf5/f;


# static fields
.field private static final MY_DEVICE_INFO_OSVERSION_KEY:Ljava/lang/String; = "my_device_info_osversion"

.field private static final OS_NAME:Ljava/lang/String; = "ro.tranos.version"

.field private static final SYSTEMIPDATE_ENTRY_ACTION:Ljava/lang/String; = "com.transsion.intent.SYSTEMUPDATE_ENTRY"

.field private static final SYSTEMIPDATE_ENTRY_ACTION_TOTA:Ljava/lang/String; = "com.transsion.intent.TOTA_ENTRY"

.field private static final SYSTEMIPDATE_PACKAGE_NAME:Ljava/lang/String; = "com.transsion.systemupdate"

.field private static final SYSTEMIPDATE_PACKAGE_NAME_TOTA:Ljava/lang/String; = "com.transsion.tota"

.field private static final TAG:Ljava/lang/String; = "OsVersionController"

.field private static final UPDATE_ID_PROP:Ljava/lang/String; = "persist.sys.updateid"


# instance fields
.field private final mAccessibilityDisplayInversionEnableduri:Landroid/net/Uri;

.field private mCardBackground:Landroid/widget/ImageView;

.field private final mContentObserver:Landroid/database/ContentObserver;

.field private final mContentResolver:Landroid/content/ContentResolver;

.field private final mContext:Landroid/content/Context;

.field private mIsColorReversalMode:Z

.field private mIsPova:Z

.field private mNewIndicatorContainer:Landroid/widget/LinearLayout;

.field private mNewVersion:I

.field private mOsLogo:Landroid/widget/ImageView;

.field private mOsNum:Landroid/widget/TextView;

.field private final mOtaNewVersionUri:Landroid/net/Uri;

.field private mTvUpdate:Landroid/widget/TextView;

.field private final mUm:Landroid/os/UserManager;

.field private mUpdateOsNum:Landroid/widget/TextView;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 5

    const-string v0, "my_device_info_osversion"

    invoke-direct {p0, p1, v0}, Lcom/android/settings/core/c;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-string v0, "accessibility_display_inversion_enabled"

    invoke-static {v0}, Landroid/provider/Settings$Secure;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mAccessibilityDisplayInversionEnableduri:Landroid/net/Uri;

    const-string v0, "ota_new_version"

    invoke-static {v0}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOtaNewVersionUri:Landroid/net/Uri;

    new-instance v0, Lcom/android/settings/notification/r;

    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 v2, 0x7

    invoke-direct {v0, p0, v1, v2}, Lcom/android/settings/notification/r;-><init>(Ljava/lang/Object;Landroid/os/Handler;I)V

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentObserver:Landroid/database/ContentObserver;

    const-string v0, "user"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/UserManager;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUm:Landroid/os/UserManager;

    iput-object p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iput-object p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    return-void
.end method

.method public static bridge synthetic A(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Landroid/widget/TextView;
    .registers 1

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mTvUpdate:Landroid/widget/TextView;

    return-object p0
.end method

.method public static bridge synthetic B(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;Z)V
    .registers 2

    iput-boolean p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsColorReversalMode:Z

    return-void
.end method

.method public static bridge synthetic C(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;I)V
    .registers 2

    iput p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewVersion:I

    return-void
.end method

.method public static bridge synthetic D(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)V
    .registers 1

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->updateUI()V

    return-void
.end method

.method private getOsNameByRoAndGlobalSetting()Ljava/lang/String;
    .registers 6

    const-string v0, ""

    const-string v1, "[^0-9]"

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->getOsProductName()Ljava/lang/String;

    move-result-object v2

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    const-string v3, "os_small_version"

    invoke-static {p0, v3}, Landroid/provider/Settings$Global;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_17

    goto :goto_32

    :cond_17
    const/4 v3, 0x0

    :try_start_18
    invoke-virtual {v2, v1, v0}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4
    :try_end_20
    .catch Ljava/lang/NumberFormatException; {:try_start_18 .. :try_end_20} :catch_2b

    :try_start_20
    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3
    :try_end_28
    .catch Ljava/lang/NumberFormatException; {:try_start_20 .. :try_end_28} :catch_29

    goto :goto_30

    :catch_29
    move-exception v0

    goto :goto_2d

    :catch_2b
    move-exception v0

    move v4, v3

    :goto_2d
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V

    :goto_30
    if-lt v4, v3, :cond_33

    :goto_32
    return-object v2

    :cond_33
    return-object p0
.end method

.method private getOsProductName()Ljava/lang/String;
    .registers 4

    const-string v0, "ro.tranos.version"

    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_12

    const-string v0, "ro.os_product.version"

    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_12
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "getOsProductName: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "OsVersionController"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_44

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    const/4 v1, 0x0

    :goto_30
    if-ge v1, p0, :cond_57

    invoke-virtual {v0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    invoke-static {v2}, Ljava/lang/Character;->isDigit(C)Z

    move-result v2

    if-eqz v2, :cond_41

    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    goto :goto_57

    :cond_41
    add-int/lit8 v1, v1, 0x1

    goto :goto_30

    :cond_44
    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x7f151908

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    const-string v0, "ro.os_version_name"

    invoke-static {v0, p0}, LP5/e;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_57
    :goto_57
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    const/4 v1, 0x4

    if-gt p0, v1, :cond_65

    const-string p0, ".0"

    invoke-virtual {v0, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_65
    return-object v0
.end method

.method private handleUpdateButtonClick()V
    .registers 8

    const-string v0, "com.transsion.systemupdate"

    const-string v1, "com.transsion.tota"

    iget-object v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUm:Landroid/os/UserManager;

    invoke-static {v2}, LD3/J;->w(Landroid/os/UserManager;)Z

    move-result v2

    if-nez v2, :cond_21

    iget-object v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUm:Landroid/os/UserManager;

    invoke-virtual {v2}, Landroid/os/UserManager;->isDemoUser()Z

    move-result v2

    if-nez v2, :cond_21

    invoke-static {}, LYb/i;->e()LYb/i;

    move-result-object v0

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    const v1, 0x7f152301

    invoke-virtual {v0, v1, p0}, LYb/i;->j(ILandroid/content/Context;)V

    return-void

    :cond_21
    sget-boolean v2, LHb/c;->V:Z

    if-eqz v2, :cond_3e

    iget-object v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-static {v2}, Lcom/android/settings/network/telephony/T1;->x(Landroid/content/Context;)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    if-eqz v2, :cond_3e

    invoke-static {}, LYb/i;->e()LYb/i;

    move-result-object v0

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    const v1, 0x7f152302

    invoke-virtual {v0, v1, p0}, LYb/i;->j(ILandroid/content/Context;)V

    return-void

    :cond_3e
    iget v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewVersion:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_5b

    const-string v2, "persist.sys.updateid"

    const-string v4, "0"

    invoke-static {v2, v4}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v4, "card_click"

    invoke-static {v4, v2}, Lcom/android/settingslib/widget/f;->i(Ljava/lang/String;Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v2

    const-wide v4, 0x3db0e80244L

    const-string v6, "app_ota_update_report"

    invoke-static {v4, v5, v6, v3, v2}, Lcom/transsion/hubsdk/api/trancare/TranTrancareManager;->serverLog(JLjava/lang/String;ILandroid/os/Bundle;)V

    :cond_5b
    :try_start_5b
    sget-boolean v2, LP5/l;->b:Z

    if-eqz v2, :cond_7a

    iget-object v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-static {v2, v1}, Lcom/transsion/settings/z;->o(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_7a

    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "com.transsion.intent.TOTA_ENTRY"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    return-void

    :cond_7a
    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-static {v1, v0}, Lcom/transsion/settings/z;->o(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_ad

    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "com.transsion.intent.SYSTEMUPDATE_ENTRY"

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-virtual {p0, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_94
    .catch Ljava/lang/Exception; {:try_start_5b .. :try_end_94} :catch_95

    return-void

    :catch_95
    move-exception p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Exception:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "OsVersionController"

    invoke-static {v1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_ad
    return-void
.end method

.method private synthetic lambda$displayPreference$0(Landroid/view/View;)V
    .registers 2

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->handleUpdateButtonClick()V

    return-void
.end method

.method private registerObserve()V
    .registers 5

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mAccessibilityDisplayInversionEnableduri:Landroid/net/Uri;

    iget-object v2, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentObserver:Landroid/database/ContentObserver;

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOtaNewVersionUri:Landroid/net/Uri;

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentObserver:Landroid/database/ContentObserver;

    invoke-virtual {v0, v1, v3, p0}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V

    return-void
.end method

.method public static synthetic s(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;Landroid/view/View;)V
    .registers 2

    invoke-direct {p0, p1}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->lambda$displayPreference$0(Landroid/view/View;)V

    return-void
.end method

.method public static bridge synthetic u(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Landroid/net/Uri;
    .registers 1

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mAccessibilityDisplayInversionEnableduri:Landroid/net/Uri;

    return-object p0
.end method

.method private unregisterObserve()V
    .registers 2

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentObserver:Landroid/database/ContentObserver;

    invoke-virtual {v0, p0}, Landroid/content/ContentResolver;->unregisterContentObserver(Landroid/database/ContentObserver;)V

    return-void
.end method

.method private updateTvColor()V
    .registers 3

    iget-boolean v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsColorReversalMode:Z

    if-eqz v0, :cond_16

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mTvUpdate:Landroid/widget/TextView;

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v1, 0x7f060087

    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setTextColor(I)V

    :cond_16
    return-void
.end method

.method private updateUI()V
    .registers 6

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mTvUpdate:Landroid/widget/TextView;

    if-eqz v0, :cond_4e

    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewIndicatorContainer:Landroid/widget/LinearLayout;

    if-eqz v1, :cond_4e

    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUpdateOsNum:Landroid/widget/TextView;

    if-eqz v1, :cond_4e

    iget-object v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsNum:Landroid/widget/TextView;

    if-eqz v1, :cond_4e

    iget v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewVersion:I

    const/16 v2, 0x8

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-ne v1, v4, :cond_37

    invoke-virtual {v0, v4}, Landroid/widget/TextView;->setSelected(Z)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mTvUpdate:Landroid/widget/TextView;

    const v1, 0x7f152303

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUpdateOsNum:Landroid/widget/TextView;

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->getOsNameByRoAndGlobalSetting()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewIndicatorContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsNum:Landroid/widget/TextView;

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    goto :goto_47

    :cond_37
    const v1, 0x7f1522ff

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewIndicatorContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsNum:Landroid/widget/TextView;

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    :goto_47
    iget-boolean v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsPova:Z

    if-nez v0, :cond_4e

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->updateTvColor()V

    :cond_4e
    return-void
.end method

.method public static bridge synthetic v(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Landroid/content/ContentResolver;
    .registers 1

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    return-object p0
.end method

.method public static bridge synthetic w(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Landroid/content/Context;
    .registers 1

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method public static bridge synthetic y(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Z
    .registers 1

    iget-boolean p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsColorReversalMode:Z

    return p0
.end method

.method public static bridge synthetic z(Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;)Landroid/net/Uri;
    .registers 1

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOtaNewVersionUri:Landroid/net/Uri;

    return-object p0
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 7

    invoke-super {p0, p1}, Lcom/android/settings/core/c;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    invoke-virtual {p0}, Lcom/android/settings/core/c;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    instance-of v0, p1, Lcom/android/settingslib/widget/LayoutPreference;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_ed

    check-cast p1, Lcom/android/settingslib/widget/LayoutPreference;

    invoke-static {}, LP5/m;->l()Z

    move-result v0

    if-eqz v0, :cond_20

    const v0, 0x7f0e0506

    invoke-virtual {p1, v0}, Landroidx/preference/Preference;->setLayoutResource(I)V

    goto :goto_33

    :cond_20
    invoke-static {}, LP5/m;->h()Z

    move-result v0

    if-eqz v0, :cond_2d

    const v0, 0x7f0e0505

    invoke-virtual {p1, v0}, Landroidx/preference/Preference;->setLayoutResource(I)V

    goto :goto_33

    :cond_2d
    const v0, 0x7f0e0504

    invoke-virtual {p1, v0}, Landroidx/preference/Preference;->setLayoutResource(I)V

    :goto_33
    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0867

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Lcom/transsion/trandesign/card/TileCardView;

    new-instance v3, Lcom/transsion/settings/connecteddevice/c;

    const/4 v4, 0x1

    invoke-direct {v3, p0, v4}, Lcom/transsion/settings/connecteddevice/c;-><init>(Ljava/lang/Object;I)V

    invoke-virtual {v0, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0850

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsNum:Landroid/widget/TextView;

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->getOsNameByRoAndGlobalSetting()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0220

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mTvUpdate:Landroid/widget/TextView;

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    const-string v3, "accessibility_display_inversion_enabled"

    invoke-static {v0, v3, v2}, Landroid/provider/Settings$Secure;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    if-ne v0, v1, :cond_74

    move v0, v1

    goto :goto_75

    :cond_74
    move v0, v2

    :goto_75
    iput-boolean v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsColorReversalMode:Z

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0866

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mCardBackground:Landroid/widget/ImageView;

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0869

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsLogo:Landroid/widget/ImageView;

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v3, 0x7f0b0868

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/LinearLayout;

    iput-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewIndicatorContainer:Landroid/widget/LinearLayout;

    iget-object p1, p1, Lcom/android/settingslib/widget/LayoutPreference;->d:Landroid/view/View;

    const v0, 0x7f0b0c99

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mUpdateOsNum:Landroid/widget/TextView;

    :cond_ed
    const-string p1, "persist.sys.tran.device.name"

    invoke-static {p1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_102

    const-string v0, "POVA"

    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_102

    goto :goto_103

    :cond_102
    move v1, v2

    :goto_103
    iput-boolean v1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mIsPova:Z

    if-eqz v1, :cond_118

    iget-object p1, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mCardBackground:Landroid/widget/ImageView;

    const v0, 0x7f080ee4

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageResource(I)V

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsLogo:Landroid/widget/ImageView;

    const p1, 0x7f080ee6

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    return-void

    :cond_118
    const-string p1, "X6873"

    const-string v0, "X6876"

    const-string v1, "X6739"

    const-string v3, "X6871"

    const-string v4, "X6872"

    filled-new-array {v1, v3, v4, p1, v0}, [Ljava/lang/String;

    move-result-object p1

    sget-object v0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    :goto_128
    const/4 v1, 0x5

    if-ge v2, v1, :cond_13f

    aget-object v1, p1, v2

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_13c

    iget-object p0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mOsLogo:Landroid/widget/ImageView;

    const p1, 0x7f080e72

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    return-void

    :cond_13c
    add-int/lit8 v2, v2, 0x1

    goto :goto_128

    :cond_13f
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic getBackgroundWorkerClass()Ljava/lang/Class;
    .registers 1

    const/4 p0, 0x0

    return-object p0
.end method

.method public bridge synthetic getIntentFilter()Landroid/content/IntentFilter;
    .registers 1

    const/4 p0, 0x0

    return-object p0
.end method

.method public bridge synthetic getSliceHighlightMenuRes()I
    .registers 1
    .annotation build Landroidx/annotation/StringRes;
    .end annotation

    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic hasAsyncUpdate()Z
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic isPublicSlice()Z
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic isSliceable()Z
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method public onPause()V
    .registers 1

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->unregisterObserve()V

    return-void
.end method

.method public onResume()V
    .registers 4

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->registerObserve()V

    iget-object v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mContentResolver:Landroid/content/ContentResolver;

    const-string v1, "ota_new_version"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->mNewVersion:I

    invoke-direct {p0}, Lcom/transsion/settings/deviceinfo/aboutphone/OsVersionController;->updateUI()V

    return-void
.end method

.method public bridge synthetic useDynamicSliceSummary()Z
    .registers 1

    const/4 p0, 0x0

    return p0
.end method
