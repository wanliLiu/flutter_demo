import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_module/base/provider.dart';

class Item {
  double price;
  int count;

  Item(this.price, this.count);
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  double get totalPrice =>
      _items.fold(0, (value, item) => value + item.count * item.price);

  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态
    notifyListeners();
  }
}

class ProviderRoute extends StatefulWidget {
  @override
  _ProviderRouteState createState() => _ProviderRouteState();
}

class _ProviderRouteState extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider<CartModel>(
          data: CartModel(),
          child: Builder(
            builder: (context) {
              return Column(
                children: <Widget>[
                  Builder(builder: (context) {
                    debugPrint("总价 build");
                    return Consumer<CartModel>(
                        builder: (context, cart) =>
                            Text("总价：${cart.totalPrice}"));
                  }),
                  Builder(builder: (context) {
                    debugPrint("ElevatedButton build");
                    return ElevatedButton(
                        child: Text("添加商品"),
                        onPressed: () =>
                            ChangeNotifierProvider.of<CartModel>(context,isListen: false)
                                .add(Item(0.23, 20)));
                  })
                ],
              );
            },
          )),
    );
  }
}
