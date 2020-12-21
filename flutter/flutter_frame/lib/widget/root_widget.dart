import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tool_bar.dart';

typedef RetryCallBack = void Function();

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

enum ContentAction {
  ///显示真正的内容
  Contenting,

  ///显示加载状态
  Progressing,

  ///显示加载出错状态
  Erroring,

  /// 没有视图的显示
  Emptying,
}

class ActionContentState with ChangeNotifier {
  ContentAction currentAction;

  ActionContentState({this.currentAction: ContentAction.Contenting});

  void changeActionContentState(ContentAction action) async{
    currentAction = ContentAction.Progressing;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    currentAction = ContentAction.Contenting;
    notifyListeners();
  }
}

class ActionContentWidget extends StatelessWidget {
  ActionContentWidget(
      {Key? key, required this.child, this.progress, this.error, this.empty})
      : super(key: key);

  final Widget child;
  final Widget? progress;
  final Widget? error;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActionContentState>(
      create: (context) => ActionContentState(),
      child: Consumer<ActionContentState>(
        child: child,
        builder: (context, state, child) {
          var widget = child!;
          if (state.currentAction == ContentAction.Emptying)
            widget = empty ?? DefaultNoDataWidget();
          else if (state.currentAction == ContentAction.Progressing)
            widget = progress ?? DefaultLoadingWidget();
          else if (state.currentAction == ContentAction.Erroring)
            widget = error ?? DefaultErrorWidget();

          return widget;
        },
      ),
    );
  }
}

class DefaultNoDataWidget extends StatelessWidget {
  const DefaultNoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text(
          '我是空的，什么都没有！！！',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({Key? key, this.errormsg, this.retryCallBack})
      : super(key: key);

  final String? errormsg;
  final RetryCallBack? retryCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.red,
      child:  Column(
        mainAxisAlignment : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(errormsg ?? "哦豁，发生了错误了哦！！！"),
          RaisedButton(
            onPressed: retryCallBack ?? null,
            child: Text('点我重试'),
          )
        ],
      ),
    );
  }
}
