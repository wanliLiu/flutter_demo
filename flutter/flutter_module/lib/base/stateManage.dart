import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({Key? key, required this.active, this.highligt = false})
      : super(key: key);

  final bool active;
  final bool highligt;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border:
              highligt ? Border.all(color: Colors.teal[700]!, width: 5) : null,
          color: active ? Colors.lightGreen[700] : Colors.grey[600]),
    );
  }
}

///Widget管理自身状态
class TapBoxA extends StatefulWidget {
  @override
  _TapBoxAState createState() => _TapBoxAState();
}

class _TapBoxAState extends State<TapBoxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Box(active: _active),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return TapboxB(
        active: _active,
        onChanged: (bool newValue) {
          setState(() {
            _active = !newValue;
          });
        });
  }
}

class TapboxB extends StatelessWidget {
  TapboxB({Key? key, this.active = false, required this.onChanged})
      : assert(onChanged != null),
        super(key: key) {
    debugPrint("构造函数");
  }

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Box(active: active),
    );
  }
}

class ParentWidgetC extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParentWidgetCState();
  }
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return TapboxC(
        active: _active,
        onChanged: (bool newvalue) {
          setState(() {
            _active = !newvalue;
          });
        });
  }
}

class TapboxC extends StatefulWidget {
  TapboxC({Key? key, this.active = false, required this.onChanged})
      : assert(onChanged != null),
        super(key: key) {
    debugPrint("构造函数");
  }

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  _TapboxCState createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 在按下时添加绿色边框，当抬起时，取消高亮
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (TapUpDetails details) {
        setState(() {
          _highlight = false;
        });
      },
      onTap: () {
        widget.onChanged(widget.active);
      },
      onTapCancel: () {
        setState(() {
          _highlight = false;
        });
      },
      child: Box(
        active: widget.active,
        highligt: _highlight,
      ),
    );
  }
}
