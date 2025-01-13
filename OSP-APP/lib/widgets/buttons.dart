import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:osp/core/appearance.dart';

class AppElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onClick;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  const AppElevatedButton({
    super.key,
    required this.buttonText,
    required this.onClick,
    this.buttonStyle,
    this.textStyle,
  });

  static ButtonStyle copyWithDefaultStyle({Color? backgroundColor, EdgeInsets? padding}) {
    return const ButtonStyle().copyWith(
      backgroundColor: WidgetStatePropertyAll(backgroundColor ?? CoreColors.primary),
      padding: WidgetStatePropertyAll(padding ?? const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0))
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle ?? AppElevatedButton.copyWithDefaultStyle(),
      onPressed: onClick,
      child: Text(
        buttonText.tr(),
        style: CoreTheme.boldTextStyle.copyWith(
          fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          color: CoreColors.white,
        ),
      ),
    );
  }
}

class AppBottomSheetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const AppBottomSheetButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll<Color>(
                CoreColors.primary.withOpacity(.2))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: CoreColors.black,
                size: 32,
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(label,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontVariations: CoreTheme.mediumTextStyle.fontVariations,
                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize!,
                        color: CoreColors.black,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ));
  }
}

class AppRoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;

  const AppRoundedIconButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          highlightColor: CoreColors.primary.withAlpha(80),
          hoverColor: CoreColors.primary.withAlpha(80),
          focusColor: CoreColors.primary.withAlpha(80),
          splashColor: CoreColors.primary.withAlpha(80),
          child: SizedBox(
            width: 37,
            height: 37,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                theme: SvgTheme(currentColor: CoreColors.black),
                iconPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDiscoverButton extends StatelessWidget {
  final String bottomText;
  final VoidCallback onClick;
  final String iconAsset;

  const AppDiscoverButton({
    super.key,
    required this.bottomText,
    required this.onClick,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 70.0,
      child: TextButton(
        onPressed: onClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(CoreColors.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'App',
                    style: TextStyle(
                      color: CoreColors.white.withAlpha(120),
                      fontSize: 17.0,
                      fontVariations: CoreTheme.boldTextStyle.fontVariations,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      bottomText,
                      style: TextStyle(
                        color: CoreColors.white,
                        fontSize: 17.0,
                        fontVariations: CoreTheme.boldTextStyle.fontVariations,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            SvgPicture.asset(iconAsset)
          ],
        ),
      ),
    );
  }
}

class AppSettingsButton extends StatelessWidget {
  final String headerText;
  final String bottomText;
  final VoidCallback onClick;

  const AppSettingsButton({
    super.key,
    required this.headerText,
    required this.bottomText,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 75.0,
      child: TextButton(
        onPressed: onClick,
        style: ButtonStyle(
          backgroundColor:
          WidgetStatePropertyAll<Color>(CoreColors.secondary.withAlpha(204)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 300),
                  Text(
                    headerText,
                    style: TextStyle(
                      color: CoreColors.white,
                      fontSize: 16.0,
                      fontVariations: CoreTheme.boldTextStyle.fontVariations,
                    ),
                  ),
                  Text(
                    bottomText,
                    style: TextStyle(
                      color: CoreColors.white.withAlpha(150),
                      fontSize: 12.0,
                      fontVariations: CoreTheme.baseTextStyle.fontVariations,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSupportButton extends StatelessWidget {
  final String headerText;
  final String bottomText;
  final VoidCallback onClick;
  final Widget child;
  final Widget? suffix;

  const AppSupportButton({
    super.key,
    required this.headerText,
    required this.bottomText,
    required this.onClick,
    required this.child,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 75.0,
      child: TextButton(
        onPressed: onClick,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CoreColors.white.withOpacity(0.36),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: child,
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  const SizedBox(width: 260),
                  Text(
                    headerText,
                    style: CoreTheme.semiBoldTextStyle.copyWith(color: CoreColors.white, fontSize: 15),
                  ),
                  Text(
                    bottomText,
                    style: CoreTheme.thinTextStyle.copyWith(color: CoreColors.white.withOpacity(.6), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (suffix is Widget) const SizedBox(width: 20),
            suffix ?? const Wrap(),
          ],
        ),
      ),
    );
  }
}
