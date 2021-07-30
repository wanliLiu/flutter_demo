import 'package:flutter/material.dart';
import 'package:flutter_frame/app.dart';
import 'package:flutter_frame/widget/widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _demoForTest(BuildContext context) async {
    context
        .read<ActionContentState>()
        .changeActionContentState(ContentAction.Progressing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: "HomePage",
      ),
      body: ActionContentWidget(
        child: Wrap(
          spacing: 10,
          children: [
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => _demoForTest(context),
                child: Text("内部加载"),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, NanmeSecondePage),
              child: Text("第二页"),
            )
          ],
        ),
      ),
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
