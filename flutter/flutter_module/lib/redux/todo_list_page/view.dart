import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import '../../main.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(PageState state, Dispatch dispatch, ViewService viewService) {
  final ListAdapter adapter = viewService.buildAdapter();
  return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: state.themeColor,
          title: const Text('ToDoList'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              viewService.buildComponent('report'),
              Expanded(
                  child: ListView.builder(
                      itemBuilder: adapter.itemBuilder,
                      itemCount: adapter.itemCount))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => dispatch(PageActionCreator.onAddAction()),
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
      onWillPop: () async {
        runApp(MyApp());
        return false;
      });
}
