import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/no_context_navigation_service.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';

class DarkFoxCoreApp extends StatelessWidget {
  const DarkFoxCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = Helpers.getValidLocale(
        GetStorage().read<String?>(SettingsDictionary.appLanguage) ??
            DefaultSettingsDictionary.appLanguage);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AppLook.globalOverlay(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CoreTheme.get(),
        darkTheme: CoreTheme.get(),
        locale: lang.toLocale(),
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        navigatorKey: navigatorKey,
        initialRoute: Routes.initializer,
        onGenerateRoute: Routes.getRoute,
      ),
    );
  }
}
