import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorCubit(),
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
          context.read<ColorCubit>().refreshColor();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, Color>(
      builder: (context, color) {
        log('BlocBuilder.builder');

        return Descendant(
          color: color,
          tag: 'OUTER',
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
        );
      },
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

    if (child == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        log('==================================================');
      });
    }

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
