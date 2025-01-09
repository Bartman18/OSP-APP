part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final String errorMessage;
  final StateStatus stateStatus;
  final List<EventModel> betsContent;

  const HomeState({
    this.errorMessage = '',
    this.stateStatus = StateStatus.initial,
    this.betsContent = const [],
  });

  HomeState copyWith({
    String? errorMessage,
    StateStatus? stateStatus,
    List<EventModel>? betsContent,
    int? page,
  }) =>
      HomeState(
        stateStatus: stateStatus ?? this.stateStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        betsContent: betsContent ?? this.betsContent,
      );

  @override
  List<Object?> get props => [
    errorMessage,
    stateStatus,
    betsContent,
      ];
}

final class HomeInitial extends HomeState {}
