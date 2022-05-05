import 'package:flutter/material.dart';

class InheritedCount extends InheritedNotifier<ValueNotifier<int>> {
  InheritedCount({
    required int count,
    required super.child,
  }) : super(
          // We should dispose of it later but let's ignore
          // it for this presentation for simplicity.
          notifier: ValueNotifier(count),
        );

  static ValueNotifier<int> of(BuildContext context, {bool depend = true}) {
    final ValueNotifier<int> notifier;
    if (depend) {
      notifier = context
          .dependOnInheritedWidgetOfExactType<InheritedCount>()!
          .notifier!;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<InheritedCount>()!;
      notifier = (element.widget as InheritedCount).notifier!;
    }

    return notifier;
  }
}
