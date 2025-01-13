import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:osp/components/settings/bloc/settings_bloc.dart';
import 'package:osp/components/settings/models/settings_model.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/repositories/settings.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/widgets/bottom_navigation/bottom_bar.dart';
import 'package:osp/widgets/bottom_navigation/dashboard_view.dart';
import 'package:osp/widgets/buttons.dart';
import 'package:osp/widgets/headers.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:osp/widgets/switch.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _formKey = GlobalKey<FormBuilderState>();
  final String _formControlName = 'support';
  final int _formControlLength = 10;

  final UserRepository _userRepository = GetIt.instance<UserRepository>();
  final SettingsRepository _settingsRepository =
  GetIt.instance<SettingsRepository>();

  Widget _buildSettings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
              icon: SvgPicture.asset('assets/icons/back.svg', color: CoreColors.white,),
              color: CoreColors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
            'settings_view.header'.tr().toUpperCase(),
            textAlign: TextAlign.center,
            style: CoreTheme.mediumTextStyle.copyWith(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: CoreColors.white),
              ),
          ),
          
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Helpers.showBottomSheet(
      context,
      children: [
        Center(child: AppHeader(text: 'settings_view.logout'.tr())),
        Center(child: AppHeaderHint(text: 'settings_view.logout_hint'.tr())),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppElevatedButton(
                buttonText: 'widgets.bottom_sheet.yes'.tr(),
                onClick: () => context.read<SettingsBloc>().add(Logout()),
              ),
              AppElevatedButton(
                buttonText: 'widgets.bottom_sheet.no'.tr(),
                onClick: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        )
      ],
    );
  }

  bool _validateForm() => _formKey.currentState!.validate();

  void _sendSupport() {
    if (_validateForm()) {
      final String message =
          _formKey.currentState!.fields[_formControlName]!.value;

      context.read<SettingsBloc>().add(
          Support(message: message, messageType: 'support'));

      Navigator.of(context).pop();
    }
  }

  void _handleSupport(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
                'settings_view.support.header'.tr(),
                style: CoreTheme.boldTextStyle.copyWith(fontSize: 18)),
            content: FormBuilder(
              key: _formKey,
              child: FormBuilderTextField(
                name: _formControlName,
                cursorColor: CoreColors.black,
                decoration: InputDecoration(
                  hintText: 'settings_view.form.message'.tr(),
                  hintStyle: CoreTheme.thinTextStyle.copyWith(fontSize: 13),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: CoreColors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: CoreColors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: CoreColors.black)),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  errorStyle: CoreTheme.thinTextStyle.copyWith(
                    color: Colors.red,
                    height: 1.2, // Adjust line height
                  ),
                  isDense: true, // Reduce the vertical spacing
                  contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 5,
                textAlign: TextAlign.center,
                style: CoreTheme.baseTextStyle
                    .copyWith(color: Colors.black, fontSize: 13),
                onTapOutside: (_) => _validateForm(),
                onSubmitted: (_) => _validateForm(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'settings_view.form.errors.required'.tr(),
                  ),
                  FormBuilderValidators.minLength(
                    _formControlLength,
                    errorText: 'settings_view.form.errors.minLength'.tr(
                      namedArgs: {'count': '$_formControlLength'},
                    ),
                  ),
                ]),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (_validateForm()) {
                      _sendSupport();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext ctx2) {
                            return AlertDialog(
                              title: Text(
                                  'settings_view.support.header'.tr(),
                                  style: CoreTheme.boldTextStyle
                                      .copyWith(fontSize: 18)),
                              content: Text('settings_view.form.sent'.tr(),
                                  style: CoreTheme.thinTextStyle
                                      .copyWith(fontSize: 13)),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx2),
                                    child: Text('widgets.bottom_sheet.ok'.tr(),
                                        style: CoreTheme.mediumTextStyle
                                            .copyWith(
                                            color: CoreColors.black)))
                              ],
                            );
                          });
                    }
                  },
                  child: Text('widgets.bottom_sheet.send'.tr(),
                      style: CoreTheme.mediumTextStyle
                          .copyWith(color: CoreColors.black))),
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('widgets.bottom_sheet.back'.tr(),
                      style: CoreTheme.mediumTextStyle
                          .copyWith(color: CoreColors.black)))
            ],
          );
        });
  }

  void _notificationsCallback(BuildContext context, bool value) {
    setState(() => context
        .read<SettingsBloc>()
        .add(ChangeNotifications(notifications: value)));
  }


  Widget _settingsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          AppSupportButton(
            headerText: 'settings_view.rules.header'.tr(),
            bottomText: 'settings_view.rules.hint'.tr(),
            onClick: () {
            if ('' == _settingsRepository.public.urls.regulations) {
              return;
            }
            launchUrl(
              Uri.parse(_settingsRepository.public.urls.regulations));
            },
            child: SvgPicture.asset('assets/icons/info.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.subscription.header'.tr(),
            bottomText: 'settings_view.subscription.hint'.tr(),
            onClick: () {
              context
                  .read<SettingsBloc>()
                  .add(const ChangeView(view: SettingsView.subscription));
          },
            child: SvgPicture.asset('assets/icons/diamond.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.prizes.header'.tr(),
            bottomText: 'settings_view.prizes.hint'.tr(),
            onClick: () {
              //todo implement popup with prizes user got
            },
            child: SvgPicture.asset('assets/icons/award.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.history.header'.tr(),
            bottomText: 'settings_view.history.hint'.tr(),
            onClick: () {
              //todo implement when historyy will be defind
            },
            child: SvgPicture.asset('assets/icons/list.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.notifications.header'.tr(),
            bottomText: 'settings_view.notifications.hint'.tr(),
            onClick: () {
              //todo implement when notifications will be defined
            },
            child: SvgPicture.asset('assets/icons/notification.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.payment.header'.tr(),
            bottomText: 'settings_view.payment.hint'.tr(),
            onClick: () {
              //todo implement when payments will be defined
            },
            child: Image.asset('assets/icons/credit_card.png', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.rate.header'.tr(),
            bottomText: 'settings_view.rate.hint'.tr(),
            onClick: () {
              if ('' == _settingsRepository.public.store.url) {
                return;
              }
              launchUrl(Uri.parse(_settingsRepository.public.store.url));
            },
            child: Image.asset('assets/icons/review.png', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.pushNotifications.header'.tr(),
            bottomText: 'settings_view.pushNotifications.hint'.tr(),
            onClick: () => _notificationsCallback(
                context, !_userRepository.profile.notifications),
            suffix: AppSwitch(
              value: _userRepository.profile.notifications,
              onChanged: (bool value) => _notificationsCallback(context, value),
              scale: .75,
            ),
            child: SvgPicture.asset('assets/icons/bell-2.svg', width: 20),
          ),
          AppSupportButton(
            headerText: 'settings_view.support.header'.tr(),
            bottomText: 'settings_view.support.hint'.tr(),
            onClick: () => _handleSupport(context),
            child: SvgPicture.asset('assets/icons/support.svg', width: 20),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 36.0,
            child: TextButton(
              onPressed: () => _handleLogout(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/logout.svg', color: CoreColors.white,),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'settings_view.logout'.tr(),
                          style: TextStyle(
                            color: CoreColors.white,
                            fontSize: 14.0,
                            fontVariations:
                            CoreTheme.boldTextStyle.fontVariations,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  if ('' == _settingsRepository.public.urls.regulations) {
                    return;
                  }

                  launchUrl(
                      Uri.parse(_settingsRepository.public.urls.regulations));
                },
                child: Text(
                  'signUp.terms_and_conditions'.tr(),
                  style: TextStyle(
                    color: CoreColors.white.withAlpha(153),
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize!,
                    fontVariations: CoreTheme.baseTextStyle.fontVariations,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if ('' == _settingsRepository.public.urls.privacyPolicy) {
                    return;
                  }

                  launchUrl(
                      Uri.parse(_settingsRepository.public.urls.privacyPolicy));
                },
                child: Text(
                  'signUp.privacy_policy'.tr(),
                  style: TextStyle(
                    color: CoreColors.white.withAlpha(153),
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize!,
                    fontVariations: CoreTheme.baseTextStyle.fontVariations,
                  ),
                ),
              )
            ],
          )
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
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [CoreColors.profile, CoreColors.profileTwo],
              stops: const [0.0, 1.0],
            ),
          ),
        ),DashboardView(
            highlightedTab: BottomBarTab.home,
             child: Skeleton(
                padding: const EdgeInsets.only(left: 20, right: 20),
                removeAppBar: true,
                backgroundColor: Colors.transparent,
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    _buildSettings(),
                    const SizedBox(height: 15),
                    _settingsCards(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
          ),
      ],
    );
  }
}
