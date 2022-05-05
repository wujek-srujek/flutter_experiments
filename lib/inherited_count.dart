import 'package:flutter/material.dart';

class InheritedCount extends StatefulWidget {
  final int count;
  final Widget child;

  const InheritedCount({
    required this.count,
    required this.child,
  });

  static int of(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<_InheritedCount>()!;
    final inheritedWidget = inheritedElement.widget as _InheritedCount;

    return inheritedWidget.count;
  }

  static void increment(BuildContext context) {
    context.findAncestorStateOfType<_InheritedCountState>()!._increment();
  }

  @override
  State<InheritedCount> createState() => _InheritedCountState();
}

class _InheritedCountState extends State<InheritedCount> {
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

  void _increment() {
    setState(() {
      ++_count;
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
    return false;
  }
}
