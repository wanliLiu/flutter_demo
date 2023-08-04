import 'package:flutter/material.dart';

import 'custom_flow.dart';
import 'custom_paint.dart';

class TurnBox extends StatefulWidget {
  const TurnBox(
      {Key? key,  this.turns = 0, this.speed =  10, required this.child})
      : assert(child != null),
        super(key: key);

  final double turns;
  final int speed;
  final Widget child;

  @override
  _TurnBoxState createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

class FixedSizeLayoutDelegate extends SingleChildLayoutDelegate {
  const FixedSizeLayoutDelegate({this.size});

  final Size? size;

  @override
  bool shouldRelayout(FixedSizeLayoutDelegate oldDelegate) {
    return size != oldDelegate.size;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return size!;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tight(size!);
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
    MediaQueryData data = MediaQuery.of(context);
    return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.red.withOpacity(0.4),
                constraints: BoxConstraints.tight(Size(data.size.width, 50)),
                child: FlowMenu(),
              ),
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
              ElevatedButton(
                child: Text("顺时针旋转1/5圈"),
                onPressed: () {
                  setState(() {
                    _turns += .2;
                  });
                },
              ),
              ElevatedButton(
                child: Text("逆时针旋转1/5圈"),
                onPressed: () {
                  setState(() {
                    _turns -= .2;
                  });
                },
              ),
              Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(5.0),
                child: CustomSingleChildLayout(
                  delegate: FixedSizeLayoutDelegate(size: Size(100.0, 50.0)),
                  child: Container(
                    color: Colors.red,
                    width: 100.0,
                    height: 300.0,
                  ),
                ),
              ),
              GradientCircularProgressRoute(),
//              GradientCircularProgressIndicator(
//                // No gradient
//                colors: [Colors.blue, Colors.blue],
//                radius: 40.0,
//                strokeCapRound: true,
//                strokeWidth: 8.0,
//                value: .5,
//              ),
            ],
          ),
        ));
  }
}
