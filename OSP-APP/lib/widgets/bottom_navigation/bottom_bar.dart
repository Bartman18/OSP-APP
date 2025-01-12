import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_core/components/add_event/add_event.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/routes.dart';

enum BottomBarTab { none, home, calendar, myEvents, onboarding }

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
      BottomBarTab.myEvents,
      'assets/icons/MyEvents.png',
      Routes.myEvents,
      'Moje',
    ),
    BottomBarButtonInfo(
      BottomBarTab.home,
      'assets/icons/MainPage.png',
      Routes.home,
      'Główna',
    ),BottomBarButtonInfo(
      BottomBarTab.onboarding,
      'assets/icons/MainPage.png',
      Routes.onboarding,
      'OnBoarding',
    ),
    BottomBarButtonInfo(
      BottomBarTab.calendar,
      'assets/icons/Calendar.png',
      Routes.calendar,
      'Kalendarz',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          CoreColors.profileTwo,
          CoreColors.profile,],
        stops: [0.0, 1.0],
      )
    ),
    child: BottomAppBar(
      color: CoreColors.black.withOpacity(0.8),
      height: 100.0,
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
                    style: const ButtonStyle(
                      backgroundColor: WidgetStateColor.transparent,
                      shadowColor: WidgetStateColor.transparent,
                    ),
                child: Column(
                  children: [
                Image.asset(
                  width: 45,
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
