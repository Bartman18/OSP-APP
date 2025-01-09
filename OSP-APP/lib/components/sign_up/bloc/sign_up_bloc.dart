import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:fox_core/api/v1/app_sign_up.dart';
import 'package:fox_core/api/v1/user.dart';
import 'package:fox_core/components/sign_up/bloc/sign_up_event.dart';
import 'package:fox_core/components/sign_up/bloc/sign_up_state.dart';
import 'package:fox_core/components/sign_up/models/sign_up_register.dart';
import 'package:fox_core/core/enums/statuses.dart';
import 'package:fox_core/core/helpers.dart';
import 'package:fox_core/core/repositories/settings.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:fox_core/core/settings_dict.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class SignUpBloc extends Bloc<SignInOrUpEvent, SignUpState> {
  final UserRepository _userRepository = GetIt.I<UserRepository>();
  final SettingsRepository _settingsRepository = GetIt.I<SettingsRepository>();

  final AppSignUp appSignUp = AppSignUp();
  final User _user = User();

  SignUpBloc() : super(const SignUpState()) {
    on<SetContext>(_onSetContext, transformer: Helpers.blocThrottleDroppable());
    on<SaveEmailAndPassword>(_onSaveEmailAndPassword, transformer: Helpers.blocThrottleDroppable());
    on<SignInWithCredentials>(_onSignInWithCredentials,
        transformer: Helpers.blocThrottleDroppable());
    on<SignInByIntegration>(_onSignInByIntegration, transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onSetContext(SetContext event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(context: event.context));
  }

  Future<void> _onSaveEmailAndPassword(
      SaveEmailAndPassword event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      canLogIn: false,
    ));

    ApiResponse userEndpoint = await _user.exists(state.email);

    if (ApiResponseStatus.success == userEndpoint.status) {
      emit(state.copyWith(
        canLogIn: true,
        loggedByIntegration: false,
        status: StateStatus.goToNextScreen,
      ));

      return;
    }

    /*ApiResponse response = await appSignUp.sendVerificationCode(event.email);

    if (response.status != ApiResponseStatus.success) {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: 'errors.generic.header'.tr(),
      ));

      return;
    }

    emit(state.copyWith(
      verificationToken: response.content['id'],
      canLogIn: false,
      email: event.email,
      password: event.password,
      status: StateStatus.goToNextScreen,
    ));*/
  }

  

  // Future<void> _onRegisterWithoutAuth(
  //     SignUpRegisterWithoutAuth event, Emitter<SignUpState> emit) async {
  //   emit(state.copyWith(status: StateStatus.loading));

  //   SignUpRegisterModel model = SignUpRegisterModel(
  //     password: event.password,
  //     passwordConfirmation: event.password,
  //     email: event.email,
  //   );

  //   ApiResponse response = await appSignUp.registerWithoutAuth(model);

  //   if (response.status == ApiResponseStatus.success) {
  //     emit(state.copyWith(status: StateStatus.goToNextScreen));
  //   } else {
  //     emit(state.copyWith(
  //       status: StateStatus.error,
  //       errorMessage: 'errors.generic.header'.tr(),
  //     ));
  //   }
  // }
  
  Future<void> _onSignInByIntegration(SignInByIntegration event, Emitter<SignUpState> emit) async {
    await _loadUserData();
    await _settingsRepository.private.load();

    emit(state.copyWith(
      status: StateStatus.goToNextScreen,
      loggedByIntegration: true,
      isRegisterEvent: event.isRegisterEvent,
      isLoginEvent: event.isLoginEvent,
    ));
  }

  Future<void> _registerAccount(SignUpRegisterModel model, Emitter<SignUpState> emit) async {
    _userRepository.profile.email = model.email;
    _userRepository.profile.name = model.name ?? '';

    ApiResponse response =
        await _user.createAccount(_userRepository.profile, password: model.password);

    if (response.status == ApiResponseStatus.success) {
      _saveToken(response);
      await _settingsRepository.public.load();
      await _settingsRepository.private.load();
      emit(state.copyWith(
        status: StateStatus.goToNextScreen,
        password: '',
      ));
    } else {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: 'errors.generic.header'.tr(),
      ));
    }
  }

  Future<void> _onSignInWithCredentials(
      SignInWithCredentials event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(status: StateStatus.loading));

    _userRepository.profile.email = event.email;
    ApiResponse response = await _user.login(_userRepository.profile, password: event.password);

    if (response.status == ApiResponseStatus.success) {
      await _saveToken(response);
      await _settingsRepository.public.load();
      await _loadUserData();
      await _settingsRepository.private.load();

      emit(state.copyWith(
        canLogIn: true,
        userSetName: _userRepository.profile.name.isNotEmpty,
        status: StateStatus.goToNextScreen,
      ));
    } else {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: 'email_verification.errors.account_not_found'.tr(),
      ));
    }
  }

  Future<void> _saveToken(ApiResponse response) async {
    String token = response.content?['token'] ?? '-1';
    GetStorage().write(SettingsDictionary.userToken, token);
  }

  Future<void> _loadUserData() async {
    ApiResponse response = await _user.load();

    if (ApiResponseStatus.failure == response.status || response.content is! Map) {
      return;
    }

    _userRepository.profile.loadFromApiResponse(response.content);
  }
}
