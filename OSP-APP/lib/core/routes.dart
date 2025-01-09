import 'package:flutter/material.dart';
import 'package:fox_core/components/initializer/initializer_provider.dart';
import 'package:fox_core/components/onboarding/onboarding_provider.dart';
import 'package:fox_core/components/sign_up/models/email_verification_arguments.dart';
import 'package:fox_core/components/sign_up/sign_in_or_up_provider.dart';
import 'package:fox_core/components/user_profile/user_profile_provider.dart';
import 'package:fox_core/routes/notice/error_require_update.dart';
import 'package:fox_core/components/settings/settings_provider.dart';
import 'package:fox_core/components/general_views/dashboard/dashboard_provider.dart';

class Routes {
  static String initializer = '/';
  static String home = '/home';
  static String introduction = '/introduction';
  static String onboarding = '/onboarding';
  static String signUp = '/user/sign-up';
  static String userProfile = '/user/profile';
  static String errorRequireUpdate = '/error/requireUpdate';
  static String settings = '/settings';
  static String generalLeaderboard = '/generallLeaderboard';
  static String topLeaderboard = '/topLeaderboard';
  static String privateLeaderboard = '/privateLeaderboard';

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
    
    if (settings.name == Routes.userProfile) {
      return MaterialPageRoute(
          builder: (context) =>
              UserProfileProvider(arguments: settings.arguments as UserProfileArgs));
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
    
    return MaterialPageRoute(builder: (context) => const InitializerProvider());
  }
}