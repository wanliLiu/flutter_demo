import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoStatusBar extends StatefulWidget {
  @override
  State<DemoStatusBar> createState() => _DemoStatusBarStates();
}

class _DemoStatusBarStates extends State<DemoStatusBar> {
  final _random = math.Random();
  final SystemUiOverlayStyle _currentStyle =
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);

  Color color = Colors.red;

  void _changeColor() {
    color = Color.fromRGBO(
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
      1.0,
    );
    setState(() {
      // _currentStyle = SystemUiOverlayStyle.dark.copyWith(
      //   statusBarColor: color,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnnotatedRegion<SystemUiOverlayStyle>(
      value: _currentStyle,
      child: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "1.Flutter 希望，设置状态栏原色和设置屏幕方向这些，等等都直接通过Flutter来设置，SystemChrome\n"
                  "\n2.AnnotatedRegion设置通过layer方式",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: _changeColor,
                child: const Text('Change Color'),
              ),
              ElevatedButton(
                child: const Text('设置'),
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
                      .copyWith(statusBarColor: Colors.red));
                },
              ),
              ElevatedButton(
                child: const Tooltip(
                  message: "相当于限制方向，和Android中代码写死效果一样",
                  child: Text('设置屏幕方向'),
                ),
                onPressed: () {
                  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
//                      DeviceOrientation.landscapeLeft,
                    DeviceOrientation.portraitDown,
                    // DeviceOrientation.portraitUp,
//                      DeviceOrientation.landscapeRight
                  ]);
                },
              ),
              ElevatedButton(
                child: const Text('setEnabledSystemUIOverlays'),
                onPressed: () {
                  // SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[
                  //   SystemUiOverlay.top,
                  //   SystemUiOverlay.bottom
                  // ]);
                },
              ),
            ],
          )),
    );

//    return child;

    return Material(
      color: color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: child,
    );
  }
}
