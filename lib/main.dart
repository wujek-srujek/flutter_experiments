import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'products_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(),
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
      body: Center(
        child: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ProductsCubit>().initialize();

    return Container(
      color: Colors.red,
    );
  }
}
