# Flutter engine — FlutterJNI resolves these via JNI by name at native attach.
# Without these keeps, R8 obfuscates them and performNativeAttach crashes (SIGSEGV).
-keep class io.flutter.** { *; }
-keep interface io.flutter.** { *; }
-dontwarn io.flutter.**

-keep class com.builttoroam.devicecalendar.** { *; }
# Behalte AndroidX Window-Klassen
-keep class androidx.window.** { *; }
-keep interface androidx.window.** { *; }
-dontwarn androidx.window.**

# Behalte Sidecar-Klassen
-keep class androidx.window.sidecar.** { *; }
-keep interface androidx.window.sidecar.** { *; }
-dontwarn androidx.window.sidecar.**


