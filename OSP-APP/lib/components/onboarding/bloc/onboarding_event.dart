part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];

}

final class OnboardingStart extends OnboardingEvent {}
final class NextScreen extends OnboardingEvent {}