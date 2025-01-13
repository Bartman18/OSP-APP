import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(color: CoreColors.primary);

}