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
