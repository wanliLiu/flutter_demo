import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TabHistory extends StatelessWidget {
  TabHistory({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

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
          ClipOval(
            child: avatar,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: avatar,
          ),
          Container(
            width: 150,
            height: 100,
            foregroundDecoration: BoxDecoration(
//              borderRadius: BorderRadius.all( Radius.circular(50)),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("imgs/timg.jpeg"), fit: BoxFit.cover)),
            child: avatar,
          ),
          ConstrainedBox(
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
          ),
          ConstrainedBox(
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
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: ClipRect(
              clipper: MyClipper(),
              child: avatar,
            ),
          ),
        ].map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: e,
          );
        }).toList(),
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
  testFutureBuilder({Key? key, bool useStream = false})
      : _useStream = useStream,
        super(key: key);

  final bool _useStream;

  Future<String> mockNetworkData({String content = "body"}) async {
    String dataUrl = "https://jsonplaceholder.typicode.com/posts";
    Response response = await get(Uri.parse(dataUrl));
    return response.body;
  }

  Stream<String> counter() {
//    return Stream.fromFuture(mockNetworkData(content: "title"));
    return Stream.periodic(Duration(seconds: 1), (i) => i.toString());
  }

  Widget _StreamBuilder(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasError)
      return Text('Error: ${snapshot.error}');
    else
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('没有Stream');
        case ConnectionState.waiting:
          return Text('等待数据...');
        case ConnectionState.active:
          return Text('active: ${snapshot.data}');
        case ConnectionState.done:
          return Text('Stream已关闭');
        default:
          return Text('erroe');
      }
    // return null; // unreachable
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
