import 'package:flutter/material.dart';
import 'package:flutter_frame/global_constant.dart';

import 'tool_app_bar.dart';

///
///
/// 项目用的顶部AppBar
///
///
class TopToolbar extends Toolbar {
  TopToolbar(
      {String? title,
      List<Widget>? actions,
      bool? centerTitle: true,
      Color? backgroundColor: Colors.white})
      : super(
            title: Text(title ?? "AppBar"),
            actions: actions,
            centerTitle: centerTitle,
            backgroundColor: backgroundColor,
            elevation: 0,
            //不要阴影
            toolbarHeight: ToolBarHeight);
}

///
/// 所有页面的基类显示
///
///
class RootContentWidget extends StatelessWidget {
  RootContentWidget({Key? key, required this.title, required this.content})
      : super(key: key);

  final Widget content;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopToolbar(
        title: title,
      ),
      body: content,
    );
  }
}
