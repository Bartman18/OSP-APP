import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

class LoaderText extends StatelessWidget {
  final String text;

  const LoaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Text(text, style: TextStyle(color: CoreColors.secondary.withOpacity(.8))),
  );

}