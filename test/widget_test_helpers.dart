/// A collection of small, commonly used utility functions for widget testing.
///
/// The idea is to have a few very generic and flexible functions consistently
/// used throughout the widget test code base.
library widget_test_helpers;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Constructs a base app for testing.
///
/// It configures a [MaterialApp] with localizations and the locale `en_US`.
Widget createTestApp(Widget widgetUnderTest) {
  return MaterialApp(
    home: Builder(
      // This Builder exists only so that it is easy to get hold of a context
      // encapsulating the widget under test. It is useful e.g. to fetch
      // localizations (see [WidgetTesterExtensions.l10n]) or a default context
      // (see [WidgetTesterExtensions.context]).
      key: _widgetUnderTestParentBuilderKey,
      builder: (_) => widgetUnderTest,
    ),
    // localizationsDelegates: ...,
    // supportedLocales: ...,
    locale: const Locale('en', 'US'),
  );
}

extension WidgetTesterExtensions on WidgetTester {
  /// Fetches a [BuildContext] for use in tests.
  ///
  /// The context corresponds to the immediate parent of the widget under test.
  /// See [contextForWidget] for a way to get a context for an arbitrary
  /// widget.
  ///
  /// It assumes that a test app created with [createTestApp] lives somewhere in
  /// the widget tree, otherwise it will fail.
  BuildContext get context {
    return contextForWidget(_findWidgetUnderTestParent());
  }

  /// Fetches a [BuildContext] for use in tests.
  ///
  /// The context corresponds to the specified [widget]. See [context] for a way
  /// to get a context for a parent of the widget under test.
  BuildContext contextForWidget(Widget widget) {
    return element(find.byWidget(widget));
  }

  // /// Fetches localizations for use in tests.
  // ///
  // /// It assumes that a test app created with [createTestApp] lives somewhere in
  // /// the widget tree, otherwise it will fail.
  // AppLocalizations get l10n {
  //   return AppLocalizations.of(context)!;
  // }

  /// Looks up a single widget and returns it for further interactions.
  ///
  /// If [finder] is not specified, `find.byType` with [T] is used.
  /// It internally expects that the result really is a single widget.
  ///
  /// Example usage (performs a default lookup by type):
  /// ```dart
  /// final listTile = tester.findSingleWidget<ListTile>();
  /// ```
  /// or (explicit, custom finder logic):
  /// ```dart
  /// final listTile = tester.findSingleWidget<ListTile>(
  ///   find.byWidgetPredicate(
  ///     (w) => w is ListTile && w.selected,
  ///   ),
  /// );
  /// ```
  /// Then, further expectations can be executed:
  /// ```dart
  /// expect(listTile.dense, true);
  /// expect(listTile.isThreeLine, true);
  /// ```
  T findSingleWidget<T extends Widget>([Finder? finder]) {
    final usedFinder = _expect<T>(findsOneWidget, finder);

    return widget<T>(usedFinder);
  }

  Widget _findWidgetUnderTestParent() {
    return findSingleWidget(find.byKey(_widgetUnderTestParentBuilderKey));
  }
}

/// Expects a single widget.
///
/// If [finder] is not specified, `find.byType` with [T] is used.
void expectSingleWidget<T extends Widget>([Finder? finder]) {
  _expect<T>(findsOneWidget, finder);
}

/// Expects no widget.
///
/// If [finder] is not specified, `find.byType` with [T] is used.
void expectNoWidget<T extends Widget>([Finder? finder]) {
  _expect<T>(findsNothing, finder);
}

/// Calls [expect] with the specified [matcher].
///
/// If [finder] is not specified, `find.byType` with [T] is used.
/// Returns the finder that was eventually used.
Finder _expect<T extends Widget>(
  Matcher matcher, [
  Finder? finder,
]) {
  finder ??= find.byType(T);
  expect(finder, matcher);

  return finder;
}

final _widgetUnderTestParentBuilderKey = UniqueKey();
