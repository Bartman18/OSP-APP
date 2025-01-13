import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

/// Base view template.
///
/// It covers phone's safe area, hiding keyboard and contains small loader to show
/// in case any async data should be managed >>without<< leaving current page.
class Skeleton extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool removeAppBar;
  final bool disableSafeAreaTop;
  final bool safeAreaBottom;
  final bool automaticallyImplyLeading;
  final EdgeInsets padding;

  const Skeleton({
    required this.child,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.removeAppBar = false,
    this.disableSafeAreaTop = false,
    this.safeAreaBottom = false,
    this.automaticallyImplyLeading = true,
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor,
    super.key
  });

  @override
  SkeletonState createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  Widget? _getAppBarTitle() {
    if (null != widget.titleWidget) {
      return widget.titleWidget;
    }

    if (null != widget.title && '' != widget.title) {
      return Text(widget.title!);
    }

    return null;
  }

  AppBar _getAppBar() => AppBar(
    backgroundColor: CoreColors.white,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: widget.automaticallyImplyLeading,

    title: _getAppBarTitle(),

    actions: widget.actions,
    leading: widget.leading,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Used to hide keyboard while pressed outside any text fields.
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

      child: Scaffold(
        appBar: widget.removeAppBar ? null : _getAppBar(),
        backgroundColor: widget.backgroundColor ?? CoreColors.white,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,

        body: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width
          ),
          child: SafeArea(
              top: !widget.disableSafeAreaTop,
              bottom: widget.safeAreaBottom,
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              )
          ),
        ),

        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }

}