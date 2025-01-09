import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/initializer/bloc/initializer_bloc.dart';
import 'package:fox_core/components/initializer/view/initializer.dart';
import 'package:fox_core/core/repositories/settings.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:get_it/get_it.dart';

class InitializerProvider extends StatelessWidget {
  const InitializerProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (_) => InitializerBloc(
        user: GetIt.instance<UserRepository>(),
        settings: GetIt.instance<SettingsRepository>(),
      )..add(LoadAppData()),
      child: const Initializer(),
    ),
  );

}