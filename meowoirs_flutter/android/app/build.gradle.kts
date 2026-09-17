import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.limanex.meowoirs"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.limanex.meowoirs"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Secure Release Signing Configuration
    val keystorePropertiesFile = listOf(
        rootProject.file("keystore.properties"),
        rootProject.file("key.properties"),
        rootProject.file("../keystore.properties"),
        rootProject.file("../../keystore.properties")
    ).firstOrNull { it.exists() && it.canRead() }

    val keystoreProperties = Properties()
    if (keystorePropertiesFile != null) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    val releaseStoreFile = keystoreProperties.getProperty("storeFile") ?: System.getenv("KEYSTORE_FILE")
    val releaseStorePassword = keystoreProperties.getProperty("storePassword") ?: System.getenv("KEYSTORE_PASSWORD")
    val releaseKeyAlias = keystoreProperties.getProperty("keyAlias") ?: System.getenv("KEY_ALIAS")
    val releaseKeyPassword = keystoreProperties.getProperty("keyPassword") ?: System.getenv("KEY_PASSWORD")

    val resolvedKeyFile = if (!releaseStoreFile.isNullOrBlank()) {
        listOf(
            rootProject.file(releaseStoreFile),
            rootProject.file("../$releaseStoreFile"),
            rootProject.file("../../$releaseStoreFile"),
            file(releaseStoreFile)
        ).firstOrNull { it.exists() }
    } else null

    val hasReleaseSigning = resolvedKeyFile != null &&
            !releaseStorePassword.isNullOrBlank() &&
            !releaseKeyAlias.isNullOrBlank() &&
            !releaseKeyPassword.isNullOrBlank()

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = resolvedKeyFile
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
