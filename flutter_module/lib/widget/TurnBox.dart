import 'package:flutter/material.dart';

import 'custom_paint.dart';

class TurnBox extends StatefulWidget {
  const TurnBox(
      {Key key,
      @required this.turns,
      @required this.speed,
      @required this.child})
      : assert(speed > 0),
        assert(child != null),
        super(key: key);

  final double turns;
  final int speed;
  final Widget child;

  @override
  _TurnBoxState createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, lowerBound: -double.infinity, upperBound: double.infinity);
    _controller.value = widget.turns;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TurnBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.turns != widget.turns || oldWidget.speed != widget.speed) {
      _controller.animateTo(widget.turns,
          duration: Duration(milliseconds: widget.speed ?? 300),
          curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_TurnBoxState---build");
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}

class TurnBoxRoute extends StatefulWidget {
  @override
  _TurnBoxRouteState createState() => new _TurnBoxRouteState();
}

class _TurnBoxRouteState extends State<TurnBoxRoute> {
  double _turns = .0;

  @override
  Widget build(BuildContext context) {
    debugPrint("_TurnBoxRouteState---build");
    return ListView(
      children: <Widget>[
        CustomPaintDemo(),
        TurnBox(
          turns: _turns,
          speed: 500,
          child: Icon(
            Icons.refresh,
            size: 50,
          ),
        ),
        TurnBox(
          turns: _turns,
          speed: 1000,
          child: Icon(
            Icons.refresh,
            size: 150.0,
          ),
        ),
        RaisedButton(
          child: Text("顺时针旋转1/5圈"),
          onPressed: () {
            setState(() {
              _turns += .2;
            });
          },
        ),
        RaisedButton(
          child: Text("逆时针旋转1/5圈"),
          onPressed: () {
            setState(() {
              _turns -= .2;
            });
          },
        )
      ],
    );
  }
}
