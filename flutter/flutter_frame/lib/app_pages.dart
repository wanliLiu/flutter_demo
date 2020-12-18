import 'package:flutter/material.dart';
import 'package:flutter_frame/demo/demo.dart';

const String defaultInitName = "/main/page";

const String NanmeSecondePage = "SecondPage";

Map<String, WidgetBuilder> pages = {
  defaultInitName: (ctx) => HomePage(),
  NanmeSecondePage: (ctx) => SecondPage()
};
