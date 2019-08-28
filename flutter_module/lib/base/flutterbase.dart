import 'package:flutter/material.dart';

class CustomHome extends Widget {
  @override
  Element createElement() {
    return _HomeView(this);
  }
}

/// 利用ComponentElement来实现类似StatefulWidget的组件
class _HomeView extends ComponentElement {
  _HomeView(Widget widget) : super(widget);

  String text = "123456789";

  @override
  Widget build() {
    Color primary = Theme.of(this).primaryColor;
    return GestureDetector(
      child: Center(
        child: FlatButton(
            onPressed: () {
              var t = text.split("")..shuffle();
              text = t.join();
              markNeedsBuild(); //点击后将该Element标记为dirty，Element将会rebuild
            },
            child: Text(
              text,
              style: TextStyle(color: primary),
            )),
      ),
    );
  }
}

//根据已经掌握的知识来实现一个简版的“Image组件”
class MyImage extends StatefulWidget {
  const MyImage({Key key, @required this.imageProvider})
      : assert(imageProvider != null),
        super(key: key);

  final ImageProvider imageProvider;

  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  ImageStream _imageStream;
  ImageInfo _imageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(MyImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageProvider != oldWidget.imageProvider) _getImage();
  }

  void _getImage() {
    final ImageStream oldImageStream = _imageStream;
    // 调用imageProvider.resolve方法，获得ImageStream。
    _imageStream =
        widget.imageProvider.resolve(createLocalImageConfiguration(context));
    //判断新旧ImageStream是否相同，如果不同，则需要调整流的监听器
    if (_imageStream.key != oldImageStream.key) {
      final ImageStreamListener listener = ImageStreamListener(_updateImage);
      oldImageStream?.removeListener(listener);
      _imageStream.addListener(listener);
    }
  }

  void _updateImage(ImageInfo image, bool synchronousCall) {
    setState(() {
      _imageInfo = image;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _imageStream?.removeListener(ImageStreamListener(_updateImage));
  }

  @override
  Widget build(BuildContext context) {
    return RawImage(
      image: _imageInfo?.image,
      scale: _imageInfo?.scale ?? 1.0,
    );
  }
}

class TipRoute extends StatelessWidget {
  TipRoute({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop("我是返回值哦  大胜靠德！！！");
                },
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
