import 'package:flutter/material.dart';
import 'package:flutter_module/common/Global.dart';
import 'package:path_provider/path_provider.dart';

class Echo extends StatelessWidget {
  const Echo(
      {Key? key, required this.text, this.backgroundColor: Colors.blueAccent})
      : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

class Flutterview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Echo(
              text: "我是文字内容",
              backgroundColor: Colors.yellow,
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/timg.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: Image.asset(
                "imgs/timg.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            PathDirecory(),
          ],
        ));
  }
}

class PathDirecory extends StatelessWidget {
  Future<String> getPath() async {
    var temporaryDirectory = (await getTemporaryDirectory()).path;
    var applicationSupportDirectory =
        (await getApplicationSupportDirectory()).path;
//    var libraryDirectory = (await getLibraryDirectory()).path;
    var applicationDocumentsDirectory =
        (await getApplicationDocumentsDirectory()).path;

    var externalStorageDirectory = "";
    if (Global.isAndroid)
      externalStorageDirectory = (await getExternalStorageDirectory())!.path;

    return "\ntemporaryDirectory:\n$temporaryDirectory\n\n"
        "applicationSupportDirectory:\n$applicationSupportDirectory\n\n"
//        "libraryDirectory:$libraryDirectory\n"
        "applicationDocumentsDirectory:\n$applicationDocumentsDirectory\n\n"
        "${Global.isAndroid ? "externalStorageDirectory:\n$externalStorageDirectory\n\n" : ""}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getPath(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Text("error");
          else
            return Text(
              snapshot.data!,
              style: TextStyle(fontSize: 16, wordSpacing: 10),
            );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}
