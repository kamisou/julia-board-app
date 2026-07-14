import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    // Compose compiler, required by the Jetpack Glance home widget.
    id("org.jetbrains.kotlin.plugin.compose")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Shared config lives in the Flutter `.env` (consumed by Dart via
// `--dart-define-from-file`). The native home widget fetches the board on its
// own, so mirror those values into BuildConfig for the Glance widget to read.
val flutterEnv = Properties().apply {
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) envFile.inputStream().use { load(it) }
}

fun env(key: String): String =
    (flutterEnv.getProperty(key) ?: "").trim().trim('"')

android {
    namespace = "br.com.kamis.julia_board"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.com.kamis.julia_board"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        buildConfigField("String", "API_BASE_URL", "\"${env("API_BASE_URL")}\"")
        buildConfigField("String", "APP_USER", "\"${env("APP_USER")}\"")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // Jetpack Glance powers the home screen widget.
    implementation("androidx.glance:glance-appwidget:1.1.1")
}

flutter {
    source = "../.."
}
