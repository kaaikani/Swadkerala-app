plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    
    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.untitled2"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    // APK splitting disabled to avoid ABI conflicts
    // splits {
    //     abi {
    //         isEnable = true
    //         reset()
    //         include("arm64-v8a", "armeabi-v7a")
    //         exclude("x86", "x86_64")
    //         isUniversalApk = false
    //     }
    // }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // Enable aggressive code shrinking, obfuscation, and optimization
            isMinifyEnabled = true
            isShrinkResources = true
            isZipAlignEnabled = true
            isDebuggable = false
            
            // ProGuard rules for optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // Additional optimizations
            ndk {
                debugSymbolLevel = "NONE"
            }
            
            // Additional build optimizations
            buildConfigField("boolean", "DEBUG", "false")
            manifestPlaceholders["appName"] = "Madurai Store"
        }
        debug {
            // Disable minification for debug builds
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
    
    // Flutter build optimizations
    target = "lib/main.dart"
}
