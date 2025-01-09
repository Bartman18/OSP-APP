part of 'onboarding_bloc.dart';

final class OnboardingState extends Equatable {
  final int screen;

  const OnboardingState({
    this.screen = 1,
  });

  OnboardingState copyWith({int? screen}) => OnboardingState(
    screen: screen ?? this.screen,
  );

  @override
  List<Object> get props => [ screen ];


}

