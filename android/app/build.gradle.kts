plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

val firebaseBomVersion = "33.15.0"

android {
    namespace = "com.example.college_alert_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    buildToolsVersion = "33.0.0"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

   signingConfigs {
    create("release") {
        // Replace with real keystore config if needed
        storeFile = rootProject.file("release.keystore")
        storePassword = "your_release_store_password"
        keyAlias = "your_release_key_alias"
        keyPassword = "your_release_key_password"
    }
}


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(enforcedPlatform("com.google.firebase:firebase-bom:$firebaseBomVersion"))
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-analytics")
}
