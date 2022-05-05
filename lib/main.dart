import 'dart:developer';

import 'package:flutter/material.dart';

import 'provider.dart';

void main() {
  final count = _getDataFromSomewhereEgStorage();
  runApp(
    Provider(
      data: count,
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
          context.read<int>().value = 5;
        },
        child: FloatingActionButton(
          onPressed: () {
            context.read<int>().value++;
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
    final count = context.watch<int>().value;

    return Center(
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 128),
      ),
    );
  }
}
