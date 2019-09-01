import 'package:flutter/material.dart';

class TextFiledPage extends StatefulWidget {
  @override
  _TextFiledPageState createState() => _TextFiledPageState();
}

class _TextFiledPageState extends State<TextFiledPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = "Soifa4041";
    _nameController.selection =
        TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
    _pwdController.text = "1293020li";

    _nameController.addListener(
        () => debugPrint("controller-name-->${_nameController.text}"));

    _pwdController.addListener(
        () => debugPrint("controller-pwd-->${_pwdController.text}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("输入框和表单"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              onChanged: (str) => debugPrint("onChanged--name->$str"),
              decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名或邮箱",
                  prefixIcon: Icon(Icons.person)),
            ),
            TextField(
              onChanged: (str) => debugPrint("onChanged--pwd->$str"),
              controller: _pwdController,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "您的登录密码",
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }
}
