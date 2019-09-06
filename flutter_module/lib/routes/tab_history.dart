import 'package:flutter/material.dart';

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
