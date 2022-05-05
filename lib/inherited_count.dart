import 'package:flutter/material.dart';

class InheritedCount extends StatefulWidget {
  final int count;
  final Widget child;

  const InheritedCount({
    required this.count,
    required this.child,
  });

  static int of(BuildContext context) {
    final inheritedWidget =
        context.dependOnInheritedWidgetOfExactType<_InheritedCount>()!;

    return inheritedWidget.count;
  }

  static CountOperations operations(BuildContext context) {
    return context.findAncestorStateOfType<_InheritedCountState>()!;
  }

  @override
  State<InheritedCount> createState() => _InheritedCountState();
}

abstract class CountOperations {
  void increment();
  void set(int count);
}

class _InheritedCountState extends State<InheritedCount>
    implements CountOperations {
  late int _count;

  @override
  void initState() {
    super.initState();

    _count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCount(
      count: _count,
      child: widget.child,
    );
  }

  @override
  void increment() {
    setState(() {
      ++_count;
    });
  }

  @override
  void set(int count) {
    setState(() {
      _count = count;
    });
  }
}

class _InheritedCount extends InheritedWidget {
  final int count;

  const _InheritedCount({
    required this.count,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedCount oldWidget) {
    return count != oldWidget.count;
  }
}
