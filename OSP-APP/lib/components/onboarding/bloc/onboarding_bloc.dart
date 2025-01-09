import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fox_core/core/helpers.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingStart>(_handleEvent, transformer: Helpers.blocThrottleDroppable());
    on<NextScreen>(_nextScreen, transformer: Helpers.blocThrottleDroppable());

  }

  Future<void> _handleEvent(OnboardingStart event, Emitter<OnboardingState> emit) async {
    emit(state);
  }

  Future<void> _nextScreen(NextScreen event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(screen: state.screen + 1));
  }


}
