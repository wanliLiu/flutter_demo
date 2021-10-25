import 'package:flutter/material.dart';

double _width = 200.0; //通过修改图片宽度来达到缩放效果

class PointerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("PointerPage--build");
    return Scaffold(
      appBar: AppBar(
        title: Text("事件处理"),
      ),
      body: ListView(
        children: <Widget>[
          StatefulBuilder(builder: (context, setState) {
            return Center(
              child: GestureDetector(
                //指定宽度，高度自适应
                child: Image.asset("imgs/like.jpeg", width: _width),
                onScaleUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    //缩放倍数在0.8到10倍之间
                    _width = 200 * details.scale.clamp(.8, 10.0);
                  });
                },
              ),
            );
          }),
          TouchPointer(),
          Listener(
//            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
                child: Center(
                  child: Text("Box A"),
                ),
                constraints: BoxConstraints.tight(Size(300, 100))),
            onPointerDown: (event) => debugPrint("down A"),
          ),
          Stack(
            children: <Widget>[
              Listener(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(300.0, 100.0)),
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue)),
                ),
                onPointerDown: (event) => print("down0"),
              ),
              Listener(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(200.0, 50.0)),
                  child: Center(child: Text("左上角200*100范围内非文本区域点击")),
                ),
                onPointerDown: (event) => print("down1"),
//                behavior: HitTestBehavior.translucent, //放开此行注释后可以"点透"
//                behavior: HitTestBehavior.opaque,
              ),
            ],
          ),
          Listener(
            //AbsorbPointer
            child: IgnorePointer(
              child: Listener(
                child: Container(
                  color: Colors.red,
                  width: 200.0,
                  height: 100.0,
                ),
                onPointerDown: (event) => print("in"),
              ),
            ),
            onPointerDown: (event) => print("up"),
          ),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.grey,
            child: _Drag(),
          ),
          _ScaleTestRoute(),
        ],
      ),
    );
  }
}

class _ScaleTestRoute extends StatefulWidget {
  @override
  _ScaleTestRouteState createState() => _ScaleTestRouteState();
}

class _ScaleTestRouteState extends State<_ScaleTestRoute> {
  double _width = 200.0; //通过修改图片宽度来达到缩放效果

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        //指定宽度，高度自适应
        child: Image.asset("imgs/like.jpeg", width: _width),
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            //缩放倍数在0.8到10倍之间
            _width = 200 * details.scale.clamp(.8, 10.0);
          });
        },
      ),
    );
  }
}

class _Drag extends StatefulWidget {
  @override
  _DragState createState() => new _DragState();
}

class _DragState extends State<_Drag> with SingleTickerProviderStateMixin {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e) {
              //打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
        )
      ],
    );
  }
}

class TouchPointer extends StatefulWidget {
  @override
  _TouchPointerState createState() => _TouchPointerState();
}

class _TouchPointerState extends State<TouchPointer> {
  PointerEvent? _event;

  void _dealPointer(PointerEvent event) {
    setState(() {
      _event = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.blue,
        child: Text(_event?.toString() ?? "",
            style: TextStyle(color: Colors.white)),
      ),
      onPointerDown: _dealPointer,
      onPointerMove: _dealPointer,
      onPointerUp: _dealPointer,
      onPointerCancel: _dealPointer,
    );
  }
}
