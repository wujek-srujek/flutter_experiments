import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'color_notifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorNotifier(),
      child: MaterialApp(
        title: 'Flutter Experiments',
        home: MyPage(),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ColorNotifier>().changeColor();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext contextRed) {
    return Descendant(
      color: Colors.red,
      tag: 'RED',
      child: Builder(builder: (contextGreen) {
        return Descendant(
          color: Colors.green,
          tag: 'GREEN',
          child: Builder(builder: (contextBlue) {
            return Descendant(
              color: Colors.blue,
              tag: 'BLUE',
              child: Consumer<ColorNotifier>(
                builder: (contextInner, colorNotifier, child) {
                  return Descendant(
                    color: colorNotifier.value,
                    tag: 'INNER',
                  );
                },
              ),
            );
          }),
        );
      }),
    );
  }
}

class Descendant extends StatelessWidget {
  final String tag;
  final Color color;
  final Widget? child;

  Descendant({
    required this.tag,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    log('Building $tag');

    if (child == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        log('==================================================');
      });
    }

    return Container(
      color: color,
      constraints: BoxConstraints.expand(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 96,
        ),
        child: child,
      ),
    );
  }
}
