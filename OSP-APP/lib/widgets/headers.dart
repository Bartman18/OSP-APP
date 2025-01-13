import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

class AppHeaderHint extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AppHeaderHint({required this.text, this.color, this.style, this.textAlign = TextAlign.left, super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle finalStyle = Theme.of(context).textTheme.displaySmall!.copyWith(
      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      color: color ?? CoreColors.black,
      fontVariations: CoreTheme.thinTextStyle.fontVariations
    );

    if (style is TextStyle) {
      finalStyle.merge(style);
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
    );
  }

}

class AppHeader extends StatelessWidget {
  final String text;

  const AppHeader({required this.text, super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
      fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
      fontVariations: CoreTheme.boldTextStyle.fontVariations,
      color: CoreColors.black,
    ),
  );

}