package com.soli.fluttertest

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

/**
 *
 * @author Soli
 * @Time 2019-08-26 18:02
 */
class DemoApplication : FlutterApplication() {

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}