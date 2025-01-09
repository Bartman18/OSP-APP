part of 'initializer_bloc.dart';

sealed class InitializerEvent extends Equatable {
  const InitializerEvent();

  @override
  List<Object?> get props => [];

}

final class LoadAppData extends InitializerEvent {}
