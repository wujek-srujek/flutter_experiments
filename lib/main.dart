import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.value = _controller.lowerBound;
        }
      });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: _controller.value);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          log('AnimatedBuilder.builder');
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            log('==================================================');
          });

          final value = _controller.value;

          return Transform.scale(
            // Values <0, 0.5) make the child shrink, <0.5, 1> make it grow.
            scale: value < 0.5 ? 1 - value : value,
            child: Transform.rotate(
              angle: value * 2 * math.pi,
              child: const Descendant(
                color: Colors.red,
                tag: 'RED',
                child: Descendant(
                  color: Colors.green,
                  tag: 'GREEN',
                  child: Descendant(
                    color: Colors.blue,
                    tag: 'BLUE',
                    child: Descendant(
                      color: Colors.yellow,
                      tag: 'YELLOW',
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Descendant extends StatelessWidget {
  final String tag;
  final Color color;
  final Widget? child;

  const Descendant({
    required this.tag,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    log('Building $tag');

    return Container(
      color: color,
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 96,
        ),
        child: child,
      ),
    );
  }
}
