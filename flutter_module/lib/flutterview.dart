import 'package:flutter/material.dart';

class flutterview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                "images/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                "images/timg.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                "images/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }
}
