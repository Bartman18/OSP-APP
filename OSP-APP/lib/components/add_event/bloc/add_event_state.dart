part of 'add_event_bloc.dart';

sealed class AddEventState extends Equatable {
  const AddEventState();
  
  @override
  List<Object> get props => [];
}

final class AddEventInitial extends AddEventState {}
