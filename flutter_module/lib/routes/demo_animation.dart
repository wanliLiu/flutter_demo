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
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    _animation = Tween(begin: 0.0, end: 300.0).animate(_animation);
    _animation
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
        animation: _animation,
        builder: (context, child) => Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "imgs/like.jpeg",
                width: _animation.value,
                height: _animation.value,
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
  AnimateImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> _animation = listenable;
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
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
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
  Animation<double> _height;
  Animation<EdgeInsets> _padding;
  Animation<Color> _color;

  Widget _buildAnimation(BuildContext context, Widget child) {
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
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _controller.reverse();
        else if (status == AnimationStatus.dismissed) _controller.forward();
      });

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          controller: _controller,
        ),
      ),
    );
  }
}
