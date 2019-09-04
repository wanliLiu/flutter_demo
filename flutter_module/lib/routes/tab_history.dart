import 'package:flutter/material.dart';

class TabHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget avatar = Image.asset(
      "imgs/like.jpeg",
      width: 80.0,
      height: 80,
      fit: BoxFit.cover,
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
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
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(10.0, 10.0, 50.0, 50.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
