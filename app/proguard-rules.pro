# Meowoirs ProGuard rules

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Google UMP (User Messaging Platform)
-keep class com.google.android.ump.** { *; }
-dontwarn com.google.android.ump.**

# Room
-keep class androidx.room.** { *; }
-dontwarn androidx.room.**
