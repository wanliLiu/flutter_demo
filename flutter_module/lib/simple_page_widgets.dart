import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_boost/flutter_boost.dart';

class FirstRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //通过命令路由传过来的参数 [ModalRoute]
    var args = ModalRoute.of(context).settings.arguments;
    debugPrint("FirstRouteWidget---->$args");

    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(args ?? 'Open second route'),
          onPressed: () {
//
//            FlutterBoost.singleton.openPage("second", {}, animated: true, resultHandler:(String key , Map<dynamic,dynamic> result){
//              print("did recieve second route result $key $result");
//            });
          },
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key key, this.initValue: 0}) : super(key: key);
  final int initValue;

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    debugPrint("CounterWidget---》initState");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CounterWidget---》build");
    return FlatButton(
        onPressed: () {
          setState(() => ++_counter);
        },
        child: Text("点击：${widget.initValue}"));
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("CounterWidget---》didUpdateWidget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("CounterWidget---》didChangeDependencies");
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint("CounterWidget---》deactivate");
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint("CounterWidget---》reassemble");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("CounterWidget---》dispose");
  }
}

class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Column(
        children: <Widget>[
          CounterWidget(),
          //ios风格的
          CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: Text("Press"),
              onPressed: () {}
          ),
          RaisedButton(
            onPressed: () {
              // 查找父级最近的Scaffold对应的ScaffoldState对象
//              ScaffoldState state =
//                  context.ancestorStateOfType(TypeMatcher<ScaffoldState>());
              ScaffoldState state = Scaffold.of(context);
              //调用ScaffoldState的showSnackBar来弹出SnackBar
              state.showSnackBar(SnackBar(content: Text("我是SnackBar")));
            },
            child: Text("显示SnackBar"),
          ),
          Builder(builder: (context) {
            // 在Widget树中向上查找最近的父级`Scaffold` widget
            Scaffold scaffold = context.ancestorWidgetOfExactType(Scaffold);
//            Scaffold scaffold = Scaffold.of(context);
            // 直接返回 AppBar的title， 此处实际上是Text("Context测试")
            return Container(
              color: Colors.red,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              child: (scaffold.appBar as AppBar).title,
            );
          }),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate back to first route when tapped.
//
//            BoostContainerSettings settings = BoostContainer.of(context).settings;
//            if(settings.params.containsKey("result_id")){
//              String rid = settings.params["result_id"];
//              FlutterBoost.singleton.onPageResult(rid, {"data":"works"},{});
//            }
//
//            FlutterBoost.singleton.closePageForContext(context);
              },
              child: Text('Go back!'),
            ),
          ),
        ],
      ),
    );
  }
}

class TabRouteWidget extends StatelessWidget {
  TabRouteWidget({this.from = "没有传过来的数据"});

  final String from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tab Route"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(from),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
//            FlutterBoost.singleton.openPage("second", {}, animated: true);
              },
              child: Text('Open second route'),
            ),
          ),
        ],
      ),
    );
  }
}

class FlutterRouteWidget extends StatelessWidget {
  final String message;

  FlutterRouteWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_boost_example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Text(
              message ?? "This is a flutter activity",
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Expanded(child: Container()),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),

            ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
            ///例如：sample://nativePage?aaa=bbb
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://flutterPage", {
//                  "query": {"aaa": "bbb"}
//                }),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open native page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),

            ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
            ///例如：sample://nativePage?aaa=bbb
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://nativePage", {
//                  "query": {"aaa": "bbb"}
//                }),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'push flutter widget',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PushWidget()));
            },
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter fragment page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://flutterFragmentPage", {}),
          )
        ],
      ),
    );
  }
}

class FragmentRouteWidget extends StatelessWidget {
  final Map params;

  FragmentRouteWidget(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_boost_example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Text(
              "This is a flutter fragment",
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: Text(
              params['tag'] ?? '',
              style: TextStyle(fontSize: 28.0, color: Colors.red),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Expanded(child: Container()),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open native page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://nativePage", {}),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://flutterPage", {}),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter fragment page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
//            onTap: () =>
//                FlutterBoost.singleton.openPage("sample://flutterFragmentPage", {}),
          )
        ],
      ),
    );
  }
}

class PushWidget extends StatefulWidget {
  @override
  _PushWidgetState createState() => _PushWidgetState();
}

class _PushWidgetState extends State<PushWidget> {
  @override
  Widget build(BuildContext context) {
    return FlutterRouteWidget(message: "Pushed Widget");
  }
}
