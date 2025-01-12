import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  AddEventBloc() : super(AddEventInitial()) {
    on<AddEventEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
