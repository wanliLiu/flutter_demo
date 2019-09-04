import 'package:flutter/material.dart';
import 'package:flutter_module/base/demo.dart';
import 'package:flutter_module/base/flutterbase.dart';
import 'package:flutter_module/base/stateManage.dart';
import 'package:flutter_module/redux/app.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../flutterview.dart';
import '../simple_page_widgets.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  String upContent;

  void _setBackContent(String content) {
    setState(() {
      upContent = content;
    });
  }

  Widget backView() => upContent != null && upContent.isNotEmpty
      ? Padding(padding: EdgeInsets.all(20), child: Text(upContent))
      : Text("Nothing");

  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = true; //维护复选框状态

  void _dealCheck(bool isCheck, bool show) {
    setState(() {
      if (isCheck) {
        _checkboxSelected = !show;
        _switchSelected = _checkboxSelected;
      } else {
        _switchSelected = !show;
        _checkboxSelected = _switchSelected;
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Widget get _actionButton => Container(
        color: Colors.grey[100],
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Wrap(spacing: 10, children: <Widget>[
          RaisedButton.icon(
            icon: Icon(
              Icons.send,
              color: Colors.red,
            ),
            label: Text("打开提示页面(返回值）"),
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
          OutlineButton(
            child: Text('开启一个新的'),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PushWidget()));
            },
          ),
          RaisedButton(
            child: Column(
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
          RaisedButton(
            child: Text("输入框和表单"),
            onPressed: () async {
              var result = await Navigator.of(context).pushNamed("textFIled",
                  arguments: {
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
          RaisedButton(
            child: Text("进度指示器"),
            onPressed: () =>
                Navigator.of(context).pushNamed("progressIndictor"),
          ),
          RaisedButton(
            child: Text("Redux"),
            onPressed: () =>
                runApp(createApp()),
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
            IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
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
                          _dealCheck(true, !chose);
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
                style: TextStyle(color: Colors.blue),
              )
            ])),
            DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("我是第一"),
                    Text("我是第二"),
                    CustomHome(),
                    Text(
                      "我是第三",
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    )
                  ],
                )),
            backView(),
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Increment>(
                builder: (BuildContext context, Increment inc) => Text(
                      '${inc.counter}',
                      style: Theme.of(context).textTheme.display1,
                    )),
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

  void changeValue() {
    _counter++;
    notifyListeners();
  }
}
