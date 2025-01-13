import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osp/components/settings/bloc/settings_bloc.dart';
import 'package:osp/components/settings/view/settings_dashboard.dart';

class SettingsProvider extends StatelessWidget {
  const SettingsProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (_) => SettingsBloc(),
      child: const SettingsDashboard(),
    ),
  );
}
