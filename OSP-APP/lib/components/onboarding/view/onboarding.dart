import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/add_event/add_event.dart';
import 'package:fox_core/components/onboarding/bloc/onboarding_bloc.dart';
import 'package:fox_core/components/sign_up/bloc/sign_up_state.dart';
import 'package:fox_core/components/sign_up/sign_in_or_up_provider.dart';
import 'package:fox_core/components/sign_up/view/sign_in_or_up.dart';
import 'package:fox_core/config/onboarding_config.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/routes.dart';
import 'package:fox_core/widgets/skeleton.dart';
import 'package:fox_core/core/settings_dict.dart';

import '../../sign_up/view/sign_in_or_up.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}
Gradient gradient = LinearGradient(colors: [
  CoreColors.primary,
  CoreColors.white,
]);

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    SettingsDictionary.newUser = false;
  }

  String _getScreen(int screen) => screen > OnboardingConfig.pages
      ? OnboardingConfig.pages.toString()
      : screen.toString();

  String _getMRemiza(int screen) =>
      'onboarding.mremiza'.tr();

  String _getHeader(int screen) =>
      'onboarding.header'.tr();
      
  String _getChooseSixText(int screen) =>
      'onboarding.chooseSix.${_getScreen(screen)}'.tr();

  String _getSignUpText(int screen) =>
      'buttons.signUp.${_getScreen(screen)}'.tr();

  String _getLogInText(int screen) =>
      'buttons.logIn.${_getScreen(screen)}'.tr();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        if (state.screen > OnboardingConfig.pages) {
          Navigator.pushReplacementNamed(context, Routes.signUp, arguments: SignInOrUpArgs(viewContext: SignInOrUpContext.signUp));
        }
      },
      builder: (BuildContext context, OnboardingState state) {
        var screenHeight = MediaQuery.of(context).size.height;
        var screenWidth = MediaQuery.of(context).size.width;

        return Skeleton(
          removeAppBar: true,
          disableSafeAreaTop: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    CoreColors.profileTwo,
                    CoreColors.profile,
                  ])
                ),
                height: double.infinity,
                width: double.infinity,
              ),
              
                 Align(
                  alignment: Alignment.center,
                  child: SafeArea(
                    child: FractionallySizedBox(
                    alignment: Alignment.center,
                    heightFactor:  0.6,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0, 
                          horizontal: screenWidth * 0.1
                          ),
                        child:  Column(
                          children: [
                            Padding(
                            padding: EdgeInsets.only(right: screenWidth*0.15),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                            child: RichText(
                            text: TextSpan(
                              text: _getMRemiza(state.screen),
                              style: CoreTheme.blackTextStyle!.copyWith(
                                fontSize: 40,
                                height: 0.65,
                              ),
                              ),
                              maxLines: 1,
                            ),
                            ),
                            ),
                          ]
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0, 
                          horizontal: screenWidth * 0.1
                          ),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: _getHeader(state.screen),
                            style: CoreTheme.semiBoldTextStyle.copyWith(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              height: screenHeight * 0.0015,
                              color: CoreColors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context, Routes.signUp,
                                        arguments: SignInOrUpArgs(viewContext: SignInOrUpContext.signUp));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        foregroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        minimumSize: WidgetStateProperty.all(Size(screenWidth * 0.8, screenWidth *0.15)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _getSignUpText(state.screen),
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,
                                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize! + 2,
                                              color: CoreColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {Navigator.pushReplacementNamed(context, Routes.signUp,
                                        arguments: SignInOrUpArgs(viewContext: SignInOrUpContext.signUp));},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        foregroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        minimumSize: WidgetStateProperty.all(Size(screenWidth * 0.8, screenWidth *0.15)),
                                        side: WidgetStateProperty.all(BorderSide(color: CoreColors.primary, width: 2)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _getLogInText(state.screen),
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,
                                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize! + 2,
                                              color: CoreColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {Navigator.pushReplacementNamed(context, Routes.home);},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        foregroundColor: WidgetStateProperty.all(CoreColors.primary),
                                        minimumSize: WidgetStateProperty.all(Size(screenWidth * 0.8, screenWidth *0.15)),
                                        side: WidgetStateProperty.all(BorderSide(color: CoreColors.primary, width: 2)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Home",
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,
                                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize! + 2,
                                              color: CoreColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),          
                      AddEventButton(), 
                    ],
                  ),
                ),
              ),
              ),
              //),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor:  0.55,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.10,
                        right: screenWidth * 0.10,
                        top: screenWidth * 0.05,
                        //bottom: screenWidth * 0.05,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          
                          SizedBox(height: screenWidth * 0.02),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'signUp.terms_and_conditions'.tr(),
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,
                                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize! + 2,
                                        color: CoreColors.white.withOpacity(0.6)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'signUp.privacy_policy'.tr(),
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,
                                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize! + 2,
                                        color: CoreColors.white.withOpacity(0.6)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
