// Build directory configuration
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    
    afterEvaluate {
        // Force all Android subprojects to use compileSdk 36
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            compileSdkVersion(36)
            // Inject namespace for old plugins that only declared it in AndroidManifest.xml
            if (namespace.isNullOrEmpty()) {
                namespace = project.group.toString().ifEmpty {
                    val manifest = project.file("src/main/AndroidManifest.xml")
                    if (manifest.exists()) {
                        val pkg = Regex("""package\s*=\s*"([^"]+)"""")
                            .find(manifest.readText())?.groupValues?.get(1)
                        pkg ?: "com.${project.name.replace("-", ".")}"
                    } else {
                        "com.${project.name.replace("-", ".")}"
                    }
                }
            }
        }
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}

