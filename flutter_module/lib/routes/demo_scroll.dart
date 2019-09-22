import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/base/BasePage.dart';
import 'package:flutter_module/routes/tab_history.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum ListType { SingleChildScrollView, ListView, GridView, StaggeredGridView }

class PageListRoot extends StatefulWidget {
  PageListRoot(this.type);

  final ListType type;

  @override
  _PageRootState createState() => _PageRootState();
}

class _PageRootState extends State<PageListRoot> with BasePage {
  @override
  Widget get content {
    debugPrint("_PageRootState------>content");

    if (widget.type == ListType.SingleChildScrollView)
      return TabHistory(
        controller: controller,
      );
    else if (widget.type == ListType.ListView)
      return InfiniteListView(
        controller: controller,
      );
    else if (widget.type == ListType.GridView)
      return TestGridView(
        controller: controller,
      );
    else if (widget.type == ListType.StaggeredGridView)
      return TestGridView.staggered(
        controller: controller,
      );
    else
      return Center(
        child: Text("没有"),
      );
  }

  @override
  Widget get title {
    if (widget.type == ListType.SingleChildScrollView)
      return Text("SingleChildScrollView");
    else if (widget.type == ListType.ListView)
      return Text("ListView");
    else if (widget.type == ListType.GridView)
      return Text("GridView");
    else if (widget.type == ListType.StaggeredGridView)
      return Text("StaggeredGridView");
    else
      return Center(
        child: Text("没有"),
      );
  }
}

class InfiniteListView extends StatefulWidget {
  InfiniteListView({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##";
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  void _retrieveData() {
    Future.delayed(Duration(milliseconds: 500)).then((e) {
      _words.insertAll(_words.length - 1,
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.blue,
          padding: EdgeInsets.all(16),
          child: Text(
            "商品列表",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
            flex: 1,
            child: Scrollbar(
              child: ListView.separated(
                itemCount: _words.length,
                controller: widget.controller,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  if (_words[index] == loadingTag) {
                    if (_words.length - 1 < 500) {
                      _retrieveData();
                      return Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: RefreshProgressIndicator(),
                      );
                    } else
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "没有更多了",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                  }

                  return index % 4 == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              title: Text(_words[index]),
                            ),
                            Container(
                              color: Colors.grey,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "我是分类-->$index",
                                style: TextStyle(color: Colors.red),
                                textScaleFactor: 2,
                              ),
                            )
                          ],
                        )
                      : ListTile(
                          title: Text(_words[index]),
                        );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class TestGridView extends StatefulWidget {
  TestGridView({this.useStr: false, this.controller});

  TestGridView.staggered({this.useStr: true, this.controller});

  final bool useStr;

  final ScrollController controller;

  @override
  _TestGridViewState createState() => _TestGridViewState();
}

class _TestGridViewState extends State<TestGridView> {
  List<ItemData> _list = [];

  @override
  void initState() {
    super.initState();
    _retrieveIcons();
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _list.addAll([
          ItemData(Colors.blue, Icons.ac_unit),
          ItemData(Colors.red, Icons.airport_shuttle),
          ItemData(Colors.yellow, Icons.all_inclusive),
          ItemData(Colors.grey, Icons.beach_access),
          ItemData(Colors.blueGrey, Icons.cake),
          ItemData(Colors.teal, Icons.free_breakfast),
          ItemData(Colors.deepPurple, Icons.ac_unit),
          ItemData(Colors.blue, Icons.ac_unit),
          ItemData(Colors.red, Icons.airport_shuttle),
          ItemData(Colors.yellow, Icons.all_inclusive),
          ItemData(Colors.grey, Icons.beach_access),
          ItemData(Colors.blueGrey, Icons.cake),
          ItemData(Colors.teal, Icons.free_breakfast),
          ItemData(Colors.deepPurple, Icons.ac_unit),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useStr)
      return Scrollbar(
        child: StaggeredGridView.countBuilder(
            controller: widget.controller,
            crossAxisCount: 3,
            itemCount: _list.length,
            padding: EdgeInsets.all(10),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (BuildContext context, int index) {
              if (index == _list.length - 1 && _list.length < 400) {
                _retrieveIcons();
              }
              return ItemGridView(_list[index], index);
            },
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(1, index % 3 == 0 ? 2 : 1)),
      );

    return GridView.builder(
        controller: widget.controller,
        itemCount: _list.length,
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//            mainAxisSpacing: 10,
//            crossAxisSpacing: 10,
//            crossAxisCount: 2,
            childAspectRatio: 2,
            maxCrossAxisExtent: 200),
        itemBuilder: (BuildContext context, int index) {
          if (index == _list.length - 1 && _list.length < 400) {
            _retrieveIcons();
          }
          return ItemGridView(_list[index], index);
        });
  }
}

class ItemData {
  const ItemData(this.itemColor, this.itemIcon);

  final Color itemColor;
  final IconData itemIcon;
}

class ItemGridView extends StatelessWidget {
  ItemGridView(this.data, this.index);

  final ItemData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: data.itemColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(data.itemIcon),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 13,
              child: Text(
                "$index",
                style: TextStyle(fontSize: 13),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final String title;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    debugPrint('SliverCustomHeaderDelegate----->build---->$shrinkOffset');
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 背景图
          Container(child: Image.network(this.coverImgUrl, fit: BoxFit.cover)),
          // 收起头部
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this.makeStickyHeaderBgColor(shrinkOffset), // 背景颜色
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const BackButtonIcon(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: this.makeStickyHeaderTextColor(
                              shrinkOffset, true), // 返回图标颜色
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        this.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: this.makeStickyHeaderTextColor(
                              shrinkOffset, false), // 标题颜色
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: this.makeStickyHeaderTextColor(
                              shrinkOffset, true), // 分享图标颜色
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  StickyTabBarDelegate({this.child});

  final TabBar child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    debugPrint('StickyTabBarDelegate--->build--->$shrinkOffset');
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CustomScrollViewTestRoute extends StatefulWidget {
  @override
  _CustomScrollViewTestRouteState createState() =>
      _CustomScrollViewTestRouteState();
}

///
/// 这个和Android那一套效果一样
///
class _CustomScrollViewTestRouteState extends State<CustomScrollViewTestRoute>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Demo"),
              collapseMode: CollapseMode.none,
              background: Image.asset(
                "imgs/like.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),

//          SliverPersistentHeader(
//              pinned: true,
//              delegate: SliverCustomHeaderDelegate(
//                  collapsedHeight: kToolbarHeight,
//                  expandedHeight: 250,
//                  coverImgUrl: 'https://s2.showstart.com/img/2019/20190509/b39fdd31c1364a34a9fd493ced5c7bb8_600_800_124429.0x0.jpg?imageMogr2/thumbnail/!275x368r/gravity/Center/crop/!275x368',
//                  title: ('我是谁'))),

          SliverPersistentHeader(
              pinned: true,
//              floating: true,
              delegate: StickyTabBarDelegate(
                  child: TabBar(
                      controller: tabController,
                      labelColor: Colors.black,
                      tabs: <Widget>[
                    Tab(
                      text: "Home",
                    ),
                    Tab(
                      text: "Profile",
                    )
                  ]))),

          SliverFillRemaining(
            child: TabBarView(controller: tabController, children: <Widget>[
              Center(child: Text('Content of Home')),
              Center(child: Text('Content of Profile')),
            ]),
          )
//          SliverToBoxAdapter(
//            child: Container(
//              constraints: BoxConstraints.expand(height: 20),
//              color: Colors.red.withOpacity(0.5),
//            ),
//          ),
//
//          SliverPadding(
//            padding: const EdgeInsets.all(8),
//            sliver: SliverGrid(
//                delegate: SliverChildBuilderDelegate((context, index) {
//                  return Container(
//                    alignment: Alignment.center,
//                    color: Colors.cyan[100 * (index % 9)],
//                    child: Text("Grid item $index"),
//                  );
//                }, childCount: 20),
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 2,
//                    mainAxisSpacing: 10,
//                    crossAxisSpacing: 10,
//                    childAspectRatio: 4)),
//          ),
//
//          SliverList(
//              delegate: SliverChildBuilderDelegate((context, index) {
//            //创建列表项
//            return ListTile(
//              title: Text("我是内容-->$index"),
//            );
//          }, childCount: 10)),
//
//          SliverFixedExtentList(
//              delegate: SliverChildBuilderDelegate((context, index) {
//                //创建列表项
//                return new Container(
//                  alignment: Alignment.center,
//                  color: Colors.lightBlue[100 * (index % 9)],
//                  child: new Text('list item $index'),
//                );
//              }, childCount: 50),
//              itemExtent: 50)
        ],
      ),
    );
  }
}
