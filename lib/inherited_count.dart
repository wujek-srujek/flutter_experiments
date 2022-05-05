import 'package:flutter/material.dart';

class InheritedCount extends InheritedWidget {
  final int count;

  const InheritedCount({
    required this.count,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static int of(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<InheritedCount>()!;
    final inheritedWidget = inheritedElement.widget as InheritedCount;

    return inheritedWidget.count;
  }
}
