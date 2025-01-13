part of 'add_event_bloc.dart';

final class AddEventState extends Equatable {
  final StateStatus status;
  final String statusMessage;
  final String errorMessage;

  const AddEventState({
    this.status = StateStatus.initial,
    this.statusMessage = '',
    this.errorMessage = '',
  });

   AddEventState copyWith({
    AddEventModel? event,
    StateStatus? status,
    String? statusMessage,
    String? errorMessage,
  }) => AddEventState(
    status: status ?? this.status,
    statusMessage: statusMessage ?? this.statusMessage,
    errorMessage: errorMessage ?? this.errorMessage,
  );
  
  @override
  List<Object> get props => [ status, statusMessage, errorMessage ];
}

//final class AddEventInitial extends AddEventState {}
