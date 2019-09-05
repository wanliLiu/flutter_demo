import 'package:flutter/material.dart';

mixin BasePage<T extends StatefulWidget> on State<T> {
  @protected
  Widget get content;

  @protected
  Widget get title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: content,
    );
  }
}
