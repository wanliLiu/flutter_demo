import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'flutterDemo.dart';

void collectLog(String line) {
  //收集日志
}

void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
}

void main() {
  //可以定义我们错误处理，比如日志上报，等等
  FlutterError.onError = (FlutterErrorDetails details) {
    //同时调用系统的，然后logcat打印出来
    assert(details != null);
    assert(details.exception != null);
    FlutterError.dumpErrorToConsole(details);

    reportErrorAndLog(details);

    //todo 比如错误日志收集统计上传

    //注意看，这里相当于执行下面这个
//    FlutterError.reportError(details);
  };

  //异步异常的捕获
  runZoned(() => runApp(_widgetForRoute(window.defaultRouteName)),
      //可以拦截
      zoneSpecification: ZoneSpecification(
          print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
    parent.print(zone, "日志可以被拦截：$line");
    collectLog(line);
  }), onError: (Object obj, StackTrace stack) {
    var details = makeDetails(obj, stack);
    reportErrorAndLog(details);
  });
}

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
      initialRoute: "LaunchHome",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "First": (context) => FirstRouteWidget(),
        "Second": (context) => SecondRouteWidget(),
        "Tab": (context) => TabRouteWidget(),
        "FlutterRoute": (context) {
          var data = ModalRoute.of(context).settings.arguments;
          debugPrint("FlutterRoute---in--->$data");
          return FlutterRouteWidget(message: data ?? "路由传入的数据");
        },
        "LaunchHome": (context) => MyHomePage(title: 'Flutter Demo Home Page')
      },
      //没有注册的路由，才会走这里，这里通常可以做一些权限的控制，比如满足什么才进行什么
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          //比如这里可以检测是否需要登录进入某些页面，如果没有登录，那么就跳登录页面，反之其他页面
          debugPrint("onGenerateRoute--->${settings.toString()}");
          Widget widget;
          switch (settings.name) {
            case "SecondOther":
              {
                widget = SecondRouteWidget();
              }
              break;
            case "Tips":
              {
                var input = settings.arguments;
                debugPrint("Tips--in-->$input");
                widget = TipRoute(
                  text: input ?? "我是提示 xxx,传过来的数据",
                );
              }
              break;
            default:
              {
                widget = TabRouteWidget(
                  from: "onGenerateRoute 没有定义的Route : ${settings.toString()}",
                );
              }
              break;
          }

          return widget;
        });
      },
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
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[TapBoxA(), ParentWidget(), ParentWidgetC()],
          ),
          Column(
            children: <Widget>[
              CustomHome(),
              backView(),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
          Wrap(spacing: 10, children: <Widget>[
            RaisedButton(
              child: Text("打开提示页面(返回值）"),
              onPressed: () async {
                var result = await Navigator.pushNamed(context, "Tips",
                    arguments: "Hello,我是通过onGenerateRoute过来的，并获取返回来的数据,注意：\n\n"
                        "1.通过没有注册的路由传过来的参数是在：RouteSettings.arguments\n\n"
                        "2.通过注册路由传过来的参数，是通过：ModalRoute.of(context).settings.arguments获取\n\n"
                        "以上两点尤其要注意\n\n");

                debugPrint("路由返回值：$result");

                if (result is String && result.isNotEmpty) {
                  _setBackContent(result);
                } else
                  _setBackContent(null);
              },
            ),
            RaisedButton(
              child: Text('开启一个新的'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PushWidget()));
              },
            ),
            RaisedButton(
              child: Text("目标节点获取参数"),
              onPressed: () {
                Navigator.pushNamed(context, "FlutterRoute",
                    arguments: "不在Target里面获取参数，直接在路由那里的时候获取（外面获取）");
              },
            ),
            RaisedButton(
              child: Text("通过路由打开"),
              onPressed: () {
                Navigator.pushNamed(context, "First",
                    arguments: "命名路由参数传递样例,在里面获取");
              },
            ),
            RaisedButton(
              child: Text("未注册：onGenerateRoute"),
              onPressed: () {
//                Navigator.pushNamed(context, "SecondOther");
                Navigator.of(context).pushNamed("SecondOther");
              },
            ),
          ]),
          Flutterview(),
        ],
      ),
      floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
                onPressed: () {
                  //调用ScaffoldState的showSnackBar来弹出SnackBar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("我是SnackBar")));
                  _incrementCounter();
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              )),
    );
  }
}
