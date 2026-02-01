import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.projectDir.resolve("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.futuredesh.murgi_care"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    aaptOptions {
        noCompress("tflite")
        noCompress("lite")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.futuredesh.murgi_care"
        
        // TFLite and Camera plugins work best with minSdk 21+
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Enables R8 shrinking and optimization
            isMinifyEnabled = true 
            isShrinkResources = true
            
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            // Link to the signing config defined above
            signingConfig = signingConfigs.getByName("release")

            // 2026 Android requirement for 16 KB page alignment
            packaging {
                jniLibs {
                    useLegacyPackaging = true
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
