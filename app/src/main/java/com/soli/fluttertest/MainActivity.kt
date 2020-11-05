package com.soli.fluttertest

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.android.*
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), SplashScreenProvider {

    // Declare a local variable to reference the FlutterFragment so that you
    // can forward calls to it later.
    private var fluFragment: FlutterFragment? = null

    private var useCacheFlutterEngine = true

    companion object {
        // Define a tag String to represent the FlutterFragment within this
        // Activity's FragmentManager. This value can be whatever you'd like.
        private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
        private const val pre_warm_engien_id = "test_idsd"
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        flutterView.setOnClickListener {
            addFlutterView()
        }

        flutterFragment.setOnClickListener {
            addFlutterFragment()
        }

        flutterEmbeding.setOnClickListener {
            //            startActivity(FlutterActivity.withNewEngine().initialRoute("/").build(this))
            startActivity(
                Intent(this, EmbedingFlutterActivity::class.java).apply {
                    putExtra("initial_route", "/")
                    putExtra("background_mode", "opaque")
                    putExtra("destroy_engine_with_activity", true)
                }
            )
        }

        transparency.setOnClickListener {
            if (useCacheFlutterEngine) {
                startActivity(
                    Intent(this, FlutterActivity::class.java).apply {
                        putExtra("cached_engine_id", pre_warm_engien_id)
                        putExtra("background_mode", "transparent")
                        putExtra("destroy_engine_with_activity", false)
                    }
                )
            } else {
                startActivity(
                    Intent(this, FlutterActivity::class.java).apply {
                        putExtra("initial_route", "/")
                        putExtra("background_mode", "transparent")
                        putExtra("destroy_engine_with_activity", true)
                    }
                )
            }
        }

        if (useCacheFlutterEngine)
            createPreWarmFlutterEngine()
    }

    /**
     * 提前创建引擎，减少等等的时间,这种指定
     */
    private fun createPreWarmFlutterEngine() {
        FlutterEngineCache.getInstance().put(pre_warm_engien_id, FlutterEngine(this).apply {
            navigationChannel.setInitialRoute("flutterview")
            //这里就开始运行Dart 代码 runApp了，所以要指定初始route，必须在这之前，不然不管用
            dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        })
    }

    /**
     *
     */
    private fun addFlutterView() {
//        container.removeAllViews()
//        container.addView(
//            FlutterView(this),
//            FrameLayout.LayoutParams.MATCH_PARENT,
//            FrameLayout.LayoutParams.MATCH_PARENT
//        )
    }

    private fun addFlutterFragment() {

        // Get a reference to the Activity's FragmentManager to add a new
        // FlutterFragment, or find an existing one.
        val fragmentManager: FragmentManager = supportFragmentManager
        // Attempt to find an existing FlutterFragment, in case this is not the
        // first time that onCreate() was run.
        fluFragment = fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as? FlutterFragment?

        if (fluFragment == null) {
            fluFragment =
                if (useCacheFlutterEngine) {
                    FlutterFragment.withCachedEngine(pre_warm_engien_id)
                        .renderMode(RenderMode.surface)
                        .build()
                } else
                    FlutterFragment.withNewEngine()
                        .initialRoute("flutterview")
                        .renderMode(RenderMode.surface)
                        .build()

//            container.removeAllViews()
            fragmentManager.beginTransaction()
                .add(R.id.container, fluFragment as Fragment).commit()
        } else {
            fragmentManager.beginTransaction().show(fluFragment as Fragment).commit()
        }

    }

    override fun provideSplashScreen(): SplashScreen? {
        return DrawableSplashScreen(resources.getDrawable(R.drawable.launch_background, theme))
    }

    //目前这个demo来讲还有点问题
//    override fun onPostResume() {
//        super.onPostResume()
//        fluFragment?.onPostResume()
//    }

    override fun onNewIntent(@NonNull intent: Intent) {
        super.onNewIntent(intent)
        fluFragment?.onNewIntent(intent)
    }

//    override fun onBackPressed() {
//        fluFragment?.onBackPressed()
//    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        fluFragment?.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    override fun onUserLeaveHint() {
        fluFragment?.onUserLeaveHint()
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        fluFragment?.onTrimMemory(level)
    }
}
