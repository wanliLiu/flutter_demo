import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demon/base/FadeRoute.dart';
import 'package:flutter_demon/base/demo.dart';
import 'package:flutter_demon/common/Toast.dart';
import 'package:flutter_demon/routes/demo_animation.dart';
import 'package:flutter_demon/routes/demo_dialog.dart';
import 'package:flutter_demon/routes/demo_pointer.dart';
import 'package:flutter_demon/routes/demo_scroll.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutterview.dart';
import '../simple_page_widgets.dart';
import 'db_test.dart';
import 'demo_custom_layout.dart';
import 'demo_scroll_customview.dart';
import 'demo_status_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  String? upContent;

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  void _setBackContent(String? content) {
    setState(() {
      upContent = content;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tapGestureRecognizer.dispose();
  }

  Widget backView() => upContent != null && upContent!.isNotEmpty
      ? Padding(padding: const EdgeInsets.all(20), child: Text(upContent!))
      : const Text("Nothing");

  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = true; //维护复选框状态

  void _dealCheck(bool isCheck, bool? show) {
    setState(() {
      if (isCheck) {
        _checkboxSelected = !show!;
        _switchSelected = _checkboxSelected;
      } else {
        _switchSelected = !show!;
        _checkboxSelected = _switchSelected;
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Widget get _actionButton => Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(10),
        child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.send,
                  color: Colors.red,
                ),
                label: const Text("打开提示页面(返回值）"),
                onPressed: () async {
                  var result = await Navigator.pushNamed(context, "Tips",
                      arguments:
                          "Hello,我是通过onGenerateRoute过来的，并获取返回来的数据,注意：\n\n"
                          "1.通过没有注册的路由传过来的参数是在：RouteSettings.arguments\n\n"
                          "2.通过注册路由传过来的参数，是通过：ModalRoute.of(context).settings.arguments获取\n\n"
                          "以上两点尤其要注意\n\n");

                  debugPrint("路由返回值：$result");

                  if (result is String && result.isNotEmpty) {
                    _setBackContent(result);
                  } else {
                    _setBackContent(null);
                  }
                },
              ),
              OutlinedButton(
                child: const Text('开启一个新的'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => PushWidget()));
                },
              ),
              ElevatedButton(
                child: const Column(
                  children: <Widget>[
                    Text.rich(TextSpan(text: "我是", children: [
                      TextSpan(text: "一头猪", style: TextStyle(color: Colors.red))
                    ])),
                    Text("目标节点获取参数")
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "FlutterRoute",
                      arguments: "不在Target里面获取参数，直接在路由那里的时候获取（外面获取）");
                },
              ),
              ElevatedButton(
                child: const Text("通过路由打开"),
                onPressed: () {
                  Navigator.pushNamed(context, "First",
                      arguments: "命名路由参数传递样例,在里面获取");
                },
              ),
              ElevatedButton(
                child: const Text("未注册：onGenerateRoute"),
                onPressed: () {
//                Navigator.pushNamed(context, "SecondOther");
                  Navigator.of(context).pushNamed("SecondOther");
                },
              ),
              ElevatedButton(
                child: const Text("输入框和表单"),
                onPressed: () async {
                  var result = await Navigator.of(context)
                      .pushNamed("textFIled", arguments: {
                    "account": "fluttertest",
                    "pwd": "23820302930923"
                  });
                  if (result != null && result is String) {
                    Fluttertoast.showToast(
                        msg: result,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                  }
                },
              ),
              ElevatedButton(
                child: const Text("进度指示器"),
                onPressed: () =>
                    Navigator.of(context).pushNamed("progressIndictor"),
              ),
              // ElevatedButton(
              //   child: Text("Redux"),
              //   onPressed: () => runApp(createApp()),
              // ),
              ElevatedButton(
                child: const Text("ListView"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PageListRoot(ListType.ListView))),
              ),
              ElevatedButton(
                child: const Text("PullLoadMore"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PageListRoot(ListType.DemoPullLoad))),
              ),
              ElevatedButton(
                child: const Text("SingleChildScrollView"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PageListRoot(ListType.SingleChildScrollView))),
              ),
              ElevatedButton(
                child: const Text("GridView"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PageListRoot(ListType.GridView))),
              ),
              ElevatedButton(
                child: const Text("Dialog"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DialogPage())),
              ),
              ElevatedButton(
                child: const Text("StaggeredGridView"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PageListRoot(ListType.StaggeredGridView))),
              ),
              ElevatedButton(
                child: const Text("UrlLanucher"),
                onPressed: () async {
                  var url = Uri.parse("https://flutter.dev");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw "Could not launch $url";
                  }
                },
              ),
              ElevatedButton(
                child: const Text("CustomScrollView"),
                onPressed: () => Navigator.of(context).push(FadeRoute(
                    builder: (BuildContext context) => DemoCustomView())),
              ),
              ElevatedButton(
                child: const Text("NestedScrollView"),
                onPressed: () => Navigator.of(context).push(FadeRoute(
                    builder: (BuildContext context) =>
                        CustomScrollViewTestRoute())),
              ),
              ElevatedButton(
                child: const Text("事件处理"),
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => PointerPage())),
              ),
              ElevatedButton(
                child: const Text("动画"),
                onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return AnimationPage();
                    },
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ))),
              ),
              ElevatedButton(
                child: const Text("StatusBar"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DemoStatusBar())),
              ),
              ElevatedButton(
                child: const Text('DemoCustomLayout'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DemoCustomLayout())),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DataBaseTestLayout())),
                child: const Text('DataBase Test'),
              )
            ]),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    debugPrint("HomeView print build");

    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TapBoxA(),
            IconButton(icon: const Icon(Icons.thumb_up), onPressed: () {}),
            ParentWidget(),
            ParentWidgetC()
          ],
        ),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Switch(
                        value: _switchSelected,
                        onChanged: (chose) {
                          _dealCheck(false, !chose);
                        }),
                    Text(_switchSelected ? "开" : "关")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: !_checkboxSelected,
                        onChanged: (chose) {
                          _dealCheck(true, chose);
                        }),
                    Text(!_checkboxSelected ? "选中" : "未选中")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                        value: !_switchSelected,
                        onChanged: (chose) {
                          _dealCheck(false, chose);
                        }),
                    Text(!_switchSelected ? "开" : "关")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: _checkboxSelected,
                        onChanged: (chose) {
                          _dealCheck(true, !chose!);
                        }),
                    Text(_checkboxSelected ? "选中" : "未选中")
                  ],
                ),
              ],
            ),
            Text(
              "Hello 我是apple---" * 40,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text.rich(TextSpan(text: "我是一个", children: [
              TextSpan(
                text: "@打不死的小强",
                style: const TextStyle(color: Colors.blue),
                recognizer: _tapGestureRecognizer
                  ..onTap = () => VaeToast.showToast("@打不死的小强",
                      gravity: ToastGravity.CENTER),
              ),
              const TextSpan(text: "新多岁的老")
            ])),
            DefaultTextStyle(
                style: const TextStyle(color: Colors.red, fontSize: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Text("我是第一"),
                    const Text("我是第二"),
                    CustomHome(),
                    const Text(
                      "我是第三",
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    )
                  ],
                )),
            backView(),
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Increment>(builder: (context, inc, _) {
              return FutureBuilder<int>(
                future: () async {
                  return await context.read<Increment>().readCounter();
                }(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget child;
                  int key = -1;
                  // 请求已结束
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      // 请求失败，显示错误
                      child = Text("Error: ${snapshot.error}");
                    } else {
                      // 请求成功，显示数据
                      key = snapshot.data!;
                      child = Text(
                        "$key",
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .headline3!
                        //     .copyWith(fontWeight: FontWeight.bold),
                      );
                    }
                  } else {
                    // 请求未结束，显示loading
                    child = const SizedBox();
                  }

                  if (key == -1) key = Random().nextInt(100);

                  return AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      reverseDuration: const Duration(milliseconds: 500),
//                switchInCurve: Curves.bounceIn,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransitionX(
                          position: animation,
                          child: child,
                          direction: AxisDirection.left,
                        );
                      },
                      child: Container(
                        key: ValueKey<int>(key),
                        color: Colors.grey,
                        alignment: Alignment.center,
                        width: 100,
                        height: 60,
                        child: child,
                      ));
                },
              );
            }),
            Consumer<Increment>(
              builder: (context, inc, _) => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(milliseconds: 500),
//                switchInCurve: Curves.bounceIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransitionX(
                    position: animation,
                    child: child,
                    direction: AxisDirection.right,
                  );

//                  return MySlideTransition(
//                    child: child,
//                    position:
//                        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
//                            .animate(animation),
//                  );

//                  return ScaleTransition(
//                    scale: animation,
//                    child: child,
//                  );
                },
                child: Container(
                  key: ValueKey<int>(inc.counter),
                  color: Colors.grey.withOpacity(0.4),
                  child: Text(
                    '${inc.counter}',
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .headline3!
                    //     .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        _actionButton,
        Flutterview(),
      ],
    );
  }
}

class Increment extends ChangeNotifier {
  int get counter => _counter;
  int _counter = 0;

  set counter(int value) {
    _counter = value;
  }

  Future<int> readCounter() async {
    counter = await _readCounter();
    return counter;
  }

  void changeValue() async {
    _counter++;
    await (await _getLocalFile()).writeAsString("$_counter");
    notifyListeners();
  }

  Future<File> _getLocalFile() async {
    var dir = (await getApplicationDocumentsDirectory()).path;
    return File("$dir/counter.txt");
  }

  Future<int> _readCounter() async {
    try {
      var file = await _getLocalFile();
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }
}
