import 'package:flutter/material.dart';

class _ShowProgressWidget extends StatefulWidget {
  _ShowProgressWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  _ShowProgressWidgetState createState() => _ShowProgressWidgetState();
}

class _ShowProgressWidgetState extends State<_ShowProgressWidget> {
  double _lastProgress;
  bool _showProgress = false;
  String _progress = "";

  bool _notificationListener(ScrollNotification notification) {
    bool _change = false;
    if (notification is ScrollStartNotification) {
      _change = true;
      _showProgress = true;
    } else if (notification is ScrollEndNotification) {
      _showProgress = false;
      _change = true;
    }

    double progress =
        notification.metrics.pixels / notification.metrics.maxScrollExtent;
    if (progress != _lastProgress) {
      _lastProgress = progress;
      _change = true;
      _progress = "${(_lastProgress * 100).toInt()}%";
    }

    if (_change) {
      setState(() {});
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: _notificationListener,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            widget.child,
            Visibility(
                visible: _showProgress,
                maintainState: true,
                child: CircleAvatar(
                  radius: 30,
                  child: Text(_progress),
                  backgroundColor: Colors.black54,
                ))
          ],
        ));
  }
}

mixin BasePage<T extends StatefulWidget> on State<T> {
  @protected
  ScrollController controller = ScrollController();

  bool _showToTopBtn = false;

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

  @protected
  Widget get content;

  Widget _content;

  @protected
  Widget get title;

  Widget _title;

  @override
  Widget build(BuildContext context) {
    if (_content == null) _content = content;
    if (_title == null) _title = title;

    debugPrint("BasePage------>build");
    return Scaffold(
      appBar: AppBar(
        title: _title,
      ),
      body: _ShowProgressWidget(child: _content),
      floatingActionButton: _showToTopBtn
          ? Builder(
              builder: (context) => FloatingActionButton(
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
