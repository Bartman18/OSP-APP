import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/api/v1/user.dart';
import 'package:osp/components/user_profile/models/user_profile.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  late final UserRepository _repository;

  UserProfileBloc({required UserRepository repository})
      : _repository = repository,
        super(const UserProfileState()) {
    on<LoadProfile>(_onLoadProfile, transformer: Helpers.blocThrottleDroppable());
    on<MaybeSaveData>(_onMaybeSaveData, transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: StateStatus.loading, statusMessage: ''));
    emit(state.copyWith(status: StateStatus.loaded, statusMessage: ''));
  }

  Future<void> _onMaybeSaveData(MaybeSaveData event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(
        status: StateStatus.loading, statusMessage: 'userProfile.loader.save_data'.tr()));

    UserProfileModel model = event.userProfile;

    Map<String, dynamic> jsonModel = model.toJSON();
    GetStorage().write(SettingsDictionary.localUserProfile, jsonModel);



    }
  }
