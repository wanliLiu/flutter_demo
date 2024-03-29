import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demon/base/BasePage.dart';
import 'package:flutter_demon/routes/tab_history.dart';

import 'demo_scroll_customview.dart';
import 'demon_pull_load.dart';

enum ListType {
  SingleChildScrollView,
  ListView,
  GridView,
  StaggeredGridView,
  DemoPullLoad
}

class PageListRoot extends StatefulWidget {
  PageListRoot(this.type);

  final ListType type;

  @override
  State<PageListRoot> createState() => _PageRootState();
}

class _PageRootState extends State<PageListRoot> with BasePage {
  @override
  Widget get content {
    debugPrint("_PageRootState------>content");

    if (widget.type == ListType.SingleChildScrollView) {
      return TabHistory(
        controller: controller,
      );
    } else if (widget.type == ListType.ListView) {
      return InfiniteListView(
        controller: controller,
      );
    } else if (widget.type == ListType.GridView) {
      return TestGridView(
        controller: controller,
      );
    } else if (widget.type == ListType.StaggeredGridView) {
      return TestGridView.staggered(
        controller: controller,
      );
    } else if (widget.type == ListType.DemoPullLoad) {
      return const NewsPage();
    } else {
      return const Center(
        child: Text("没有"),
      );
    }
  }

  @override
  Widget get title {
    if (widget.type == ListType.SingleChildScrollView) {
      return const Text("SingleChildScrollView");
    } else if (widget.type == ListType.ListView) {
      return const Text("ListView");
    } else if (widget.type == ListType.GridView) {
      return const Text("GridView");
    } else if (widget.type == ListType.StaggeredGridView) {
      return const Text("StaggeredGridView");
    } else if (widget.type == ListType.DemoPullLoad) {
      return const Text("DemoPullLoad");
    } else {
      return const Center(
        child: Text("没有"),
      );
    }
  }
}

class InfiniteListView extends StatefulWidget {
  InfiniteListView({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##";
  final _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  Future<void> _retrieveData() async {
    await Future.delayed(const Duration(milliseconds: 4000)).then((e) {
      _words.insertAll(_words.length - 1,
          generateWordPairs().take(100).map((e) => e.asPascalCase).toList());
      setState(() {});
    });
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    // 持续两秒
    await _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16),
          child: const Text(
            "商品列表",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Scrollbar(
                child: ListView.separated(
                  itemCount: _words.length,
                  controller: widget.controller,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    if (_words[index] == loadingTag) {
                      if (_words.length - 1 < 500) {
                        _retrieveData();
                        return Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: const RefreshProgressIndicator(),
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "没有更多了",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "我是分类-->$index",
                                  style: const TextStyle(color: Colors.red),
                                  textScaleFactor: 2,
                                ),
                              )
                            ],
                          )
                        : ListTile(
                            title: Text(_words[index]),
                          );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class TestGridView extends StatefulWidget {
  TestGridView({this.useStr = false, this.controller});

  TestGridView.staggered({this.useStr = true, this.controller});

  final bool useStr;

  final ScrollController? controller;

  @override
  State<TestGridView> createState() => _TestGridViewState();
}

class _TestGridViewState extends State<TestGridView> {
  final List<ItemData> _list = [];

  @override
  void initState() {
    super.initState();
    _retrieveIcons();
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      setState(() {
        _list.addAll([
          const ItemData(Colors.blue, Icons.ac_unit),
          const ItemData(Colors.red, Icons.airport_shuttle),
          const ItemData(Colors.yellow, Icons.all_inclusive),
          const ItemData(Colors.grey, Icons.beach_access),
          const ItemData(Colors.blueGrey, Icons.cake),
          const ItemData(Colors.teal, Icons.free_breakfast),
          const ItemData(Colors.deepPurple, Icons.ac_unit),
          const ItemData(Colors.blue, Icons.ac_unit),
          const ItemData(Colors.red, Icons.airport_shuttle),
          const ItemData(Colors.yellow, Icons.all_inclusive),
          const ItemData(Colors.grey, Icons.beach_access),
          const ItemData(Colors.blueGrey, Icons.cake),
          const ItemData(Colors.teal, Icons.free_breakfast),
          const ItemData(Colors.deepPurple, Icons.ac_unit),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.useStr)
    //   return Scrollbar(
    //     child: StaggeredGridView.countBuilder(
    //         controller: widget.controller,
    //         crossAxisCount: 3,
    //         itemCount: _list.length,
    //         padding: EdgeInsets.all(10),
    //         mainAxisSpacing: 10,
    //         crossAxisSpacing: 10,
    //         itemBuilder: (BuildContext context, int index) {
    //           if (index == _list.length - 1 && _list.length < 400) {
    //             _retrieveIcons();
    //           }
    //           return ItemGridView(_list[index], index);
    //         },
    //         staggeredTileBuilder: (int index) =>
    //             StaggeredTile.count(1, index % 3 == 0 ? 2 : 1)),
    //   );

    return GridView.builder(
        controller: widget.controller,
        itemCount: _list.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                style: const TextStyle(fontSize: 13),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double? collapsedHeight;
  final double? expandedHeight;
  final double? paddingTop;
  final String? coverImgUrl;
  final String? title;

  String statusBarMode = 'dark';

  final TabBar? bottom;

  SliverCustomHeaderDelegate(
      {this.collapsedHeight,
      this.expandedHeight,
      this.paddingTop,
      this.coverImgUrl,
      this.title,
      this.bottom});

  @override
  double get minExtent =>
      collapsedHeight! + paddingTop! + (bottom?.preferredSize.height ?? 0);

  @override
  double get maxExtent => math.max(
      paddingTop! + expandedHeight! + (bottom?.preferredSize.height ?? 0),
      minExtent);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color _makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha =
        (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color _makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha =
          (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  void _updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && statusBarMode == 'dark') {
      statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (shrinkOffset <= 50 && statusBarMode == 'light') {
      statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
//    double deltaExten = maxExtent - minExtent;
//
//    double pro = (shrinkOffset / deltaExten).clamp(0, 1);
////    debugPrint(
////        "maxExtent --> $maxExtent  minExtent--->$minExtent deltaExten--->$deltaExten shrinkOffset-->$shrinkOffset pro--->$pro");
//    var twen = RelativeRect.fromLTRB(
//        0, maxExtent - bottom.preferredSize.height * 2, 0, 0);
////    RectTween(
////        begin:
////        Rect.fromLTRB(0, maxExtent - bottom.preferredSize.height, 0, 0),
////        end: Rect.fromLTRB(0, minExtent, 0, 0))
////        .transform(deltaExten);
//
//    debugPrint("twen-->${twen.toString()}");

//    _updateStatusBarBrightness(shrinkOffset);
    Widget topChild = SizedBox(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 背景图
          Container(
              constraints: const BoxConstraints.expand(),
              child: Image.network(coverImgUrl!, fit: BoxFit.cover)),
          // 收起头部
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: _makeStickyHeaderBgColor(shrinkOffset), // 背景颜色
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
//                      const BackButtonIcon(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: _makeStickyHeaderTextColor(
                              shrinkOffset, true), // 返回图标颜色
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _makeStickyHeaderTextColor(
                              shrinkOffset, false), // 标题颜色
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: _makeStickyHeaderTextColor(
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

    return topChild;
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  StickyTabBarDelegate({this.child});

  final TabBar? child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    debugPrint('StickyTabBarDelegate--->build--->$shrinkOffset');
    return child!;
  }

  @override
  double get maxExtent => child!.preferredSize.height;

  @override
  double get minExtent => child!.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CustomScrollViewTestRoute extends StatefulWidget {
  @override
  State<CustomScrollViewTestRoute> createState() =>
      _CustomScrollViewTestRouteState();
}

///
/// 这个和Android那一套效果一样
///
class _CustomScrollViewTestRouteState extends State<CustomScrollViewTestRoute>
    with SingleTickerProviderStateMixin {
//  TabController tabController;

  @override
  void initState() {
    super.initState();
//    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    super.dispose();
//    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> tabview = [];

    tabview.add(CustomScrollView(
      key: const PageStorageKey<String>('tab one'),
      slivers: <Widget>[
        //AppBar，包含一个导航栏
//          SliverAppBar(
//            pinned: true,
//            expandedHeight: 200,
//            flexibleSpace: FlexibleSpaceBar(
//              title: const Text("Demo"),
//              collapseMode: CollapseMode.none,
//              background: Image.asset(
//                "imgs/like.jpeg",
//                fit: BoxFit.cover,
//              ),
//            ),
//          ),

//          SliverPersistentHeader(
//              pinned: true,
//              delegate: SliverCustomHeaderDelegate(
//                  collapsedHeight: kToolbarHeight,
//                  expandedHeight: 250,
//                  paddingTop: MediaQuery.of(context).padding.top,
//                  coverImgUrl:
//                      'https://s2.showstart.com/img/2019/20190228/fdaa366eb7174016af325021dd8642fe_600_800_131758.0x0.jpg',
//                  title: '我是谁')),

//          SliverPersistentHeader(
//              pinned: true,
////              floating: true,
//              delegate: StickyTabBarDelegate(
//                  child: Container(
//                alignment: Alignment.center,
//                constraints: BoxConstraints.expand(),
//                color: Colors.red,
//                child: Text(
//                  "I am stuck",
//                  style: textTheme.display3,
//                ),
//              ))),

//          SliverPersistentHeader(
//              pinned: true,
////              floating: true,
//              delegate: StickyTabBarDelegate(
//                  child: TabBar(
////                      controller: tabController,
//                      labelColor: Colors.black,
//                      tabs: <Widget>[
//                    Tab(
//                      text: "Home",
//                    ),
//                    Tab(
//                      text: "Profile",
//                    )
//                  ]))),

//          SliverFillRemaining(
//            child: TabBarView(controller: tabController, children: <Widget>[
//              Center(child: Text('Content of Home')),
//              Center(child: Text('Content of Profile')),
//            ]),
//          )

        Builder(builder: (context) {
          return SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context));
        }),

        SliverPersistentHeader(
            pinned: true,
            delegate: StickyBarDelegate(
                child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: const Text("我是Sticker---不管用"),
            ))),

        SliverToBoxAdapter(
          child: Container(
            constraints: const BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: const Text(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4)),
        ),

        SliverToBoxAdapter(
          child: Container(
            constraints: const BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: const Text(
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
            constraints: const BoxConstraints.expand(height: 70),
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.5),
            child: const Text(
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
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('list item $index'),
              );
            }, childCount: 25),
            itemExtent: 70)
      ],
    ));

    tabview.add(CustomScrollView(
      key: const PageStorageKey<String>('tab two'),
      slivers: <Widget>[
        Builder(builder: (context) {
          return SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context));
        }),

        SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate((context, index) {
              //创建列表项
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('list item $index'),
              );
            }, childCount: 25),
            itemExtent: 70)

//                Center(child: Text('Content of Home'))
      ],
    ));

    Widget child = DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverCustomHeaderDelegate(
                              collapsedHeight: kToolbarHeight,
                              expandedHeight: 250,
                              paddingTop: MediaQuery.of(context).padding.top,
                              coverImgUrl:
                                  'https://s2.showstart.com/img/2019/20190228/fdaa366eb7174016af325021dd8642fe_600_800_131758.0x0.jpg',
                              title: 'NestedScrollView',
//                                bottom: TabBar(
//                                  labelColor: Colors.black,
//                                  tabs: <Widget>[
//                                    Tab(
//                                      text: 'Home',
//                                    ),
//                                    Tab(
//                                      text: 'Profile',
//                                    )
//                                  ],
//                                )
                            )),
                      ),

//                        child: NewSliverAppBar(
//                          pinned: true,
//                          title: Text('我是谁'),
//                          expandedHeight: 200,
//                          flexibleSpace: FlexibleSpaceBar(
//                            title: const Text("Demo"),
//                            collapseMode: CollapseMode.pin,
//                            background: Image.asset(
//                              "imgs/like.jpeg",
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                          bottom: TabBar(
////                      controller: tabController,
//                              labelColor: Colors.black,
//                              tabs: <Widget>[
//                                Tab(
//                                  text: "Home",
//                                ),
//                                Tab(
//                                  text: "Profile",
//                                )
//                              ]),
//                          forceElevated: innerBoxIsScrolled,
//                        ),
//                      ),

//                  SliverOverlapAbsorber(
//                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                          context),
//                      child: SliverPersistentHeader(
//                          delegate: StickyTabBarDelegate(
//                        child: TabBar(labelColor: Colors.black, tabs: <Widget>[
//                          Tab(
//                            text: "Home",
//                          ),
//                          Tab(
//                            text: "Profile",
//                          )
//                        ]),
//                      ))),

//                  SliverOverlapAbsorber(
//                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                          context),
//                      child: CustomScrollView(
//                        slivers: <Widget>[
//                          SliverPersistentHeader(
//                              pinned: true,
//                              delegate: SliverCustomHeaderDelegate(
//                                collapsedHeight: kToolbarHeight,
//                                expandedHeight: 250,
//                                paddingTop: MediaQuery.of(context).padding.top,
//                                coverImgUrl:
//                                    'https://s2.showstart.com/img/2019/20190228/fdaa366eb7174016af325021dd8642fe_600_800_131758.0x0.jpg',
//                                title: '我是谁',
////                                bottom: TabBar(
////                                  labelColor: Colors.black,
////                                  tabs: <Widget>[
////                                    Tab(
////                                      text: 'Home',
////                                    ),
////                                    Tab(
////                                      text: 'Profile',
////                                    )
////                                  ],
////                                )
//                              )),
//                          SliverPersistentHeader(
//                              delegate: StickyTabBarDelegate(
//                            child:
//                                TabBar(labelColor: Colors.black, tabs: <Widget>[
//                              Tab(
//                                text: "Home",
//                              ),
//                              Tab(
//                                text: "Profile",
//                              )
//                            ]),
//                          ))
//                        ],
//                      )),
                    ],
            body: TabBarView(children: tabview)));

    return Material(
      child: child,
    );
  }
}
