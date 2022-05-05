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
  var _isBig = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          duration: Duration(milliseconds: 400),
          scale: _isBig ? 1 : 0.5,
          child: MyWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isBig = !_isBig;
          });
        },
        child: Icon(_isBig ? Icons.zoom_in_map : Icons.zoom_out_map),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();

    context.read<ProductsCubit>().initialize();
  }

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
