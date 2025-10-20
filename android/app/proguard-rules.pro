-keep class com.builttoroam.devicecalendar.** { *; }
# Behalte AndroidX Window-Klassen
-keep class androidx.window.** { *; }
-keep interface androidx.window.** { *; }
-dontwarn androidx.window.**

# Behalte Sidecar-Klassen
-keep class androidx.window.sidecar.** { *; }
-keep interface androidx.window.sidecar.** { *; }
-dontwarn androidx.window.sidecar.**


