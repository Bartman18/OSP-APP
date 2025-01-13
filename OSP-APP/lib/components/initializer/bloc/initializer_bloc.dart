import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/api/v1/app_settings.dart';
import 'package:osp/components/initializer/config_creator.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/repositories/settings.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';
import 'package:osp/api/v1/user.dart';

part 'initializer_event.dart';
part 'initializer_state.dart';

class InitializerBloc extends Bloc<InitializerEvent, InitializerState> {
  final UserRepository _user;
  final SettingsRepository _settings;

  InitializerBloc({required UserRepository user, required SettingsRepository settings}): _user = user, _settings = settings, super(const InitializerState()) {
    on<LoadAppData>(_onLoadAppData, transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onLoadAppData(LoadAppData event, Emitter<InitializerState> emit) async {
    await _loadLicences();
    await _loadConfigs();
    await _loadPublicSettings();

    ApiResponse response = await AppSettings().version();
    bool forceUpdate = await _forceUpdate(emit, response);

    if (forceUpdate) {
      emit(state.copyWith(status: InitializerStatus.forceUpdate));
      return;
    }

    final userToken = GetStorage().read(SettingsDictionary.userToken);
    if (null == userToken) {
      emit(state.copyWith(status: InitializerStatus.finished));
      return;
    }
    ApiResponse loginResponse = await User().load();

    if (loginResponse.status == ApiResponseStatus.success) {

      //await _user.availableDirections.load();
      _user.profile.loadFromApiResponse(loginResponse.content);

      emit(state.copyWith(status: InitializerStatus.userLogged));
      return;
    }

    GetStorage().read(SettingsDictionary.isFirstRun) ?? true
        ? emit(state.copyWith(status: InitializerStatus.notFirstRun))
        : emit(state.copyWith(status: InitializerStatus.finished));
  }

  Future<void> _loadLicences() async {
    LicenseRegistry.addLicense(() async* {
      final montserrat = await rootBundle.loadString('assets/licenses/Montserrat.txt');

      yield LicenseEntryWithLineBreaks(['google_fonts'], montserrat);
    });
  }

  Future<void> _loadConfigs() async {
    await ConfigCreator().run();
  }

  Future<void> _loadPublicSettings() async {
    await _settings.public.load();
  }

  Future<bool> _forceUpdate(Emitter<InitializerState> emit, ApiResponse response) async {
    String platformKey = Platform.isIOS ? 'ios' : 'android';
    String apiVersion = response.content?[platformKey]?['version'] ?? '-1';

    return '-1' != apiVersion && apiVersion != await Helpers.getCurrentAppVersion();
  }

}
