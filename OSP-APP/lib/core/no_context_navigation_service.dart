import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NoContextNavigationService {
  NoContextNavigationService._();

  static final NoContextNavigationService _instance = NoContextNavigationService._();

  factory NoContextNavigationService() {
    return _instance;
  }

  dynamic routeTo(String route, {dynamic arguments}) async {
    return await navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }
}
