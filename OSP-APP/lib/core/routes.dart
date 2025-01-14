import 'package:flutter/material.dart';
import 'package:osp/components/add_event/add_event_provider.dart';
import 'package:osp/components/general_views/calendar/calendar_provider.dart';
import 'package:osp/components/initializer/initializer_provider.dart';
import 'package:osp/components/onboarding/onboarding_provider.dart';
import 'package:osp/components/sign_up/models/email_verification_arguments.dart';
import 'package:osp/components/sign_up/sign_in_or_up_provider.dart';
import 'package:osp/routes/notice/error_require_update.dart';
import 'package:osp/components/settings/settings_provider.dart';
import 'package:osp/components/general_views/dashboard/dashboard_provider.dart';
import 'package:osp/components/general_views/home/my_events_provider.dart';

class Routes {
  static String initializer = '/';
  static String home = '/home';
  static String introduction = '/introduction';
  static String onboarding = '/onboarding';
  static String signUp = '/user/sign-up';
  static String userProfile = '/user/profile';
  static String errorRequireUpdate = '/error/requireUpdate';
  static String settings = '/settings';
  static String calendar = '/calendar';
  static String myEvents = '/myEvents';
  static String addEvents = '/addEvents';


  static Route<dynamic> getRoute(RouteSettings settings) {
    if (settings.name == Routes.initializer) {
      return MaterialPageRoute(builder: (context) => const InitializerProvider());
    }
    if (settings.name == Routes.onboarding) {
      return MaterialPageRoute(builder: (context) => const OnboardingProvider());
    }
    if (settings.name == Routes.signUp) {
      return MaterialPageRoute(builder: (context) => SignInOrUpProvider(arguments: settings.arguments as SignInOrUpArgs));
    }

    if(settings.name == Routes.errorRequireUpdate) {
      return MaterialPageRoute(builder: (context) => const ErrorRequireUpdate());
    }
    if(settings.name == Routes.settings) {
      return MaterialPageRoute(builder: (context) => const SettingsProvider());
    }
    if(settings.name == Routes.home) {
      return MaterialPageRoute(builder: (context) => const DashboardProvider());
    }
    if(settings.name == Routes.calendar) {
      return MaterialPageRoute(builder: (context) => const CalendarProvider());
    }
    if(settings.name == Routes.myEvents) {
      return MaterialPageRoute(builder: (context) => const MyEventsProvider());
    }
    if(settings.name == Routes.addEvents) {
      return MaterialPageRoute(builder: (context) => const AddEventProvider());
    }
    
    return MaterialPageRoute(builder: (context) => const InitializerProvider());
  }
}