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

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  var _isBig = true;

  @override
  void initState() {
    super.initState();

    final min = 0.5;
    final max = 1.0;
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      lowerBound: min,
      upperBound: max,
      value: _isBig ? max : min,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _controller.value,
              child: MyWidget(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await (_isBig ? _controller.reverse() : _controller.forward());

          setState(() {
            _isBig = !_isBig;
          });
        },
        child: Icon(_isBig ? Icons.zoom_in_map : Icons.zoom_out_map),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final Color color;
        if (state is ProductsInitial) {
          color = Colors.white;
        } else if (state is ProductsLoading) {
          color = Colors.yellow;
        } else {
          color = Colors.red;
        }

        return Container(
          color: color,
        );
      },
    );
  }
}
