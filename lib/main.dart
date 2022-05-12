import 'package:flutter/material.dart';

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

class MyPage extends StatefulWidget {
  const MyPage();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late final List<DropdownMenuItem<String>> _items;
  late String _currentImageAsset;

  @override
  void initState() {
    super.initState();

    _items = [
      'assets/images/red.png',
      'assets/images/green.png',
      'assets/images/blue.png',
    ].map((imageAsset) {
      return DropdownMenuItem(
        value: imageAsset,
        child: _RectangularAssetImage(
          size: 20,
          imageAsset: imageAsset,
        ),
      );
    }).toList(growable: false);

    _currentImageAsset = _items.first.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: DropdownButton<String>(
              items: _items,
              onChanged: (imageAsset) {
                setState(() {
                  _currentImageAsset = imageAsset!;
                });
              },
              value: _currentImageAsset,
            ),
          ),
          _RectangularAssetImage(
            size: 200,
            imageAsset: _currentImageAsset,
          ),
        ],
      ),
    );
  }
}

class _RectangularAssetImage extends StatelessWidget {
  final double size;
  final String imageAsset;

  const _RectangularAssetImage({
    required this.size,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: Image.asset(
          imageAsset,
        ),
      ),
    );
  }
}
