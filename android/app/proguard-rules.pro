# ==============================================================================
# PROGUARD / R8 OBFUSCATION RULES
# Aplikasi: Tes Buta Warna Lengkap
# ==============================================================================

# Flutter Core & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Unity Ads SDK Rules (Wajib agar iklan tidak error saat obfuscation aktif)
-keepattributes SourceFile,LineNumberTable
-keepattributes JavascriptInterface
-keep class com.unity3d.ads.** { *; }
-keep class com.unity3d.services.** { *; }
-dontwarn com.unity3d.services.**
-dontwarn com.unity3d.ads.**
-dontwarn com.unity3d.scar.**

# Google Play Services & Advertising ID
-keep class com.google.android.gms.ads.identifier.** { *; }
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.**

# Native Platform Plugins (Shared Preferences, Path Provider, Share Plus, Printing)
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class net.nfet.flutter.printing.** { *; }

# Optimasi Kompilator
-ignorewarnings
-repackageclasses
