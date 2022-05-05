import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  final count = _getDataFromSomewhereEgStorage();
  runApp(
    MyApp(
      count: count,
    ),
  );
}

int _getDataFromSomewhereEgStorage() => 0;

class MyApp extends StatelessWidget {
  final int count;

  const MyApp({required this.count});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      home: MyPage(
        count: count,
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final int count;

  const MyPage({required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyWidget(
        count: count,
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final int count;

  const MyWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    log('Building MyWidget');

    return Center(
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 128),
      ),
    );
  }
}
