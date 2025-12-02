// Build directory configuration
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    
    // Exclude fluttertoast from all configurations
    afterEvaluate {
        configurations.all {
            exclude(group = "io.github.ponnamkarthik.toast", module = "fluttertoast")
        }
        
        // Force all Android subprojects to use compileSdk 36
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            compileSdkVersion(36)
        }
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}

