import 'package:fluttertoast/fluttertoast.dart';

class VaeToast {

  ///
  ///[msg] 内容
  ///
  ///
  static void showToast(String msg,
      {Toast time = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(msg: msg, toastLength: time, gravity: gravity);
  }
}
