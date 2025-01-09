import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_core/components/settings/bloc/settings_bloc.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:fox_core/widgets/buttons.dart';
import 'package:get_it/get_it.dart';

class ConnectedAccounts extends StatefulWidget {
  const ConnectedAccounts({super.key});

  @override
  State<ConnectedAccounts> createState() => _ConnectedAccountsState();
}

class _ConnectedAccountsState extends State<ConnectedAccounts> {
  final UserRepository _userRepository = GetIt.instance<UserRepository>();

  Widget _buildSettings() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(onPressed: () => context.read<SettingsBloc>().add(const ChangeView(view: SettingsView.menu)),
            icon: SvgPicture.asset('assets/icons/back.svg'),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'settings_view.connect.header'.tr(),
                style: CoreTheme.mediumTextStyle.copyWith(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: CoreColors.black),
              ),
              Text(
                'settings_view.connect.hint'.tr(),
                textAlign: TextAlign.start,
                style: CoreTheme.thinTextStyle.copyWith(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    color: CoreColors.black.withOpacity(.6)),
              )
            ],
          ),
        ),
      ],
    );
  }


  Widget _settingsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSupportButton(
            headerText: 'settings_view.connect.options.phone'.tr(),
            bottomText: 'settings_view.connect.options.phone_hint'.tr(),
            onClick: () => {},
            child: SvgPicture.asset('assets/icons/phone.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.connect.options.google'.tr(),
            bottomText: 'settings_view.connect.options.not_connected'.tr(),
            onClick: () => {},
            child: SvgPicture.asset('assets/icons/google-2.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.connect.options.facebook'.tr(),
            bottomText: 'settings_view.connect.options.not_connected'.tr(),
            onClick: () => {},
            child: SvgPicture.asset('assets/icons/facebook-2.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.connect.options.apple'.tr(),
            bottomText: 'settings_view.connect.options.not_connected'.tr(),
            onClick: () => {},
            child: SvgPicture.asset('assets/icons/apple.svg', width: 20, colorFilter: ColorFilter.mode(CoreColors.white, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CoreColors.profile, CoreColors.profileTwo],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        ListView(
          children: [
            const SizedBox(height: 30),
            _buildSettings(),
            const SizedBox(height: 15),
            _settingsCards(context),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
