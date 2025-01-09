import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fox_core/core/repositories/user.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository _user;

  DashboardBloc({required UserRepository user})
      : _user = user,
        super(const DashboardState());
}
