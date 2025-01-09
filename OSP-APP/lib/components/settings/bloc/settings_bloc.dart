import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:fox_core/api/v1/user.dart';
import 'package:fox_core/core/enums/statuses.dart';
import 'package:fox_core/core/helpers.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:fox_core/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_it/get_it.dart';

part 'settings_enums.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository _user = GetIt.I<UserRepository>();

  SettingsBloc()
      : super(const SettingsState()) {
    on<ChangeView>(_onChangeView, transformer: Helpers.blocThrottleDroppable());
    on<ChangeNotifications>(_onChangeNotifications,
        transformer: Helpers.blocThrottleDroppable());
    on<Logout>(_onLogout, transformer: Helpers.blocThrottleDroppable());
    on<Support>(_onSupport,
        transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onChangeView(
      ChangeView event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(action: SettingsAction.idle, view: event.view));
  }

  Future<void> _onChangeNotifications(
      ChangeNotifications event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
        action: SettingsAction.idle, status: StateStatus.loading));

    _user.profile.notifications = event.notifications;
    GetStorage()
        .write(SettingsDictionary.notifications, _user.profile.notifications);
    await User().updateNotifications(_user.profile.notifications);

    emit(state.copyWith(
        action: SettingsAction.idle, status: StateStatus.loaded));
  }

  Future<void> _onLogout(Logout event, Emitter<SettingsState> emit) async {
    GetStorage().write(SettingsDictionary.userToken, '');
    _user.profile.purgeModel();
    User().logout();
    emit(state.copyWith(action: SettingsAction.logout));
  }

  Future<void> _onSupport(
      Support event, Emitter<SettingsState> emit) async {
    ApiResponse? response;

    if ('support' == event.messageType) {
      response = await User().support(event.message);
      emit(state.copyWith(
          action: SettingsAction.support, status: StateStatus.loaded));
    }

    if (response?.status == ApiResponseStatus.success) {
      emit(state.copyWith(
          action: SettingsAction.idle, status: StateStatus.loaded));
    }
  }
}
