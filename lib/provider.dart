import 'package:flutter/material.dart';

class Provider<T> extends InheritedNotifier<ValueNotifier<T>> {
  Provider({
    required T data,
    required super.child,
  }) : super(
          // We should dispose of it later but let's ignore
          // it for this presentation for simplicity.
          notifier: ValueNotifier(data),
        );

  static ValueNotifier<T> _of<T>(BuildContext context, {bool depend = true}) {
    final ValueNotifier<T> notifier;
    if (depend) {
      notifier =
          context.dependOnInheritedWidgetOfExactType<Provider<T>>()!.notifier!;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<Provider<T>>()!;
      notifier = (element.widget as Provider<T>).notifier!;
    }

    return notifier;
  }
}

extension ProviderBuildContextX on BuildContext {
  ValueNotifier<T> read<T>() => Provider._of<T>(this, depend: false);
  ValueNotifier<T> watch<T>() => Provider._of<T>(this);
}
