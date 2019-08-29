import 'package:flutter/material.dart';

class Echo extends StatelessWidget {
  const Echo(
      {Key key, @required this.text, this.backgroundColor: Colors.blueAccent})
      : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

class Flutterview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Echo(
              text: "我是文字内容",
              backgroundColor: Colors.yellow,
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/timg.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/timg.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }
}
