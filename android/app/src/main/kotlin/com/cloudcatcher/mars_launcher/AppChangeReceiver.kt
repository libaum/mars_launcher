package com.cloudcatcher.mars_launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.plugin.common.MethodChannel

class AppChangeReceiver(private val channel: MethodChannel) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (Intent.ACTION_PACKAGE_ADDED == action || Intent.ACTION_PACKAGE_REMOVED == action) {
            val packageName = intent.data?.schemeSpecificPart
            channel.invokeMethod("onAppChanged", packageName)
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