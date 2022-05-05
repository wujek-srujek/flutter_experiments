import 'dart:math';

import 'package:flutter/material.dart';

class ColorNotifier extends ValueNotifier<Color> {
  final _random = Random();

  ColorNotifier() : super(Colors.yellow);

  void changeColor() {
    value = Color.fromARGB(
      255, // alpha
      _random.nextInt(256), // R
      _random.nextInt(256), // G
      _random.nextInt(256), // B
    );
  }
}
