import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class DemoStatusBar extends StatefulWidget {
  @override
  _DemoStatusBarStates createState() => _DemoStatusBarStates();
}

class _DemoStatusBarStates extends State<DemoStatusBar> {
  final _random = math.Random();
  SystemUiOverlayStyle _currentStyle =
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
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  "1.Flutter 希望，设置状态栏原色和设置屏幕方向这些，等等都直接通过Flutter来设置，SystemChrome\n"
                      "\n2.AnnotatedRegion设置通过layer方式",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RaisedButton(
                child: const Text('Change Color'),
                onPressed: _changeColor,
              ),
              RaisedButton(
                child: const Text('设置'),
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
                      .dark
                      .copyWith(statusBarColor: Colors.red));
                },
              ),
              RaisedButton(
                child: Tooltip(
                  message: "相当于限制方向，和Android中代码写死效果一样",
                  child: const Text('设置屏幕方向'),
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
              RaisedButton(
                child: const Text('setEnabledSystemUIOverlays'),
                onPressed: () {
                  SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[
                    SystemUiOverlay.top,
                    SystemUiOverlay.bottom
                  ]);
                },
              ),
            ],
          )),
    );

//    return child;

    return Material(
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: child,
    );
  }
}
