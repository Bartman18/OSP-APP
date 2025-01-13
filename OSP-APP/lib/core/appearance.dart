import 'package:flutter/material.dart';
import 'package:osp/widgets/circular_loader_with_overlay.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CoreColors {
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color primary = const Color(0xFFAC1613);
  static Color secondary = const Color(0xFF00F51C);
  static Color beige = const Color(0xFFF9E5D1);
  static Color gray = const Color(0xFFC3C3C3);
  static Color loaderColor = const Color(0xFF000000);
  static Color profile = const Color(0xFFAC1613);
  static Color profileTwo = const Color(0xFF1B1819);
  //static Color transparentWhite = const Color(0x80FFFFFF);
}

class CoreTheme {
  static const TextStyle thinTextStyle = TextStyle(fontVariations: [FontVariation.weight(300)]);
  static const TextStyle baseTextStyle = TextStyle(fontVariations: [FontVariation.weight(400)]);
  static const TextStyle mediumTextStyle = TextStyle(fontVariations: [FontVariation.weight(500)]);
  static const TextStyle semiBoldTextStyle = TextStyle(fontVariations: [FontVariation.weight(600)]);
  static const TextStyle boldTextStyle = TextStyle(fontVariations: [FontVariation.weight(700)]);
  static const TextStyle semiBlackTextStyle = TextStyle(fontVariations: [FontVariation.weight(800)]);
  static const TextStyle blackTextStyle = TextStyle(fontVariations: [FontVariation.weight(900)]);

  static ThemeData get() => ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSeed(seedColor: CoreColors.primary),
      primaryColor: CoreColors.primary,
      textTheme: TextTheme(
        displayLarge: baseTextStyle.copyWith(fontSize: 40),
        displayMedium: baseTextStyle.copyWith(fontSize: 24),
        displaySmall: baseTextStyle.copyWith(fontSize: 13),
        labelMedium: baseTextStyle.copyWith(fontSize: 20),
        headlineMedium: baseTextStyle.copyWith(fontSize: 18),
        bodyLarge: TextStyle(color: CoreColors.secondary),
      ),

      inputDecorationTheme: InputDecorationTheme(
        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CoreColors.primary)),
        //enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CoreColors.gray)),
        labelStyle: CoreTheme.mediumTextStyle.copyWith(fontSize: 13, color: CoreColors.secondary.withOpacity(.6)),
        hintStyle: CoreTheme.mediumTextStyle.copyWith(fontSize: 15, color: CoreColors.secondary.withOpacity(.2)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconColor: CoreColors.secondary.withOpacity(.2),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: CoreColors.primary,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: CoreColors.white,
        yearStyle: TextStyle(color: CoreColors.secondary),
        cancelButtonStyle: ButtonStyle(textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(color: CoreColors.primary))),
        confirmButtonStyle: ButtonStyle(textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(color: CoreColors.primary))),
        dayForegroundColor: WidgetStatePropertyAll<Color>(CoreColors.secondary),
        dayOverlayColor: WidgetStatePropertyAll<Color>(CoreColors.primary),
        todayForegroundColor: WidgetStatePropertyAll<Color>(CoreColors.secondary),
        surfaceTintColor: CoreColors.white,
        shadowColor: CoreColors.primary,
        headerForegroundColor: CoreColors.secondary,
        dividerColor: CoreColors.primary,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: CoreColors.black,
        deleteIconColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50)), side: BorderSide(color: CoreColors.black)),
      ),

      switchTheme: SwitchThemeData(
        trackColor: WidgetStatePropertyAll<Color>(CoreColors.primary),
      )
  );

  static ThemeData checkboxThemeData() => ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: WidgetStateBorderSide.resolveWith((states) => BorderSide(color: CoreColors.white)),
      visualDensity: VisualDensity.compact,
    ),
    listTileTheme: const ListTileThemeData(horizontalTitleGap: 10),
    textTheme: CoreTheme.get().textTheme,
  );
}

class AppLook {
  static Widget globalOverlay({required Widget child}) => GlobalLoaderOverlay(
      overlayColor: Colors.black.withOpacity(.2),
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) => const CircularLoaderWithOverlay(),
      child: child
  );

  static InputBorder disabledBorder() => const UnderlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none));
}
