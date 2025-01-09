# Dark Fox - App Core

---------------------

## To do at the beginning
1. Localize `pl.darkfox.fox_core` for Android and `pl.darkfox.foxCore` for iOS.
2. Replace these with valid names.

## How to? Translate
Read [Easy Localization](https://pub.dev/packages/easy_localization) package instruction. But in shorthand: just be sure to put proper data in `assets/translations/*.json` files.

To add/change new translation you have to:

1. Edit `supportedLocales` property set in `lib/main.dart` file.
2. Modify `possibleLocales` List<String> from `lib/core/helpers.dart` file.

## Handy stuff
1. Recipes in BLoC's [official documents](https://bloclibrary.dev/#/recipesflutternavigation).
2. **Use** plugins for your IDE: [AndroidStudio](https://plugins.jetbrains.com/docs/intellij/welcome.html?from=jetbrains.org) or [VSC](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc).
3. Project contains [basic_utils](https://pub.dev/packages/basic_utils) package, it's useful especially in String-related operations.

## Core project structure
- `assets` - just assets used in project
    - `assets/translations` - directory for JSON files with translations
    - `assets/licenses` - some assets (like fonts) might require to attach their licence, that's the place where you can store the file
- `google_fonts` - directory for fonts to use - we don't want them to be downloaded every time somebody clean app's cache
- `lib` - main directory for all the Dart code
- `lib/components` - place where BLoC or Cubit classes should be stored, we want to use this pattern:
    - `lib/components/{NAME}/bloc` - place where BLoC classes for component {NAME} should be placed, in case you use Cubit, just rename `bloc` to `qubit`
    - `lib/components/{NAME}/view` - place with view or views used by component
    - `lib/components/{NAME}/{NAME.dart}` - a StatelessWidget instance that contains `BlocProvider`
- `lib/core/` - mostly helpers like class to determinate app's look or routes, in shorthand: classes that might affect the whole project
- `lib/widgets/` - place for single widgets that might be useful in whole project