import 'package:flutter/material.dart';
import 'package:fox_core/core/appearance.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(color: CoreColors.primary);

}