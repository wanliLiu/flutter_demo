import 'package:flutter/material.dart';

class AnimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动画"),
      ),
      body: ListView(
        children: <Widget>[
          HeroAnimationRoute(),
          StaggerRoute(),
          AnimatedWidgetsTest(),
          ScalAnimationWidget(),
        ],
      ),
    );
  }
}

class ScalAnimationWidget extends StatefulWidget {
  @override
  _ScalAnimationWidgetState createState() => _ScalAnimationWidgetState();
}

class _ScalAnimationWidgetState extends State<ScalAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    _animation = Tween(begin: 0.0, end: 300.0).animate(_animation!);
    _animation!
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _controller.reverse();
        else if (status == AnimationStatus.dismissed) _controller.forward();
      });

//    _animation
//      ..addListener(() {
//        setState(() {});
//      });

    _controller.forward();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_ScalAnimationWidgetState-->build");

    return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) => Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "imgs/like.jpeg",
                width: _animation!.value,
                height: _animation!.value,
              ),
            ));

//    return AnimatedBuilder(
//        animation: _animation,
//        child: Image.asset("imgs/like.jpeg"),
//        builder: (context, child) => Container(
//              alignment: Alignment.topCenter,
//              child: child,
//              width: _animation.value,
//              height: _animation.value,
//            ));

//    return Container(
//      alignment: Alignment.topCenter,
//      child: Image.asset(
//        "imgs/like.jpeg",
//        width: _animation.value,
//        height: _animation.value,
//      ),
//    );

//    return AnimateImage(
//      animation: _animation,
//    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class AnimateImage extends AnimatedWidget {
  AnimateImage({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> _animation = listenable as Animation<double>;
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "imgs/like.jpeg",
        width: _animation.value,
        height: _animation.value,
      ),
    );
  }
}

class HeroAnimationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.topCenter,
      child: InkWell(
        child: Hero(
            tag: "avator",
            child: ClipOval(
              child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            )),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text("原图"),
                    ),
                    body: HeroAnimationRouteB(),
                  )));
//
//          Navigator.of(context).push(PageRouteBuilder(pageBuilder:
//              (BuildContext context, Animation<double> animation,
//                  Animation<double> secondaryAnimation) {
//            return FadeTransition(
//              opacity: animation,
//              child: Scaffold(
//                  appBar: AppBar(
//                    title: Text("原图"),
//                  ),
//                  body: HeroAnimationRouteB()),
//            );
//          }));
        },
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
        child: Image.asset("imgs/like.jpeg"),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key? key, required this.controller}) : super(key: key) {
    _height = Tween<double>(begin: 0, end: 200).animate(CurvedAnimation(
        parent: controller, curve: Interval(.0, .6, curve: Curves.ease)));

    _color = ColorTween(begin: Colors.green, end: Colors.red).animate(
        CurvedAnimation(
            parent: controller, curve: Interval(.0, .6, curve: Curves.ease)));

    _padding = Tween<EdgeInsets>(
            begin: EdgeInsets.only(left: .0), end: EdgeInsets.only(left: 150))
        .animate(CurvedAnimation(
            parent: controller, curve: Interval(.6, 1.0, curve: Curves.ease)));
  }

  final AnimationController controller;
  late Animation<double> _height;
  late Animation<EdgeInsets> _padding;
  late Animation<Color?> _color;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: _padding.value,
      child: Container(
        color: _color.value,
        width: 50,
        height: _height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimation);
  }
}

class StaggerRoute extends StatefulWidget {
  @override
  _StaggerRouteState createState() => _StaggerRouteState();
}

class _StaggerRouteState extends State<StaggerRoute>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _controller!
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _controller!.reverse();
        else if (status == AnimationStatus.dismissed) _controller!.forward();
      });

    _controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(color: Colors.black.withOpacity(.5))),
        child: StaggerAnimation(
          controller: _controller!,
        ),
      ),
    );
  }
}

//和SlideTransition唯一的不同就是对动画的反向执行进行了（从左边滑出隐藏）
class MySlideTransition extends SlideTransition {
  const MySlideTransition({
    Key? key,
    required Animation<Offset> position,
    transformHitTests = true,
    textDirection,
    child,
  }) : super(
            key: key,
            position: position,
            transformHitTests: transformHitTests,
            textDirection: textDirection,
            child: child);

  @override
  Widget build(BuildContext context) {
    Offset offset = position.value;
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse)
      offset = Offset(-offset.dx, offset.dy);
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class SlideTransitionX extends AnimatedWidget {
  SlideTransitionX({
    Key? key,
    required Animation<double> position,
    this.direction = AxisDirection.left,
    this.transformHitTests = true,
    this.child,
  }) : super(key: key, listenable: position) {
    switch (direction) {
      case AxisDirection.up:
        _tween = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0));
        break;
      case AxisDirection.left:
        _tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        break;
    }
  }

  Animation<double> get position => listenable as Animation<double>;

  final AxisDirection direction;

  final bool transformHitTests;

  final Widget? child;

  late Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    Offset offset = _tween.evaluate(position);
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse) {
      switch (direction) {
        case AxisDirection.up:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.down:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.right:
          offset = Offset(-offset.dx, offset.dy);
          break;
        case AxisDirection.left:
          offset = Offset(-offset.dx, offset.dy);
          break;
      }
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class AnimatedWidgetsTest extends StatefulWidget {
  @override
  _AnimatedWidgetsTestState createState() => _AnimatedWidgetsTestState();
}

class _AnimatedWidgetsTestState extends State<AnimatedWidgetsTest> {
  double _padding = 10;
  var _align = Alignment.topRight;
  double _height = 100;
  double _left = 0;
  Color _color = Colors.red;
  TextStyle _style = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    var duration = Duration(milliseconds: 800);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              setState(() {
                _padding = 20;
              });
            },
            child: AnimatedPadding(
              duration: duration,
              padding: EdgeInsets.all(_padding),
              child: Text("AnimatedPadding"),
            ),
          ),
          SizedBox(
            height: 50,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: duration,
                  left: _left,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        _left = 100;
                      });
                    },
                    child: Text("AnimatedPositioned"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 100,
            color: Colors.grey,
            child: AnimatedAlign(
              duration: duration,
              alignment: _align,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _align = Alignment.center;
                  });
                },
                child: Text("AnimatedAlign"),
              ),
            ),
          ),
          AnimatedContainer(
            duration: duration,
            height: _height,
            color: _color,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _height = 150;
                  _color = Colors.blue;
                });
              },
              child: Text(
                "AnimatedContainer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            child: GestureDetector(
              child: Text("hello world"),
              onTap: () {
                setState(() {
                  _style = TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.blue,
                  );
                });
              },
            ),
            style: _style,
            duration: duration,
          ),
        ].map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: e,
          );
        }).toList(),
      ),
    );
  }
}
