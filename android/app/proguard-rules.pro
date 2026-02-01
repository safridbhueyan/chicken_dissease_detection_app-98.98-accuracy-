# 1. TensorFlow Lite (Your Machine Learning Model)
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.**
-dontwarn org.tensorflow.lite.gpu.**

# 2. UCrop / image_cropper (The UI for cropping)
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

# 3. OkHttp3 & Okio (Network/File handling used by the cropper)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**

# 4. Flutter/AndroidX compatibility
-keep class androidx.appcompat.widget.** { *; }
-dontwarn com.google.errorprone.annotations.**