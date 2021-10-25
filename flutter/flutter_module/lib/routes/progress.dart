import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('进度指示器'),
      ),
      body: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(),
              padding: const EdgeInsets.all(10),
              color: Colors.grey[400],
              child: Wrap(
                spacing: 20,
                runSpacing: 30,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  RefreshProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text("A"),
                    ),
                    label: Text("我是谁"),
                  ),
                  Chip(
                    label: Text("---我是谁----"),
                  ),
                  SizedBox(
                    width: 150,
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                    ),
                  ),
                  LinearProgressIndicator(
                    value: .3,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                    ),
                  ),
                  CircularProgressIndicator(
                    value: .5,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                  ),
                  ProgressRoute(),
                  Container(
                    color: Colors.blue[50],
                    child: Align(
                      alignment: Alignment.topCenter,
                      widthFactor: 2,
                      heightFactor: 1.5,
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
            right: 20,
            top: 450,
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Text(
                "hello world",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
              top: 50,
              width: 200,
              left: 20,
              child: Container(
                color: Colors.green,
                child:
                    Text("Coming again", style: TextStyle(color: Colors.white)),
              )),
          Container(
            width: 200,
            height: 150,
            //容器外填充
//            constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),
            //卡片大小
            decoration: BoxDecoration(
                //背景装饰
                gradient: RadialGradient(
                    //背景径向渐变
                    colors: [Colors.red, Colors.orange],
                    center: Alignment.topLeft,
                    radius: .98),
                boxShadow: [
                  //卡片阴影
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(-1.0, 2.0),
                      blurRadius: 4.0)
                ]),
            transform: Matrix4.rotationZ(.2),
            //卡片倾斜变换
            alignment: Alignment.center,
            //卡片内文字居中
            child: Text(
              //卡片文字
              "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          IconButton(icon: Icon(Icons.home),onPressed: (){},),
          SizedBox(),
          IconButton(icon: Icon(Icons.business),onPressed: (){},),
        ],),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ProgressRoute extends StatefulWidget {
  @override
  _ProgressRouteState createState() => _ProgressRouteState();
}

class _ProgressRouteState extends State<ProgressRoute>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationController!..addListener(() => setState(() => {}));
    _animationController!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.grey[200],
      valueColor: ColorTween(begin: Colors.red, end: Colors.blue)
          .animate(_animationController!),
      value: _animationController!.value,
    );
  }
}
