import 'package:flutter/material.dart';
import 'package:flutter_module/common/Toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextFiledPage extends StatefulWidget {
  const TextFiledPage(
      {Key? key, required this.defaultName, required this.defaultPwd})
      : assert(defaultPwd != null),
        assert(defaultName != null),
        super(key: key);

  final String defaultName;
  final String defaultPwd;

  @override
  _TextFiledPageState createState() => _TextFiledPageState();
}

class _TextFiledPageState extends State<TextFiledPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.defaultName;
    _nameController.selection =
        TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
    _pwdController.text = widget.defaultPwd;

    _nameController.addListener(
        () => debugPrint("controller-name-->${_nameController.text}"));

    _pwdController.addListener(
        () => debugPrint("controller-pwd-->${_pwdController.text}"));
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      appBar: AppBar(
        title: Text("输入框和表单"),
      ),
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
//                margin: EdgeInsets.only(top: 20),
//                color: Colors.grey[100],
              constraints: BoxConstraints(minHeight: 50, maxHeight: 100),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                  controller: _pwdController,
                  //默认1行 null无线行
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
//                    focusNode: focusNode1,
//                    textInputAction: TextInputAction.done,
                  style: TextStyle(color: Color(0xFF333333), fontSize: 16),
//                    onEditingComplete: () =>
//                        VaeToast.showToast("onEditingComplete"),
//                    onSubmitted: (value) => VaeToast.showToast(value),
                  decoration: InputDecoration(
                      hintText: "输入你想要的内容",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none)),
            ),
            Form(
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    controller: _nameController,
                    onChanged: (str) => debugPrint("onChanged--name->$str"),
                    decoration: InputDecoration(
                        labelText: "用户名",
                        hintText: "用户名或邮箱",
                        prefixIcon: Icon(Icons.person)),
                    validator: (v) => v!.trim().length > 0 ? null : "用户名不能为空",
                  ),
                  Container(
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "----" * 200,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Transform.scale(
                          scale: 2,
                          child: Text("下划线"),
                        ),
                        Expanded(
                          child: Text(
                            "----" * 200,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    onChanged: (str) => debugPrint("onChanged--pwd->$str"),
                    controller: _pwdController,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "您的登录密码",
                        prefixIcon: Icon(Icons.lock)),
                    obscureText: true,
                    validator: (v) => v!.trim().length > 15 ? null : "密码不能少于15位",
                  ),
                  Builder(
                      builder: (context) => RaisedButton(
                            child: Text("登录"),
                            onPressed: () {
                              if (Form.of(context)!.validate()) {
                                Navigator.of(context).pop(
                                    "用户名：${_nameController.text} \n 密码：${_pwdController.text}");
                              } else
                                VaeToast.showToast("输入不合法",
                                    gravity: ToastGravity.CENTER);
                            },
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
        child: child,
        onWillPop: () async {
          return true;
        });
  }
}
