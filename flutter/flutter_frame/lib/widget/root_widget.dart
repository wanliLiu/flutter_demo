import 'package:flutter/material.dart';

import 'tool_bar.dart';

///
/// 所有页面的基类显示
///
///
abstract class BasePageWidget extends StatelessWidget {
  BasePageWidget({
    Key? key,
    required this.pageTitle,
    this.needToolbar = true,
    this.toolbar,
    this.toolbarTitleInCenter,
    this.toolbarBackgroundColor,
    this.actions,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
  })  : this.extendBody = extendBody ?? false,
        this.extendBodyBehindAppBar = extendBodyBehindAppBar ?? false,
        super(key: key);

  final bool needToolbar;
  final String pageTitle;

  ///有时候肯定不会满足所有的需求，这个时候就[AppBar] 来做
  ///如果[needToolbar]为true,如果[toolbar]不为空，那么就用[toolbar]
  final AppBar? toolbar;
  final bool? toolbarTitleInCenter;
  final Color? toolbarBackgroundColor;

  final bool extendBody;
  final bool extendBodyBehindAppBar;

  ///toolbar 右上角的操作按钮
  final List<Widget>? actions;

  Widget pageBuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: needToolbar
          ? toolbar ??
              Toolbar(
                title: pageTitle,
                actions: actions,
                centerTitle: toolbarTitleInCenter,
                backgroundColor: toolbarBackgroundColor,
              )
          : null,
      body: pageBuild(context),
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
