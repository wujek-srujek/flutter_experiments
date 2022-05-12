## fl_ass - Nice asset accessors for Flutter

Generates accessor code for assets so that they don't have to be hardcoded.

For example, for the folder structure:
```
assets/
  images/
    red.png
    green.png
    blue.png
```

the following code is generated:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

final Assets assets = Assets._();

class Assets {
  Assets._();

  final AssetsImages images = AssetsImages._();
}

class AssetsImages {
  AssetsImages._();

  String get green_png => 'assets/images/green.png';
  String get red_png => 'assets/images/red.png';
  String get blue_png => 'assets/images/blue.png';
}

```

Now assets can be accessed like:
```dart
final red = assets.images.red_png;
```

This works nice with code completion, e.g when
```dart
assets.images.
```
is typed all images below it are listed. If assets are removed and the code
generated again, any usages of removed assets will prevent compilation.

Folder structures of arbitrary depth are supported.

### Configuration

By default the builder looks for assets in the `assets/` folder, but this is
configurable and more files or folders can be included. Note that you may have
to configure custom sources, see https://github.com/dart-lang/build/blob/master/docs/faq.md#how-can-i-include-additional-sources-in-my-build.

Example:

```yaml
    # ...
    builders:
      fl_ass:
        options:
          asset_dirs:
            - custom_assets_folder
    # ...
```

Asset folders may contain unwanted files (e.g. `.DS_Store` or `.tmp` ) or files
that don't need to be accessed directly in the app (like image variants or
fonts) and it is possible to filter them out:

```yaml
    # ...
      fl_ass:
        options:
          exclusion_filters:
            - '**/.DS_Store'
            - assets/fonts/**
            - assets/images/2.0x/**
            - assets/images/3.0x/**
    # ...
```

- All files are included by default unless they match one of the filters.
- Filters are specified using [globs](https://pub.dev/packages/glob).
