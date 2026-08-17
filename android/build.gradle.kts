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
subprojects {
    project.evaluationDependsOn(":app")
}

// 统一所有 Android 子模块（含 file_picker 等第三方插件）的 compileSdk 为 36，
// 以匹配 flutter_plugin_android_lifecycle 对 ≥36 的要求，否则 AAR 元数据检查失败。
// 用 plugins.withId 回调：Android 插件一应用即在配置阶段生效，不依赖 afterEvaluate
// （subprojects 里已有 evaluationDependsOn，模块会被提前评估，afterEvaluate 会报错）。
subprojects {
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.gradle.BaseExtension>("android") {
            compileSdkVersion(36)
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.BaseExtension>("android") {
            compileSdkVersion(36)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
