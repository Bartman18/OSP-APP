import 'dart:io';
import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/settings_dict.dart';
import 'package:fox_core/widgets/bottom_sheet.dart';
import 'package:fox_core/widgets/buttons.dart';
import 'package:fox_core/widgets/headers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_transform/stream_transform.dart';

class Helpers {
  static List<String> get possibleLocales => ['en', 'pl'];

  static EventTransformer<E> blocThrottleDroppable<E>(
      {Duration duration = const Duration(milliseconds: 100)}) {
    return (events, mapper) => droppable<E>().call(events.throttle(duration), mapper);
  }

  static String getAppLocale() => Helpers.getValidLocale(
      GetStorage().read<String?>(SettingsDictionary.appLanguage) ?? Helpers.getDeviceLanguage());

  static String getValidLocale(String locale) {
    if (possibleLocales.contains(locale.toLowerCase())) {
      return locale.toLowerCase();
    }

    return 'en';
  }

  static String getDeviceLanguage() {
    return Platform.localeName.split('_')[0];
  }

  static String getDeviceLanguageCountry() {
    return Platform.localeName.split('_')[1];
  }

  static Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  static void deniedCameraAccessCallback(BuildContext context) {
    String description = Platform.isIOS
        ? 'errors.permissions.camera_description_ios'.tr()
        : 'errors.permissions.camera_description_android'.tr();

    Helpers.showErrorBottomSheet(context,
        header: 'errors.permissions.general_header'.tr(), description: description);
  }

  static void deniedGalleryAccessCallback(BuildContext context) {
    String description = Platform.isIOS
        ? 'errors.permissions.gallery_description_ios'.tr()
        : 'errors.permissions.gallery_description_android'.tr();

    Helpers.showErrorBottomSheet(context,
        header: 'errors.permissions.general_header'.tr(), description: description);
  }

  static void showBottomSheet(
    BuildContext context,
    {
      required List<Widget> children,
      bool enableDrag = true,
      bool isDismissible = true
    }
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) => AppBottomSheet(children: children),
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: CoreColors.profile,
    );
  }

  static void showErrorBottomSheet(
    BuildContext context,
    {
      required String header,
      required String description,
      Widget Function(BuildContext)? navBuilder
    }
  ) {
    navBuilder ??= (BuildContext ctx) => Center(
      child: AppElevatedButton(
        buttonText: 'widgets.bottom_sheet.ok'.tr(),
        onClick: () => Navigator.pop(ctx),
      )
    );

    Helpers.showBottomSheet(context, enableDrag: false, isDismissible: false, children: [
      Center(child: Icon(Icons.error, color: CoreColors.black, size: 32)),
      Center(child: AppHeader(text: header)),
      Center(child: AppHeaderHint(text: description)),
      Padding(padding: const EdgeInsets.only(top: 50, bottom: 10), child: navBuilder(context))
    ]);
  }

  static bool fieldHasContent(dynamic value) {
    return !(null == value || '' == value || (value is List && value.isEmpty));
  }

  static bool isOldEnough(DateTime birthday) {
    final DateTime today = DateTime.now();
    int age = today.year - birthday.year;

    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }

    return age >= 13;
  }

  static String generateNonce([int length = 32]) {
    const String charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    Random random = Random.secure();

    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  static String formatCommentDate(DateTime createdAt, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    final locale = EasyLocalization.of(context)?.locale.toLanguageTag() ?? 'en';

    if (difference.inMinutes < 1) {
      return 'main_view.article.time.just_now'.tr();
    } else if (difference.inHours < 1) {
      return '${'main_view.article.time.today'.tr()}, ${DateFormat.Hm(locale).format(createdAt)}';
    } else if (difference.inDays < 1) {
      return '${'main_view.article.time.today'.tr()}, ${DateFormat.Hm(locale).format(createdAt)}';
    } else if (difference.inDays == 1) {
      return '${'main_view.article.time.yesterday'.tr()}, ${DateFormat.Hm(locale).format(createdAt)}';
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return '${DateFormat.EEEE(locale).format(createdAt)}, ${DateFormat.Hm(locale).format(createdAt)}';
    } else {
      return DateFormat('d MMMM, yyyy', locale).format(createdAt);
    }
  }

  static String formatReadingTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
