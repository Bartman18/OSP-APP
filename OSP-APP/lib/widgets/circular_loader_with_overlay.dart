import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:osp/widgets/circular_loader.dart';

class CircularLoaderWithOverlay extends StatelessWidget {
  final Widget? child;
  final double strength;

  const CircularLoaderWithOverlay({super.key, this.child, this.strength = 3});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: strength, sigmaY: strength),
      child: Center(child: child ?? const CircularLoader()),
    );
  }

}