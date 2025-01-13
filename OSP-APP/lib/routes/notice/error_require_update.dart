import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:osp/widgets/fullscreen_notice.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:osp/widgets/buttons.dart';

class ErrorRequireUpdate extends StatelessWidget {
  const ErrorRequireUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
        removeAppBar: true,
        disableSafeAreaTop: true,
        child: FullscreenNotice(
          icon: const Icon(Icons.update, color: Colors.white, size: 128),
          header: 'errors.update_required.header'.tr(),
          notice: 'errors.update_required.description'.tr(),
          child: _maybeShowButtonOnSuccess(),
        )
    );
  }

  Widget _maybeShowButtonOnSuccess() {
    String url = GetStorage().read(SettingsDictionary.storeUrl) ?? '';

    if ('' == url) {
      return const Wrap();
    }

    return Column(children: [
      AppElevatedButton(
        buttonText: 'errors.update_required.store.${Platform.isIOS ? 'ios' : 'android'}',
        onClick: () {
          launchUrl(Uri.parse(url));
        },
      ),
    ]);
  }
}