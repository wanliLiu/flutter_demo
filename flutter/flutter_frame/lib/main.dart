import 'package:flutter/material.dart';
import 'package:flutter_frame/app_pages.dart';
import 'package:flutter_frame/global_constant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: appBarTheme,
            scaffoldBackgroundColor: defualtBackgroundColor),
        routes: pages,
        initialRoute: defaultInitName);
  }
}
