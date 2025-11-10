plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.koka"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.koka"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }
    buildTypes {
        release { signingConfig = signingConfigs.getByName("debug") }
    }
}

flutter { source = "../.." }

// اتركِي قسم dependencies فارغًا من Firebase تمامًا
dependencies {
    // (هنا لا تضعي أي Firebase)
}
