import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/api/v1/events.dart';
import 'package:osp/components/add_event/model/add_event_model.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';
import 'package:osp/core/settings_dict.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  AddEventBloc() : super(AddEventState()) {
    on<MaybeSaveData>(_onMaybeSaveData, transformer: Helpers.blocThrottleDroppable());
  }
  Future<void> _onMaybeSaveData(MaybeSaveData event, Emitter<AddEventState> emit) async {
    emit(state.copyWith(
        status: StateStatus.loading, statusMessage: 'zapisywanie'));

    AddEventModel model = event.addEvent;

    Map<String, dynamic> jsonModel = model.toJson();
    GetStorage().write(SettingsDictionary.localUserProfile, jsonModel);

    ApiResponse productAdd = await EventsAPI().addNewEvent(model); 

    if (ApiResponseStatus.failure == productAdd.status) {
      emit(state.copyWith(
          status: StateStatus.error,
          statusMessage: '',
          errorMessage: 'nie mozna zapisac'));
      return;
    }
    
    emit(state.copyWith(status: StateStatus.goToNextScreen, statusMessage: ''));

  }
}
