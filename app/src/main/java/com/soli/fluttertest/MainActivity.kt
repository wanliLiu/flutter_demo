package com.soli.fluttertest

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.FrameLayout
import io.flutter.facade.Flutter
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        flutterView.setOnClickListener {
            addFlutterView()
        }

        flutterFragment.setOnClickListener {
            addFlutterFragment()
        }

        flutterFull.setOnClickListener {
            startActivity(
                Intent(this, TestFlutterActivity::class.java).putExtra(
                    "initial_route",
                    "route1"
                )
            )
        }
    }

    /**
     *
     */
    private fun addFlutterView() {
        container.removeAllViews()
        container.addView(
            Flutter.createView(this, lifecycle, "flutterview"),
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
    }

    private fun addFlutterFragment() {
        container.removeAllViews()
        supportFragmentManager.beginTransaction()
            .replace(R.id.container, Flutter.createFragment("route1")).commit()
    }
}
