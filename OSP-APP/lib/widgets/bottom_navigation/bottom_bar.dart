import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/routes.dart';

enum BottomBarTab { none, home, generalLeague, privateLeague, topLeague }

class BottomBar extends StatefulWidget {
  final bool disableButtonClicks;
  final BottomBarTab highlightedTab;

  const BottomBar({
    super.key,
    required this.disableButtonClicks,
    required this.highlightedTab,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final List<BottomBarButtonInfo> _bottomBarItems = [
    BottomBarButtonInfo(
      BottomBarTab.home,
      'assets/icons/six.svg',
      Routes.home,
      'widgets.bottom_bar.play'.tr(),
    ),
    BottomBarButtonInfo(
      BottomBarTab.generalLeague,
      'assets/icons/world.svg',
      Routes.generalLeaderboard,
      'widgets.bottom_bar.general'.tr(),
    ),
    BottomBarButtonInfo(
      BottomBarTab.privateLeague,
      'assets/icons/lock.svg',
      Routes.privateLeaderboard,
      'widgets.bottom_bar.private'.tr(),
    ),
    BottomBarButtonInfo(
      BottomBarTab.topLeague,
      'assets/icons/trophy_star.svg',
      Routes.topLeaderboard,
      'widgets.bottom_bar.top'.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: CoreColors.black.withOpacity(0.8),
      height: 66.0,
      shape: const CircularNotchedRectangle(),
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: _bottomBarItems.map((item) {
          final isSelected = item.tab == widget.highlightedTab;
          return ElevatedButton(
                onPressed: widget.disableButtonClicks
                    ? null
                    : () => Navigator.pushReplacementNamed(context, item.route),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.transparent,
                      shadowColor: WidgetStateColor.transparent,
                    ),
                child: Column(
                  children: [
                SvgPicture.asset(
                  item.iconPath,
                  color: isSelected ? CoreColors.white : CoreColors.white.withOpacity(0.66), 
                ),
                Text(
                item.caption,
                textAlign: TextAlign.center,
                style: CoreTheme.thinTextStyle.copyWith(
                  color: isSelected ? CoreColors.white : CoreColors.white.withOpacity(0.66),
                ),
              ),
                  ],
              ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomBarButtonInfo {
  BottomBarTab tab;
  String iconPath;
  String route;
  String caption;

  BottomBarButtonInfo(this.tab, this.iconPath, this.route, this.caption);
}
