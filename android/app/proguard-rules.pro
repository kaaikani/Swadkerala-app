# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# GraphQL (keep only used classes)
-keep class com.example.untitled2.graphql.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep serialization
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Ignore warnings for Google Play Core / Flutter deferred components
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Razorpay ProGuard rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepclassmembers class com.razorpay.** {
    *;
}

# Keep ProGuard annotations that Razorpay uses
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Keep Razorpay Analytics
-keep class com.razorpay.AnalyticsEvent { *; }
-keep class com.razorpay.AnalyticsEvent$* { *; }

# Optimization & access modifications
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# Remove debug info
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Remove unused string constants and exception prints
-assumenosideeffects class java.lang.String {
    public static java.lang.String valueOf(...);
}
-assumenosideeffects class java.lang.Throwable {
    public void printStackTrace();
    public void printStackTrace(java.io.PrintStream);
    public void printStackTrace(java.io.PrintWriter);
}
