import 'dart:ui';

import 'package:flutter/material.dart';
import 'base/flutterbase.dart';
import 'simple_page_widgets.dart';
import 'flutterview.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {
  switch (route) {
    case "flutterview":
      return Flutterview();
    case "route1":
      return MyApp();
    case "route2":
      return SecondRouteWidget();
    case "/":
      return MyApp();
    default:
      return Container(
        color: Colors.white,
        child: Center(
            child: Text(
          "Unkonw route: $route",
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.red, fontSize: 25),
        )),
      );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String upContent;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _setBackContent(String content) {
    setState(() {
      upContent = content;
    });
  }

  Widget backView() => upContent != null && upContent.isNotEmpty
      ? Padding(padding: EdgeInsets.all(20), child: Text(upContent))
      : Text("Nothing");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomHome(),
            Text(
              'You have pushed the button this many times:',
            ),
            backView(),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              child: Text("打开提示页面"),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TipRoute(
                              text: "我是提示 xxx,传过来的数据",
                            )));
                if (result is String && result.isNotEmpty) {
                  _setBackContent(result);
                }else
                  _setBackContent(null);
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PushWidget()));
              },
              child: Text('开启一个新的'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
