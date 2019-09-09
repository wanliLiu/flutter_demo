import 'package:flutter/material.dart';

class FadeRoute extends PageRoute {
  FadeRoute({@required this.builder});

  final WidgetBuilder builder;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (isActive)
      return FadeTransition(opacity: animation, child: child);
    else
      return ScaleTransition(
        scale: animation,
        child: child,
      );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
