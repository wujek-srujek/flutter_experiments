import 'dart:developer';

import 'package:flutter/material.dart';

import 'inherited_count.dart';

void main() {
  final count = _getDataFromSomewhereEgStorage();
  runApp(
    InheritedCount(
      count: count,
      child: const MyApp(),
    ),
  );
}

int _getDataFromSomewhereEgStorage() => 0;

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Experiments',
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyWidget(),
      floatingActionButton: InkWell(
        onLongPress: () {
          InheritedCount.of(context, depend: false).value = 5;
        },
        child: FloatingActionButton(
          onPressed: () {
            InheritedCount.of(context, depend: false).value++;
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget();

  @override
  Widget build(BuildContext context) {
    log('Building MyWidget');
    final count = InheritedCount.of(context).value;

    return Center(
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 128),
      ),
    );
  }
}
