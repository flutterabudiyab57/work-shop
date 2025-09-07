plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.abu_diyab_workshop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13846066"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.abu_diyab_workshop"
        minSdkVersion(flutter.minSdkVersion)
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }


    buildTypes {
        release {
            // لو عندك signingConfig جاهز ضيفه هنا، لو لأ خليها debug مؤقتًا
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
