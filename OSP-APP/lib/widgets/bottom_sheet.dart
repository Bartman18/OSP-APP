import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final EdgeInsets padding;
  final List<Widget> children;

  const AppBottomSheet({
    required this.children,
    this.padding = const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Wrap(children: children),
    );
  }

}