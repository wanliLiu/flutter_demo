import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DefaultPadding extends StatelessWidget {
  DefaultPadding(Widget mchild, {Key key})
      : child = mchild,
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: child,
    );
  }
}

class TabHistory extends StatelessWidget {
  TabHistory({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    Widget avatar = Image.asset(
      "imgs/like.jpeg",
      width: 80.0,
      height: 80,
      fit: BoxFit.cover,
    );

    return Scrollbar(
        child: SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          testFutureBuilder(),
          testFutureBuilder(
            useStream: true,
          ),
          avatar,
          DefaultPadding(ClipOval(
            child: avatar,
          )),
          DefaultPadding(ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: avatar,
          )),
          DefaultPadding(Container(
            width: 150,
            height: 100,
            foregroundDecoration: BoxDecoration(
//              borderRadius: BorderRadius.all( Radius.circular(50)),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("imgs/timg.jpeg"), fit: BoxFit.cover)),
            child: avatar,
          )),
          DefaultPadding(ConstrainedBox(
            constraints: BoxConstraints.loose(Size(100, double.infinity)),
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  widthFactor: .5,
                  child: avatar,
                ),
                Text(
                  "你好世界",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          )),
          DefaultPadding(ConstrainedBox(
            constraints: BoxConstraints.loose(Size(100, double.infinity)),
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: .5,
                    child: avatar,
                  ),
                ),
                Text(
                  "你好世界",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          )),
          DefaultPadding(DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: ClipRect(
              clipper: MyClipper(),
              child: avatar,
            ),
          )),
        ],
      ),
    ));
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(10.0, 10.0, 50.0, 50.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class testFutureBuilder extends StatelessWidget {
  testFutureBuilder({Key key, bool useStream = false})
      : _useStream = useStream,
        super(key: key);

  final bool _useStream;

  Future<String> mockNetworkData({String content = "body"}) async {
    String dataUrl = "https://jsonplaceholder.typicode.com/posts";
    Response response = await get(dataUrl);
//    var widgets = jsonDecode(response.body)[0][content];
//    debugPrint("$widgets");
//    return Future.value(widgets);
    return Future.value(response.body);
//    return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据");
  }

  Stream<String> counter() {
//    return Stream.fromFuture(mockNetworkData(content: "title"));
    return Stream.periodic(Duration(seconds: 1), (i) => i.toString());
  }

  Widget _StreamBuilder(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('没有Stream');
      case ConnectionState.waiting:
        return Text('等待数据...');
      case ConnectionState.active:
        return Text('active: ${snapshot.data}');
      case ConnectionState.done:
        return Text('Stream已关闭');
    }
    return null; // unreachable
  }

  Widget _result(BuildContext context, AsyncSnapshot snapshot) {
    debugPrint(snapshot.toString());
    // 请求已结束
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        // 请求失败，显示错误
        return Text("Error: ${snapshot.error}");
      } else {
        // 请求成功，显示数据
        return Text("Contents: \n${snapshot.data}");
      }
    } else {
      // 请求未结束，显示loading
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: _useStream
            ? StreamBuilder<String>(
                stream: counter(),
                builder: _StreamBuilder,
              )
            : FutureBuilder<String>(
                future: mockNetworkData(),
                builder: _result,
              ));
  }
}