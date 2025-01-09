import 'package:flutter/cupertino.dart';
import 'package:fox_core/core/appearance.dart';

class AppSwitch extends StatefulWidget {
  final bool value;
  final double scale;
  final Function(bool) onChanged;

  const AppSwitch({required this.value, required this.onChanged, this.scale = 1, super.key});

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}
class _AppSwitchState extends State<AppSwitch> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(),
      child: Transform.scale(
        scale: widget.scale,
        child: CupertinoSwitch(
          value: widget.value,
          onChanged: widget.onChanged,
          activeColor: CoreColors.secondary,
        ),
      ),
    );
  }

}