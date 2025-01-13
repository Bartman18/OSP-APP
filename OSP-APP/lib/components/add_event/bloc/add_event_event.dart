part of 'add_event_bloc.dart';

sealed class AddEventEvent extends Equatable {
  const AddEventEvent();

  @override
  List<Object> get props => [];
}

class MaybeSaveData extends AddEventEvent {
  final AddEventModel addEvent;

  const MaybeSaveData({required this.addEvent});
}
