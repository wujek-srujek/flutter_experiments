import 'package:flutter/material.dart';

import 'main.hello.dart';

void main() {
  runApp(const MyApp());
}

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
    return const Scaffold(
      body: Center(
        child: Text(helloMain),
      ),
    );
  }
}
