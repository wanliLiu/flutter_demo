import 'package:flutter/material.dart';

mixin BasePage<T extends StatefulWidget> on State<T> {
  @protected
  ScrollController controller = ScrollController();

  bool _showToTopBtn = false;

  double _lastProgress;
  bool _showProgress = false;
  String _progress = "";

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      debugPrint("ScrollController-->${controller.offset}");
      if (controller.offset < 1000 && _showToTopBtn) {
        setState(() {
          _showToTopBtn = false;
        });
      } else if (controller.offset >= 1000 && !_showToTopBtn) {
        setState(() {
          _showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool _notificationListener(ScrollNotification notification) {
//    if (notification is ScrollStartNotification) {
//      setState(() {
//        _showProgress = true;
//      });
//    } else if (notification is ScrollEndNotification) {
//      setState(() {
//        _showProgress = false;
//      });
//    }
//
//    double progress =
//        notification.metrics.pixels / notification.metrics.maxScrollExtent;
//    if (progress != _lastProgress) {
//      _lastProgress = progress;
//      setState(() {
//        _progress = "${(_lastProgress * 100).toInt()}%";
//      });
//    }

    return true;
  }

  @protected
  Widget get content;

  @protected
  Widget get title;

  void _cache(Widget cacheTarget, Widget newTarget) {
    cacheTarget = newTarget;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BasePage------>build");
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: NotificationListener<ScrollNotification>(
          onNotification: _notificationListener,
          child: _showProgress
              ? Stack(
            alignment: Alignment.center,
            children: <Widget>[
              content,
              CircleAvatar(
                radius: 30,
                child: Text(_progress),
                backgroundColor: Colors.black54,
              )

            ]) : content
          ),
      floatingActionButton: _showToTopBtn
          ? Builder(
          builder: (context) =>
              FloatingActionButton(
                onPressed: () {
                  controller.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ))
          : null,
    );
  }
}
