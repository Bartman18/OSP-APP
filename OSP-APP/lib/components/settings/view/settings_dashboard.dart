import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osp/components/settings/bloc/settings_bloc.dart';
import 'package:osp/components/settings/view/connected_accounts.dart';
import 'package:osp/components/settings/view/menu.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SettingsDashboard extends StatefulWidget {
  const SettingsDashboard({super.key});

  @override
  State<SettingsDashboard> createState() => _SettingsDashboardState();
}

class _SettingsDashboardState extends State<SettingsDashboard> {

  Widget _resolveView(SettingsView view) {
    switch (view) {
      case SettingsView.accounts:
        return const ConnectedAccounts();
      default:
        return const SettingsMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) =>
      previous.view != current.view ||
          previous.action != current.action ||
          previous.status != current.status,
      listener: (context, state) {
        if (!context.mounted) {
          return;
        }

        if (StateStatus.loading == state.status) {
          context.loaderOverlay.show();
        }

        if (StateStatus.loading != state.status) {
          context.loaderOverlay.hide();
        }

        if (state.action == SettingsAction.logout) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.initializer, (_) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Skeleton(
            disableSafeAreaTop: true,
            removeAppBar: true,
            child: _resolveView(state.view),
          ),
        );
      },
    );
  }
}
