import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:osp/components/sign_up/bloc/sign_up_bloc.dart';
import 'package:osp/components/sign_up/bloc/sign_up_event.dart';
import 'package:osp/components/sign_up/bloc/sign_up_state.dart';
import 'package:osp/components/sign_up/sign_in_or_up_provider.dart';
import 'package:osp/config/onboarding_config.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/routes.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:osp/shared/custom_input_decoration.dart';
import 'package:osp/widgets/buttons.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:loader_overlay/loader_overlay.dart';

enum FormFieldNames { email, password }

class SignInOrUp extends StatefulWidget {
  const SignInOrUp({super.key});

  @override
  State<SignInOrUp> createState() => _SignInOrUpState();
}

class _SignInOrUpState extends State<SignInOrUp> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _obscureText = false;

  bool _validateForm() => _formKey.currentState!.validate();

  bool _isSignIn(SignInOrUpContext ctx) => SignInOrUpContext.signIn == ctx;

  String _getTitle(SignInOrUpContext context) {
    return 'Zaloguj się';
  }

  String _getSubTitle(SignInOrUpContext context) {
    return 'Proszę';
  }

  Widget _buildLoginForm(SignInOrUpContext signInOrUpContext) {
    String prefix = 'signIn' == signInOrUpContext.name ? 'sign_in' : 'sign_up';

    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormBuilderTextField(
            name: FormFieldNames.email.name,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            style: CoreTheme.baseTextStyle.copyWith(color: CoreColors.white),
            decoration: customInputDecoration(paddingValue: defaultInputPadding).copyWith(
              hintText: 'example@gmail.com',
              hintStyle: CoreTheme.thinTextStyle.copyWith(color: CoreColors.white.withAlpha(80)),
              errorStyle: errorStyle,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Gdzie mail skurwielu'),
              FormBuilderValidators.email(errorText: 'To chyba nie jest mail ;)'),
            ]),
          ),
          const SizedBox(height: defaultInputPadding),
          FormBuilderTextField(
            name: FormFieldNames.password.name,
            keyboardType: TextInputType.visiblePassword,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            obscureText: _obscureText,
            obscuringCharacter: '*',
            style: CoreTheme.baseTextStyle.copyWith(color: CoreColors.white),
            decoration: customInputDecoration(paddingValue: defaultInputPadding).copyWith(
              hintText: 'twoja_data_urodzin1234',
              hintStyle: CoreTheme.thinTextStyle.copyWith(color: CoreColors.white.withAlpha(80)),
              errorStyle: errorStyle,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 16),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: CoreColors.gray,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  color: Colors.white,
                ),
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'cos zjebałes'),
              FormBuilderValidators.minLength(
                SettingsDictionary.passwordMinLength,
                errorText: 'za małego masz'.tr(
                  namedArgs: {'count': '${SettingsDictionary.passwordMinLength}'},
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }


  Widget _buildSubmitButton(SignUpState state) {
    return AppElevatedButton(
      buttonText:'lognij sie plis',
      //textColor: Colors.white,
      buttonStyle: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
        backgroundColor: WidgetStatePropertyAll(CoreColors.primary),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 0)),
      ),
      onClick: () {
        if (!_validateForm()) {
          return;
        }

        final String name = "asd";
        final String lastName = "Cifdapior";
        final String email = _formKey.currentState!.fields[FormFieldNames.email.name]?.value;
        final String phone = "000050500";
        final String password = _formKey.currentState!.fields[FormFieldNames.password.name]?.value;
        //if (_isSignIn(state.context)) {
          //context.read<SignUpBloc>().add(SignInWithCredentials(email, password));
        //} else {
          context.read<SignUpBloc>().add(SaveEmailAndPassword(name, lastName ,email, phone, password));
        //}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (BuildContext context, SignUpState state) {
        if (state.status == StateStatus.goToNextScreen) {
          String route = Routes.home;

          if (state.canLogIn && state.context == SignInOrUpContext.signIn) {
            Navigator.pushReplacementNamed(context, Routes.home);
            return;
          }

          if (state.canLogIn) {
            Navigator.pushReplacementNamed(context, Routes.signUp,
                arguments: SignInOrUpArgs(viewContext: SignInOrUpContext.signIn));
            return;
          }

          if (state.loggedByIntegration) {
            context.loaderOverlay.show();
            route = Routes.home;
          }

        }

        if (state.status == StateStatus.error) {
          Helpers.showErrorBottomSheet(
            context,
            header: 'errors.generic.header'.tr(),
            description: state.errorMessage,
          );
        }
      },
      builder: (BuildContext context, SignUpState state) {
        return Skeleton(
          removeAppBar: true,
          disableSafeAreaTop: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: CoreColors.primary),
              ),
              Container(
                color: CoreColors.primary.withOpacity(0.6),
                height: double.infinity,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CoreColors.black.withOpacity(.1),
                            CoreColors.black.withOpacity(.5)
                          ],
                          stops: const [
                            .30,
                            .70
                          ]),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, Routes.onboarding),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        
                        const SizedBox(height: 5.0),
                        Center(
                          child: Text(
                            _getSubTitle(state.context),
                            style: CoreTheme.semiBoldTextStyle
                                .copyWith(color: CoreColors.white.withOpacity(.8), fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLoginForm(state.context),
                        const SizedBox(height: 30),
                        _buildSubmitButton(state),
                        const SizedBox(height: 20),
                      ],
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
