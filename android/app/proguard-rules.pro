# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep GraphQL generated classes
-keep class **.graphql.** { *; }

# Keep GetX classes
-keep class com.github.jonataslaw.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Razorpay classes
-keep class com.razorpay.** { *; }

# Keep Google Play Core classes (required for Flutter split install)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Flutter Play Store split install classes
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep line numbers for stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Additional size optimizations - More aggressive
-optimizationpasses 9
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Remove logging - More comprehensive
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Remove debug prints
-assumenosideeffects class kotlin.io.ConsoleKt {
    public static *** println(...);
}

# Remove Flutter debug prints (if any)
-assumenosideeffects class dart.core.** {
    public static *** print(...);
}

# Aggressive optimization - Maximum compression
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-allowaccessmodification
-repackageclasses ''

# Remove unused code more aggressively
-dontpreverify
-verbose

# Remove unused string resources
-assumenosideeffects class java.lang.String {
    public boolean equals(java.lang.Object);
}

# Keep only essential attributes
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*,InnerClasses,EnclosingMethod,Signature

# More aggressive class merging
-allowaccessmodification
-repackageclasses ''

# Remove speech_to_text debug symbols if not needed
-keep class com.csdcorp.speech_to_text.** { *; }

# Optimize DEX files - reduce method count
-dontwarn kotlin.**
-dontwarn kotlinx.**
-dontwarn javax.annotation.**

# More aggressive size reduction
-optimizationpasses 5
-dontpreverify
-repackageclasses ''
-allowaccessmodification
-mergeinterfacesaggressively
-overloadaggressively

# Remove more unused code
-assumenosideeffects class * {
    public *** get*(...);
    public void set*(...);
}

# Strip line numbers (saves space but makes debugging harder)
-keepattributes SourceFile
-renamesourcefileattribute SourceFile
