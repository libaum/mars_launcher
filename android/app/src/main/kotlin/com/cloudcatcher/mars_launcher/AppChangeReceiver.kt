package com.cloudcatcher.mars_launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.plugin.common.MethodChannel

class AppChangeReceiver(private val channel: MethodChannel) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val packageName = intent.data?.schemeSpecificPart ?: return
        val isReplacing = intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)
        when {
            intent.action == Intent.ACTION_PACKAGE_REMOVED && !isReplacing ->
                channel.invokeMethod("onAppRemoved", packageName)
            intent.action == Intent.ACTION_PACKAGE_ADDED ->
                channel.invokeMethod("onAppInstalled", packageName)
        }
    }

    companion object {
        fun registerReceiver(context: Context, channel: MethodChannel) {
            val receiver = AppChangeReceiver(channel)
            val filter = IntentFilter().apply {
                addAction(Intent.ACTION_PACKAGE_ADDED)
                addAction(Intent.ACTION_PACKAGE_REMOVED)
                addDataScheme("package")
            }
            context.registerReceiver(receiver, filter)
        }
    }
}