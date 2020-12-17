import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_module/common/Global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoubleTapExit extends StatefulWidget {
  DoubleTapExit({Key key, @required this.child})
      : assert(child != null, "child不能为空"),
        super(key: key);

  final Widget child;

  @override
  _DoubleTapExitState createState() => _DoubleTapExitState();
}

class _DoubleTapExitState extends State<DoubleTapExit> {
  int _pressTime = 0;

  void _showExitMsg() {
    Fluttertoast.showToast(
        msg: "再按一次退出程序！",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<bool> _checkAgain() async {
    //ios就处理了
    if (Global.isIOS) return true;

    if (_pressTime++ == 0) {
      _showExitMsg();
      Timer(Duration(seconds: 3), () => _pressTime = 0);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: _checkAgain);
  }
}
