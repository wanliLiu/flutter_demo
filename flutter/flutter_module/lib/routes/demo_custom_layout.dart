import 'package:flutter/material.dart';

class DemoCustomLayout extends StatefulWidget {
  @override
  _DemoCustomLayoutState createState() => _DemoCustomLayoutState();
}

class _DemoCustomLayoutState extends State<DemoCustomLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomLayout'),
      ),
      body: _DemoSingleChildLayout(),
    );
  }
}

class _TestSingleChildLayout extends SingleChildLayoutDelegate {
  @override
  Size getSize(BoxConstraints constraints) {
    return Size.fromHeight(constraints.biggest.width / 5);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: 100, height: 50);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(childSize.width / 2, childSize.height / 2);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class _DemoSingleChildLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      children: <Widget>[
        CustomSingleChildLayout(
          delegate: _TestSingleChildLayout(),
          child: Container(
            color: Colors.red,
            constraints: BoxConstraints.expand(width: 80, height: 40),
          ),
        ),
        CustomSingleChildLayout(
          delegate: _TestSingleChildLayout(),
          child: Container(
            color: Colors.red,
            constraints: BoxConstraints.expand(width: 80, height: 40),
          ),
        ),
      ],
    );

    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        child,
        _DemoMultiChildLayout()
      ],
    );
  }
}

class _TestMultiChild extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    if (hasChild('demo1')) {
      Size trailingSize =
          layoutChild('demo1', BoxConstraints.tightFor(width: 84, height: 45));
      positionChild('demo1', Offset(40, 150));
    }

    if (hasChild('demo2')) {
      layoutChild('demo2', BoxConstraints.tightFor(width: 100, height: 100));
      positionChild('demo2', Offset(100, 250));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class _DemoMultiChildLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _TestMultiChild(),
      children: <Widget>[
        LayoutId(
            id: "demo1",
            child: Container(
              color: Colors.red,
              alignment: Alignment.center,
              constraints: BoxConstraints.expand(width: 80, height: 40),
              child: Text('demo1'),
            )),
        LayoutId(
          id: "demo2",
          child: Container(
            color: Colors.red,
            alignment: Alignment.center,
            constraints: BoxConstraints.expand(width: 80, height: 40),
            child: Text('demo2'),
          ),
        )
      ],
    );
  }
}
