import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demon/common/Global.dart';
import 'package:flutter_demon/common/Toast.dart';

import 'package:flutter_demon/routes/demo_scroll.dart';
import 'package:flutter_demon/routes/progress.dart';
import 'package:flutter_demon/routes/tab_business.dart';
import 'package:flutter_demon/routes/tab_history.dart';
import 'package:flutter_demon/routes/tab_home.dart';
import 'package:flutter_demon/routes/tab_school.dart';
import 'package:flutter_demon/widget/DoubleTapExit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'flutterDemo.dart';
import 'routes/textfiled.dart';

void collectLog(String line) {
  //收集日志
}

void reportErrorAndLog(FlutterErrorDetails? details) {
  //上报错误和日志逻辑
}

FlutterErrorDetails? makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Twitter Api Demo');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupWindow();
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
    // case "route1":
    //   return createApp();
    case "route2":
      return SecondRouteWidget();
    case "/":
      return MyApp();
//      return createApp();
    default:
      return Container(
        color: Colors.transparent,
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
          appBarTheme: AppBarTheme(centerTitle: true)),
      routes: {
        "First": (context) => FirstRouteWidget(),
        "Second": (context) => SecondRouteWidget(),
        "Tab": (context) => TabRouteWidget(),
        "FlutterRoute": (context) {
          var data = ModalRoute.of(context)!.settings.arguments;
          debugPrint("FlutterRoute---in--->$data");
          return FlutterRouteWidget(message: data as String? ?? "路由传入的数据");
        },
        "LaunchHome": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        "textFIled": (context) {
          var data = ModalRoute.of(context)!.settings.arguments
              as LinkedHashMap<String, String>;
          return TextFiledPage(
              defaultName: data["account"]!, defaultPwd: data["pwd"]!);
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
                  text: input as String? ?? "我是提示 xxx,传过来的数据",
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
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List tabs = ["Base", "Clip", "Scroll"];

  int _selectedIndex = 0;
  int _tabSelect = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
    );
    _tabController!.addListener(_handleTabSelection);
  }

  void _eventbus(args) {
    VaeToast.showToast(args, gravity: ToastGravity.CENTER);
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController!.index;
      debugPrint("selectInde--->$_selectedIndex");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _tabSelect = index;
      debugPrint("_onTabTapped--->$_tabSelect");
    });
  }

  Widget? floatActionButton() {
    if (_selectedIndex == 0) {
      return Builder(
          builder: (context) => FloatingActionButton(
                onPressed: () {
                  context.read<Increment>().changeValue();
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ));
    } else if (_selectedIndex == 1) {
      return Builder(
          builder: (context) => FloatingActionButton.extended(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("我是SnackBar")));
                },
                tooltip: 'Increment',
                icon: const Icon(Icons.add),
                label: const Text("测试"),
              ));
    }

    return null;
  }

  Widget get tabBarView => TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          Widget deschild = const Text(
            "没有页面",
            textScaleFactor: 2,
          );
          switch (e) {
            case "Base":
              deschild = const HomeView(
                key: PageStorageKey("Base"),
              );
              break;
            case "Clip":
              deschild = TabHistory(
                key: const PageStorageKey("Clip"),
              );
              break;
            case "Scroll":
              deschild = InfiniteListView(
                key: const PageStorageKey("Scroll"),
              );
              break;
          }
          return deschild;
        }).toList(),
      );

  Widget get _homeView => Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          bottom: _tabSelect == 0
              ? TabBar(
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  unselectedLabelStyle: const TextStyle(fontSize: 16),
                  controller: _tabController,
                  tabs: tabs
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                )
              : null,
          leading: Builder(
              builder: (context) => IconButton(
                  icon: const Icon(Icons.memory),
                  onPressed: () => Scaffold.of(context).openEndDrawer())),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: "Business"),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: "School"),
          ],
          currentIndex: _tabSelect,
          fixedColor: Colors.red,
          onTap: _onTabTapped,
        ),
//        backgroundColor: Colors.grey[100],
        drawer: const MyDrawer(),
        endDrawer: const MyDrawer(),
        body: () {
          if (_tabSelect == 0) {
            return tabBarView;
          } else if (_tabSelect == 1) {
            return TabBusiness();
          } else {
            return TabSchool();
          }
        }(),
        floatingActionButton: floatActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );

  @override
  Widget build(BuildContext context) {
    return DoubleTapExit(
      child: MultiProvider(
        providers: [
          Provider<Increment>(
            create: (_) => Increment(),
          )
        ],
        child: _homeView,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            children: <Widget>[
              ClipOval(
                  child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              )),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  "Wendux",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: const <Widget>[
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text("Add account"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Manage accounts"),
                    )
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("imgs/like.jpeg"),
              ),
            ],
          )),
    );
  }
}
