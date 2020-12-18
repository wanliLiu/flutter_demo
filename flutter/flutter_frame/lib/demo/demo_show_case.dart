import 'package:flutter/material.dart';
import 'package:flutter_frame/app.dart';
import 'package:flutter_frame/widget/widget.dart';

class HomePage extends BasePageWidget {
  HomePage({Key? key}) : super(key: key, pageTitle: "HomePage");

  @override
  Widget pageBuild(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        RaisedButton(
          onPressed: () => Navigator.pushNamed(context, NanmeSecondePage),
          child: Text("第二页"),
        )
      ],
    );
  }
}

class SecondPage extends BasePageWidget {
  SecondPage({Key? key})
      : super(
            key: key,
            pageTitle: "第二页",
            extendBodyBehindAppBar: true,
            toolbarBackgroundColor: Colors.white70);

  @override
  Widget pageBuild(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "我是第二页",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
