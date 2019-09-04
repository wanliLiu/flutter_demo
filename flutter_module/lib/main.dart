import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_module/common/Global.dart';
import 'package:flutter_module/redux/app.dart';
import 'package:flutter_module/routes/progress.dart';
import 'package:flutter_module/routes/tab_home.dart';
import 'package:flutter_module/widget/DoubleTapExit.dart';

import 'flutterDemo.dart';
import 'routes/textfiled.dart';

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
  runZoned(
      () => Global.init()
          .then((e) => runApp(_widgetForRoute(window.defaultRouteName))),
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
      return createApp();
    case "route2":
      return SecondRouteWidget();
    case "/":
      return MyApp();
//      return createApp();
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
        "LaunchHome": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        "textFIled": (context) {
          var data = ModalRoute.of(context).settings.arguments
              as LinkedHashMap<String, String>;
          return TextFiledPage(
              defaultName: data["account"], defaultPwd: data["pwd"]);
        }
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
            case "progressIndictor":
              widget = ProgressPage();
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get tabBarView => TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          Widget deschild = Text(
            "没有页面",
            textScaleFactor: 2,
          );
          switch (e) {
            case "新闻":
              deschild = HomeView();
              break;
            case "历史":
            case "图片":
              deschild = Container(
                constraints: BoxConstraints.expand(),
                color: Colors.grey,
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text(
                  e,
                  textScaleFactor: 5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
              break;
          }
          return deschild;
        }).toList(),
      );

  Widget get _homeView => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            controller: _tabController,
            tabs: tabs
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ),
          leading: Builder(
              builder: (context) => IconButton(
                  icon: Icon(Icons.memory),
                  onPressed: () => Scaffold.of(context).openEndDrawer())),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), title: Text("Redux")),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), title: Text("School")),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.red,
          onTap: _onItemTapped,
        ),
//        backgroundColor: Colors.grey[100],
        drawer: MyDrawer(),
        endDrawer: MyDrawer(),
        body: tabBarView,
        floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                  onPressed: () {
                    //调用ScaffoldState的showSnackBar来弹出SnackBar
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("我是SnackBar")));
//                    _incrementCounter();
                    ChangeNotifierProvider.of<Increment>(context,
                            isListen: false)
                        .changeValue();
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );

  @override
  Widget build(BuildContext context) {
    return DoubleTapExit(
        child: ChangeNotifierProvider<Increment>(
      data: Increment(),
      child: _homeView,
    ));
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Container(
            child: Column(
              children: <Widget>[
                ClipOval(
                    child: Image.asset(
                  "imgs/like.jpeg",
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text("Add account"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Manage accounts"),
                      )
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("imgs/like.jpeg"),
                ),
              ],
            ),
          )),
    );
  }
}
