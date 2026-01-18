# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Prevent R8 from removing TFLite methods
-dontwarn org.tensorflow.lite.**
-dontwarn org.tensorflow.lite.gpu.**