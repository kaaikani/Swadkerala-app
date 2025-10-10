# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# GraphQL specific rules
-keep class com.example.untitled2.graphql.** { *; }
-keep class **$Mutation$** { *; }
-keep class **$Query$** { *; }
-keep class **$Subscription$** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep serialization classes
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

# Ignore missing Google Play Core classes
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Ignore Flutter deferred components
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# More aggressive optimization
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# Remove unused code
-dontwarn **
-ignorewarnings

# Remove debug information
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Remove unused resources
-dontshrink

# More aggressive optimization
-optimizationpasses 7
-allowaccessmodification
-dontpreverify
-dontwarn **
-ignorewarnings

# Remove all debug information
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Remove unused classes and methods
-assumenosideeffects class * {
    public static void log(...);
    public static void debug(...);
    public static void trace(...);
    public static void info(...);
    public static void warn(...);
    public static void error(...);
}

# Remove unused string constants
-assumenosideeffects class java.lang.String {
    public static java.lang.String valueOf(...);
}

# Remove unused exception handling
-assumenosideeffects class java.lang.Throwable {
    public void printStackTrace();
    public void printStackTrace(java.io.PrintStream);
    public void printStackTrace(java.io.PrintWriter);
}
