import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_module/widget/TurnBox.dart';

class CustomPaintDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: RepaintBoundary(
            child: CustomPaint(
          size: Size(300, 300), //有child的时候这个不管用
          painter: _ChessPainter(),
//          foregroundPainter: MyPainter(),
          child: RepaintBoundary(
            child: Container(
              alignment: Alignment.topCenter,
//            color: Colors.red,
              width: 300,
              height: 300,
              child: Container(
                color: Colors.green.withOpacity(.5),
                width: 300,
                height: 40,
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _ChessPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / 15;
    double eHeight = size.height / 15;

    //画棋盘背景
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color(0x77cdb175);
    canvas.drawRect(Offset.zero & size, paint);

    //画棋盘网格
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.black87
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 15; i++) {
      double dy = eWidth * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    for (int i = 0; i <= 15; i++) {
      double dx = eHeight * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    //画一个黑子
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawCircle(
        Offset(size.width / 2 - eWidth / 2, size.height / 2 - eHeight / 2),
        min(eWidth / 2, eHeight / 2) - 2,
        paint);

    paint..color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2 + eWidth / 2, size.height / 2 + eHeight / 2),
        min(eWidth / 2, eHeight / 2) - 2,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GradientCircularProgressRoute extends StatefulWidget {
  @override
  GradientCircularProgressRouteState createState() {
    return GradientCircularProgressRouteState();
  }
}

class GradientCircularProgressRouteState
    extends State<GradientCircularProgressRoute> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    bool isForward = true;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        isForward = true;
      } else if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (isForward) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else if (status == AnimationStatus.reverse) {
        isForward = false;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Column(
              children: <Widget>[
                Wrap(
                  spacing: 10.0,
                  runSpacing: 16.0,
                  children: <Widget>[
                    GradientCircularProgressIndicator(
                      // No gradient
                      colors: [Colors.blue, Colors.blue],
                      radius: 30.0,
                      strokeCapRound: true,
                      strokeWidth: 5.0,
                      value: _animationController.value,
                    ),
                    GradientCircularProgressIndicator(
                      colors: [Colors.red, Colors.orange],
                      radius: 30.0,
                      strokeWidth: 3.0,
                      value: _animationController.value,
                    ),
                    GradientCircularProgressIndicator(
                      colors: [Colors.red, Colors.orange, Colors.red],
                      radius: 30.0,
                      strokeWidth: 5.0,
                      value: _animationController.value,
                    ),
                    GradientCircularProgressIndicator(
                      colors: [Colors.teal, Colors.cyan],
                      radius: 30.0,
                      strokeWidth: 5.0,
                      strokeCapRound: true,
                      value: CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.bounceIn)
                          .value,
                    ),
                    TurnBox(
                      turns: 1 / 8,
                      child: GradientCircularProgressIndicator(
                          colors: [Colors.red, Colors.orange, Colors.red],
                          radius: 30.0,
                          strokeWidth: 5.0,
                          strokeCapRound: true,
                          backgroundColor: Colors.red[50],
                          totalAngle: 1.5 * pi,
                          value: CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.ease)
                              .value),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GradientCircularProgressIndicator(
                          colors: [Colors.blue[700]!, Colors.blue[200]!],
                          radius: 30.0,
                          strokeWidth: 3.0,
                          strokeCapRound: true,
                          backgroundColor: Colors.transparent,
                          value: _animationController.value),
                    ),
                    GradientCircularProgressIndicator(
                      colors: [
                        Colors.red,
                        Colors.amber,
                        Colors.cyan,
                        Colors.green[200]!,
                        Colors.blue,
                        Colors.red
                      ],
                      radius: 30.0,
                      strokeWidth: 5.0,
                      strokeCapRound: true,
                      value: _animationController.value,
                    ),
                  ],
                ),
                GradientCircularProgressIndicator(
                  colors: [Colors.blue[700]!, Colors.blue[200]!],
                  radius: 50.0,
                  strokeWidth: 10.0,
                  value: _animationController.value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GradientCircularProgressIndicator(
                    colors: [Colors.blue[700]!, Colors.blue[300]!],
                    radius: 50.0,
                    strokeWidth: 10.0,
                    value: _animationController.value,
                    strokeCapRound: true,
                  ),
                ),
                //剪裁半圆
                Align(
                    heightFactor: 0.5,
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TurnBox(
                        turns: .75,
                        child: GradientCircularProgressIndicator(
                          colors: [Colors.teal, Colors.cyan[500]!],
                          radius: 50.0,
                          strokeWidth: 10.0,
                          value: _animationController.value,
                          totalAngle: pi,
                          strokeCapRound: true,
                        ),
                      ),
                    )),
                //注意和上面的区别
                TurnBox(
                  turns: .75,
                  child: GradientCircularProgressIndicator(
                    colors: [Colors.teal, Colors.cyan[500]!],
                    radius: 50.0,
                    strokeWidth: 10.0,
                    value: _animationController.value,
//                    totalAngle: pi,
                    strokeCapRound: true,
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(0.5),
                  height: 52.0,
                  width: 100.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
//                        height: 200.0,
                        top: .0,
                        child: TurnBox(
                          turns: 0.75,
                          child: GradientCircularProgressIndicator(
                            colors: [Colors.teal, Colors.cyan[500]!],
                            radius: 50.0,
                            strokeWidth: 8.0,
                            value: _animationController.value,
                            totalAngle: pi,
                            strokeCapRound: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "${(_animationController.value * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class GradientCircularProgressIndicator extends StatelessWidget {
  GradientCircularProgressIndicator(
      {this.strokeWidth = 2.0,
      required this.radius,
      required this.colors,
      this.stops,
      this.strokeCapRound = false,
      this.backgroundColor = const Color(0xFFEEEEEE),
      this.totalAngle = 2 * pi,
      this.value});

  ///粗细
  final double strokeWidth;

  /// 圆的半径
  final double radius;

  ///两端是否为圆角
  final bool strokeCapRound;

  /// 当前进度，取值范围 [0.0-1.0]
  final double? value;

  /// 进度条背景色
  final Color? backgroundColor;

  /// 进度条的总弧度，2*PI为整圆，小于2*PI则不是整圆
  final double totalAngle;

  /// 渐变色数组
  final List<Color> colors;

  /// 渐变色的终止点，对应colors属性
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound) {
      _offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }
    var _colors = colors;
    if (_colors == null) {
      Color color = Theme.of(context).accentColor;
      _colors = [color, color];
    }
    return Transform.rotate(
      angle: -pi / 2.0 - _offset,
      child: CustomPaint(
          size: Size.fromRadius(radius),
          painter: _GradientCircularProgressPainter(
            strokeWidth: strokeWidth,
            strokeCapRound: strokeCapRound,
            backgroundColor: backgroundColor,
            value: value,
            total: totalAngle,
            radius: radius,
            colors: _colors,
          )),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  const _GradientCircularProgressPainter(
      {this.strokeWidth: 10.0,
      this.strokeCapRound = false,
      this.backgroundColor = const Color(0xFFEEEEEE),
      this.radius,
      this.total = 2 * pi,
      required this.colors,
      this.stops,
      this.value});

  final double strokeWidth;
  final bool strokeCapRound;
  final double? value;
  final Color? backgroundColor;
  final List<Color> colors;
  final double total;
  final double? radius;
  final List<double>? stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) size = Size.fromRadius(radius!);

    double _offset = strokeWidth / 2.0;
    double _value = value ?? .0;
    _value = _value.clamp(.0, 1) * total;
    double _start = .0;

    if (strokeCapRound) _start = asin(strokeWidth / (size.width - strokeWidth));

    Rect rect = Offset(_offset, _offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    // 先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor!;
      canvas.drawArc(rect, _start, total, false, paint);
    }

    // 再画前景，应用渐变
    if (_value > 0) {
      paint.shader = SweepGradient(
              colors: colors, startAngle: 0.0, endAngle: _value, stops: stops)
          .createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
