import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorCubit extends Cubit<Color> {
  final _random = Random();

  ColorCubit() : super(Colors.yellow);

  void refreshColor() {
    emit(
      Color.fromARGB(
        255, // alpha
        _random.nextInt(256), // R
        _random.nextInt(256), // G
        _random.nextInt(256), // B
      ),
    );
  }
}
