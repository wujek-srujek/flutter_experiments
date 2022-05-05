import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {}

class ProductsCubit extends Cubit<ProductsState> {
  final _random = Random();

  var _count = 0;

  ProductsCubit() : super(ProductsInitial()) {
    initialize();
  }

  Future<void> initialize() {
    final count = ++_count;
    dev.log('Sending HTTP request #$count');

    emit(ProductsLoading());

    return Future.delayed(
      // Simulate network latency and upredictability.
      Duration(milliseconds: _random.nextInt(100) + 100),
      () {
        dev.log('Got HTTP response #$count');
        emit(ProductsSuccess());
      },
    );
  }
}
