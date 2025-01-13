import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

/// Widget to show in case we want to display centered progress indicator while loading's in progress.
class FullscreenLoader extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color? indicatorColor;

  const FullscreenLoader({this.child, this.color, this.indicatorColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: null == color ? CoreColors.loaderColor : color!,
          height: double.infinity,
          width: double.infinity,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: indicatorColor),
              if (child != null) const SizedBox(height: 10),
              if (child != null) child!,
            ],
          ),
        )
      ],
    );

  }
}
