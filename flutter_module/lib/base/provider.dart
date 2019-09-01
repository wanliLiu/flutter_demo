import 'package:flutter/material.dart';

// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  const InheritedProvider({Key key, @required this.data, Widget child})
      : super(key: key, child: child);

  final T data;

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

Type _typeof<T>() => T;

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({Key key, this.data, this.child}) : super(key: key);

  final Widget child;
  final T data;

  @override
  _ChangeNotifierProviderState createState() => _ChangeNotifierProviderState();

  ///
  ///
  static T of<T>(BuildContext context, {bool isListen = true}) {
    final type = _typeof<InheritedProvider<ChangeNotifier>>();
    final provider = isListen
        ? context.inheritFromWidgetOfExactType(type) as InheritedProvider
        : context.ancestorInheritedElementForWidgetOfExactType(type)?.widget
            as InheritedProvider;

    return provider.data as T;
  }
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

class Consumer<T> extends StatelessWidget {
  const Consumer({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, ChangeNotifierProvider.of<T>(context));
  }
}
