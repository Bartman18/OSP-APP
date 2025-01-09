import 'package:flutter/material.dart';
import 'package:fox_core/widgets/bottom_navigation/bottom_bar.dart';
import 'package:fox_core/widgets/skeleton.dart';

class DashboardView extends StatefulWidget {
  final Widget child;
  final BottomBarTab highlightedTab;

  const DashboardView({
    super.key,
    required this.child,
    required this.highlightedTab,
  });

  @override
  State<DashboardView> createState() {
    return _DashboardViewState();
  }
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Skeleton(
      disableSafeAreaTop: true,
      removeAppBar: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomBar(
        highlightedTab: widget.highlightedTab,
        disableButtonClicks: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      child: Stack(
        children: [
          widget.child,
        ],
      ),
    );
  }
}
