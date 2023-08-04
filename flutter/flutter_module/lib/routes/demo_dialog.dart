import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/common/Toast.dart';

class DialogPage extends StatefulWidget {
  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  bool? _chek = false;

  Future<void> changeLanguage() async {
    int? i = await showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择语言'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('中文简体'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('美国英语'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Dialog状态管理 StatefulBuilder"),
                      StatefulBuilder(builder: (context, setState) {
                        return Checkbox(
                          value: _chek,
                          onChanged: (value) => setState(() => _chek = value),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Builder(builder: (context) {
                return Checkbox(
                    value: _chek,
                    onChanged: (vale) {
                      _chek = vale;
                      (context as Element).markNeedsBuild();
                    });
              })
            ],
          );
        });

    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
  }

  // 弹出底部菜单列表模态对话框
  Future<int?> _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
    );
  }

  Future<bool?> _showDeleteDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("我是标题"),
              content: Text("我是描述文字、、、、文字" * 40),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("取消")),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("确认")),
              ],
            ));
  }

  // 返回的是一个controller
  PersistentBottomSheetController<int> _showBottomSheet(BuildContext mCtx) {
    return showBottomSheet<int>(
      context: mCtx,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () {
                // do something
                print("$index");
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
//          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 230,
//            height: 250,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text("请稍后..."),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker1() {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add(
        //未来30天可选
        Duration(days: 30),
      ),
    );
  }

  Future<DateTime?> _showDatePicker2() {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(
              Duration(days: 30),
            ),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print(value);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dialog"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // bool result = await (_showDeleteDialog() as FutureOr<bool>);
                // VaeToast.showToast(result ? "确认删除" : "取消删除");
              },
              child: Text("对话框1"),
            ),
            ElevatedButton(
              onPressed: () => changeLanguage(),
              child: Text("SimpleDialog"),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await _showModalBottomSheet();
                debugPrint("$result");
              },
              child: Text("底部菜单列表"),
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => _showBottomSheet(context),
                child: Text("ShowBottomSheet"),
              );
            }),
            ElevatedButton(
              onPressed: () => showLoadingDialog(),
              child: Text("ShowLoadingDialog"),
            ),
            ElevatedButton(
              onPressed: () => _showDatePicker1(),
              child: Text("ShowDateTimePicker"),
            ),
            ElevatedButton(
              onPressed: () => _showDatePicker2(),
              child: Text("ShowDateTimePicker --IOS"),
            ),
          ],
        ),
      ),
    );
  }
}
