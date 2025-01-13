import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/api/v1/bets.dart';
import 'package:osp/components/general_views/home/model/event.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/core/helpers.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadBets>(_onLoadBets,
        transformer: Helpers.blocThrottleDroppable());
  }

  Future<void> _onLoadBets(
      LoadBets event, Emitter<HomeState> emit) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    
    ApiResponse response = await Bets().getCurrentBets();
    log(response.statusCode.toString());
    log(response.status.toString());
    log(response.content.toString());
    if (response.status == ApiResponseStatus.failure) {
      emit(state.copyWith(
        stateStatus: StateStatus.error,
        errorMessage: 'errors.generic.header'.tr(),
      ));
      return;
    }

    List<dynamic> bets = response.content as List<dynamic>;
    List<EventModel> betsList = bets.map((contentJson) {
      return EventModel.fromJson(contentJson);
    }).toList();
    
    emit(
      state.copyWith(
        stateStatus: StateStatus.loaded,
        betsContent: betsList,
      ),
    );
  }
}
