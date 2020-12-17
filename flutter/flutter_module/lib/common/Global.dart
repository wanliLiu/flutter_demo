import 'dart:io';

class Global {
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    try {} catch (e) {}
  }
}
