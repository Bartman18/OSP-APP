import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/app.dart';
import 'package:fox_core/core/repositories/settings.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:fox_core/observer.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();

  EasyLocalization.logger.enableBuildModes = [];

  GetIt.instance.registerLazySingleton<UserRepository>(() => UserRepository());
  GetIt.instance.registerLazySingleton<SettingsRepository>(() => SettingsRepository());

  Bloc.observer = const AppObserver();
  runApp(EasyLocalization(
      supportedLocales: const [ Locale('en'), Locale('pl') ],
      startLocale: const Locale('pl'),
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: const DarkFoxCoreApp()
  ));
}
