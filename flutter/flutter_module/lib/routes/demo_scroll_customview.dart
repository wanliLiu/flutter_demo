import 'package:flutter/material.dart';

import 'demo_scroll.dart';

class StickyBarDelegate extends SliverPersistentHeaderDelegate {
  StickyBarDelegate({this.child});

  final Widget? child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    debugPrint('StickyTabBarDelegate--->build--->$shrinkOffset');
    return child!;
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class DemoCustomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget child = CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
            pinned: true,
            delegate: SliverCustomHeaderDelegate(
              collapsedHeight: kToolbarHeight,
              expandedHeight: 250,
              paddingTop: MediaQuery.of(context).padding.top,
              coverImgUrl:
                  'https://s2.showstart.com/img/2019/20190228/fdaa366eb7174016af325021dd8642fe_600_800_131758.0x0.jpg',
              title: 'CusomtScrollView',
            )),
        SliverPersistentHeader(
            pinned: true,
            delegate: StickyBarDelegate(
                child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Text("我是Sticker"),
            ))),
        SliverToBoxAdapter(
          child: Container(
            constraints: BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: Text(
              "各种滑动视图混用--SliverGrid",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.cyan[100 * (index % 9)],
                  child: Text("Grid item $index"),
                );
              }, childCount: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4)),
        ),
        SliverToBoxAdapter(
          child: Container(
            constraints: BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: Text(
              "各种滑动视图混用---SliverList",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          //创建列表项
          return ListTile(
            title: Text("我是内容-->$index"),
          );
        }, childCount: 10)),
        SliverToBoxAdapter(
          child: Container(
            constraints: BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: Text(
              "各种滑动视图混用---SliverFixedExtentList",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate((context, index) {
              //创建列表项
              return new Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: new Text('list item $index'),
              );
            }, childCount: 25),
            itemExtent: 70)
      ],
    );

    child = Scaffold(
      body: child,
    );

    return child;
  }
}
