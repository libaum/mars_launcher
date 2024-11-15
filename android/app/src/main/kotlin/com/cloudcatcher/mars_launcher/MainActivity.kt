package com.cloudcatcher.mars_launcher

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity class that sets up method channels for communication between Flutter and native Android code.
 */
class MainActivity : FlutterActivity() {
    private val CHANNEL_OPEN_DEFAULT_LAUNCHER_SETTINGS = "com.cloudcatcher.mars_launcher/open_default_launcher_settings"
    private val CHANNEL_NOTIFY_APP_CHANGES = "com.cloudcatcher.mars_launcher/notify_app_changes"
    private val CHANNEL_INSTALLED_APPS = "com.cloudcatcher.mars_launcher/installed_apps"
    private val CHANNEL_LAUNCH_APP = "com.cloudcatcher.mars_launcher/launch_app"
    private val CHANNEL_OPEN_APP_SETTINGS = "com.cloudcatcher.mars_launcher/open_app_settings"

    /**
     * Called when the activity is starting. Sets up method channels for Flutter communication.
     * @param savedInstanceState If the activity is being re-initialized after previously being shut down then this Bundle contains the data it most recently supplied in onSaveInstanceState(Bundle).
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val messenger = flutterEngine?.dartExecutor?.binaryMessenger ?: return

        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            // MethodChannel for retrieving installed apps
            MethodChannel(messenger, CHANNEL_INSTALLED_APPS).setMethodCallHandler { call, result ->
                if (call.method == "getInstalledApps") {
                    val apps = getInstalledApps()
                    result.success(apps)
                } else {
                    result.notImplemented()
                }
            }

            // MethodChannel for launching an app
            MethodChannel(messenger, CHANNEL_LAUNCH_APP).setMethodCallHandler { call, result ->
                if (call.method == "launchApp") {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val success = launchApp(packageName)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

            // MethodChannel for opening the app settings page
            MethodChannel(messenger, CHANNEL_OPEN_APP_SETTINGS).setMethodCallHandler { call, result ->
                if (call.method == "openAppSettings") {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val success = openAppSettings(packageName)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        }

        // MethodChannel for opening the default launcher settings
        MethodChannel(messenger, CHANNEL_OPEN_DEFAULT_LAUNCHER_SETTINGS).setMethodCallHandler { call, result ->
            when (call.method) {
                "openLauncherSettings" -> {
                    openDefaultLauncherSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // MethodChannel for notifying app changes
        MethodChannel(messenger, CHANNEL_NOTIFY_APP_CHANGES).setMethodCallHandler { call, result ->
            when (call.method) {
                "registerAppChangeReceiver" -> {
                    AppChangeReceiver.registerReceiver(this, MethodChannel(messenger, CHANNEL_NOTIFY_APP_CHANGES))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Opens the default launcher settings.
     */
    private fun openDefaultLauncherSettings() {
        startActivity(Intent(android.provider.Settings.ACTION_HOME_SETTINGS))
    }

    /**
     * Retrieves a list of installed apps, including system apps, but excluding apps without launch functionality.
     * @return A list of maps, each containing the package name, app name, and whether it is a system app.
     */
    private fun getInstalledApps(): List<Map<String, String>> {
        val pm: PackageManager = packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_META_DATA)
        val appList = mutableListOf<Map<String, String>>()

        for (packageInfo in packages) {
            if (packageInfo.packageName == "com.cloudcatcher.mars_launcher")
                continue
            // Check if the app has launch functionality
            val launchIntent = pm.getLaunchIntentForPackage(packageInfo.packageName)
            val appInfo = packageInfo.applicationInfo
            if (launchIntent != null && appInfo != null) {
                val appName = appInfo.loadLabel(pm)?.toString() ?: "unknown"
                val isSystemApp = (appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) != 0
                appList.add(mapOf(
                    "packageName" to packageInfo.packageName,
                    "appName" to appName,
                    "isSystemApp" to isSystemApp.toString())
                )
            }
        }

        return appList
    }

    /**
     * Launches an app given its package name.
     * @param packageName The package name of the app.
     * @return true if the app was successfully launched, false otherwise.
     */
    private fun launchApp(packageName: String): Boolean {
        return try {
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                startActivity(launchIntent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Opens the settings page for a specific app given its package name.
     * @param packageName The package name of the app.
     * @return true if the settings page was successfully opened, false otherwise.
     */
    private fun openAppSettings(packageName: String): Boolean {
        return try {
            val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = android.net.Uri.parse("package:$packageName")
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }
}