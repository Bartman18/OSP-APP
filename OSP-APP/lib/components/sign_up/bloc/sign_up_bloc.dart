import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/api/v1/user.dart';
import 'package:osp/components/sign_up/bloc/sign_up_event.dart';
import 'package:osp/components/sign_up/bloc/sign_up_state.dart';
import 'package:osp/components/sign_up/models/sign_up_register.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class SignUpBloc extends Bloc<SignInOrUpEvent, SignUpState> {
  final UserRepository _userRepository = GetIt.I<UserRepository>();

  final User _user = User();

  SignUpBloc() : super(const SignUpState()) {
    on<SetContext>(_onSetContext, transformer: Helpers.blocThrottleDroppable());
    on<SaveEmailAndPassword>(_register, transformer: Helpers.blocThrottleDroppable());
    //on<SignInWithCredentials>(_onSignInWithCredentials,
        //transformer: Helpers.blocThrottleDroppable());
    //on<SignInByIntegration>(_onSignInByIntegration, transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onSetContext(SetContext event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(context: event.context));
  }

  Future<void> _register(SaveEmailAndPassword event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      canLogIn: false,
    ));
    //log(event.name);
    ApiResponse userEndpoint = await _user.register(userData: SignUpRegisterModel(
      name: event.name,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      password: event.password,
    ));

    if (ApiResponseStatus.success == userEndpoint.status) {
      emit(state.copyWith(
        canLogIn: true,
        status: StateStatus.goToNextScreen,
      ));
  }

  /*Future<void> _onSaveEmailAndPassword(
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
    //}

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
  
  Future<void> _onSignInByIntegration(SignInByIntegration event, Emitter<SignUpState> emit) async {
    await _loadUserData();

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
      await _loadUserData();

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
    ApiResponse response = await _user.protected();

    if (ApiResponseStatus.failure == response.status || response.content is! Map) {
      return;
    }

    _userRepository.profile.loadFromApiResponse(response.content);
  }*/
}
}