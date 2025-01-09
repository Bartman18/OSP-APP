part of 'initializer_bloc.dart';

enum InitializerStatus {
  initial,
  forceUpdate,
  finished,
  notFirstRun,
  userLogged,
}

class InitializerState extends Equatable {
  final InitializerStatus status;

  const InitializerState({this.status = InitializerStatus.initial});
  InitializerState copyWith({InitializerStatus? status}) => InitializerState(status: status ?? this.status);

  @override
  List<Object> get props => [status];
}

class DoUpdateState extends InitializerState {}
