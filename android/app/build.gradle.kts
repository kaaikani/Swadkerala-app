import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.kaaikani.kaaikani"
    compileSdk = 36
    buildToolsVersion = "36.0.0"
    ndkVersion = "29.0.14206865"

    buildFeatures {
        buildConfig = true
    }
    
    // Fix 16 KB Page Size Rejection - Ensure proper alignment
    // AGP 8.5.1+ automatically handles 16 KB alignment, but we ensure it's configured
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.kaaikani.kaaikani"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        
        // Limit resource configurations to reduce size - only include needed languages
        // This significantly reduces APK size by excluding unused language resources
        // Note: resourceConfigurations is deprecated, using androidResources.localeFilters instead
        // androidResources.localeFilters += listOf("en", "hi") // Only include English and Hindi resources
        
        // For universal APK: Only ARM architectures (exclude x86/x86_64 to reduce size)
        // This covers 99%+ of real devices while reducing APK size by ~15-20MB
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }
        
        // Enable resource shrinking to remove unused resources
        // This can reduce APK size by 10-30%
        resConfigs("en", "hi") // Only include English and Hindi resources
        
        // Remove debug validation layers to reduce size
        packaging {
            jniLibs {
                excludes += listOf(
                    "**/libVkLayer*.so",
                    "**/libVkLayer_khronos_validation.so"
                )
            }
        }
    }

    // Split APKs by architecture to reduce size
    // Note: When using --split-per-abi, Flutter automatically configures splits
    // Don't configure splits here to avoid conflicts

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        getByName("release") {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Use debug signing if no release keystore is configured
                signingConfig = signingConfigs.getByName("debug")
            }

            // Enable aggressive optimization to reduce APK size
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Note: isZipAlignEnabled is deprecated - AGP automatically aligns APKs
            isDebuggable = false

            ndk {
                // Use FULL to avoid stripping errors - Play Console recommends this for crash analysis
                // FULL includes all debug symbols without attempting to strip them
                // This prevents the "failed to strip debug symbols" error
                debugSymbolLevel = "FULL"
            }
            
            // Additional size optimizations
            multiDexEnabled = true
            
            // Fix 16 KB Page Size Rejection - Ensure proper alignment
            // AGP 8.5.1+ automatically handles this, but we ensure it's configured
            packaging {
                jniLibs {
                    useLegacyPackaging = false
                    // Remove debug validation layers to reduce size
                    excludes += listOf(
                        "**/libVkLayer*.so",
                        "**/libVkLayer_khronos_validation.so"
                    )
                }
                // Remove unnecessary files to reduce APK size
                resources {
                    excludes += listOf(
                        "META-INF/DEPENDENCIES",
                        "META-INF/LICENSE",
                        "META-INF/LICENSE.txt",
                        "META-INF/license.txt",
                        "META-INF/NOTICE",
                        "META-INF/NOTICE.txt",
                        "META-INF/notice.txt",
                        "META-INF/ASL2.0",
                        "META-INF/*.kotlin_module",
                        "META-INF/services/*",
                        "**/attach_hotspot_windows.dll",
                        "META-INF/licenses/**",
                        "META-INF/AL2.0",
                        "META-INF/LGPL2.1"
                    )
                }
            }

            buildConfigField("boolean", "DEBUG", "false")
            // manifestPlaceholders - use putAll to add values
            manifestPlaceholders.putAll(mapOf("appName" to "Kaaikani"))
        }
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
    target = "lib/main.dart"
}

configurations.all {
    resolutionStrategy {
        force("androidx.core:core:1.15.0")
        force("androidx.core:core-ktx:1.15.0")
    }
    // Exclude FlutterToastPlugin from transitive dependencies
    exclude(group = "io.github.ponnamkarthik.toast", module = "fluttertoast")
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))
    implementation("com.google.firebase:firebase-messaging")
    // Force newer AndroidX Core to support lStar attribute
    implementation("androidx.core:core:1.15.0")
    implementation("androidx.core:core-ktx:1.15.0")
}

// Note: Flutter 2.0+ automatically registers plugins, so GeneratedPluginRegistrant
// is not needed to be called manually. The Java file is generated by Flutter
// and can be used if needed, but plugins are auto-registered.

// Fix 16 KB Page Size Rejection - Re-align APK with 64 KB alignment
// This task will be called after Flutter builds the APK
tasks.register("realignApkFor16KB") {
    doLast {
        var flutterApkDir = file("${layout.buildDirectory.get().asFile.parentFile}/../flutter-apk")
        if (!flutterApkDir.exists()) {
            flutterApkDir = file("${project.rootDir}/../build/app/outputs/flutter-apk")
        }
        
        val apkFiles = fileTree(flutterApkDir) {
            include("**/*.apk")
            exclude("**/*-aligned.apk")
        }
        
        if (apkFiles.isEmpty) {
            println("No APK files found in ${flutterApkDir.absolutePath}")
            return@doLast
        }
        
        val androidExtension = project.extensions.getByName<com.android.build.gradle.AppExtension>("android")
        val sdkDir = androidExtension.sdkDirectory
        val buildToolsVersion = androidExtension.buildToolsVersion
        val zipalign = "$sdkDir/build-tools/$buildToolsVersion/zipalign"
        val zipalignFile = File(zipalign)
        if (!zipalignFile.exists()) {
            println("Warning: zipalign not found at $zipalign, skipping realignment")
            return@doLast
        }
        
        apkFiles.forEach { apkFile ->
            val alignedApk = File(apkFile.parent, apkFile.name.replace(".apk", "-aligned.apk"))
            
            println("Re-aligning ${apkFile.name} with 64 KB alignment for 16 KB page size support...")
            
            project.exec {
                commandLine(zipalign, "-f", "-v", "65536", apkFile.absolutePath, alignedApk.absolutePath)
                isIgnoreExitValue = false
            }
            
            // Replace original with aligned version
            if (alignedApk.exists()) {
                val backupApk = File(apkFile.parent, apkFile.name.replace(".apk", "-backup.apk"))
                apkFile.renameTo(backupApk)
                alignedApk.renameTo(apkFile)
                backupApk.delete()
                println("✓ Successfully re-aligned ${apkFile.name} with 64 KB alignment")
            } else {
                println("✗ Failed to create aligned APK for ${apkFile.name}")
            }
        }
    }
}
