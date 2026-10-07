allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// EL PARCHE DE ISAR (Excluyendo 'app' para evitar el choque)
subprojects {
    if (project.name != "app") {
        afterEvaluate {
            val androidExt = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            if (androidExt != null) {
                if (androidExt.namespace == null) {
                    androidExt.namespace = group.toString()
                }
                androidExt.compileSdkVersion(36)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}