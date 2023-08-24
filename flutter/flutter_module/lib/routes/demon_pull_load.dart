import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // 当前页数
  int _page = 1;

  // 页面数据
  final _list = <String>[];

  // 是否还有
  bool _hasMore = true;

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getData();
    // 监听滚动事件
    _scrollController.addListener(() {
      // 获取滚动条下拉的距离
      // print(_scrollController.position.pixels);
      // 获取整个页面的高度
      // print(_scrollController.position.maxScrollExtent);
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 400) {
        _getData();
      }
    });
  }

  // 获取数据列表
  void _getData() async {
    if (_hasMore) {
      _list.addAll(
          generateWordPairs().take(30).map((e) => e.asPascalCase).toList());
      setState(() {
        // 页数累加
        _page++;
      });

      if (_list.length < 20) {
        setState(() {
          // 关闭加载
          _hasMore = false;
        });
      }
    }
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    // 持续两秒
    await Future.delayed(const Duration(milliseconds: 10000), () {
      _getData();
    });
  }

  // 加载动画
  Widget _getMoreWidget() {
    // 如果还有数据
    if (_hasMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '加载中',
                style: TextStyle(fontSize: 16.0),
              ),
              // 加载图标
              CircularProgressIndicator(
                strokeWidth: 1.0,
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Text("...我是有底线的..."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _list.isEmpty
        ? _getMoreWidget()
        : RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              // 上拉加载控制器
              controller: _scrollController,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                Widget tip = const Text("");
                // 当渲染到最后一条数据时，加载动画提示
                if (index == _list.length - 1) {
                  tip = _getMoreWidget();
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                      _list[index],
                      maxLines: 1,
                    )),
                    const Divider(),
                    // 加载提示
                    tip
                  ],
                );
              },
            ));
  }
}
