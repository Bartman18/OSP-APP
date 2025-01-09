part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeView extends SettingsEvent {
  final SettingsView view;

  const ChangeView({required this.view});

  @override
  List<Object> get props => [view];
}

class ChangeNotifications extends SettingsEvent {
  final bool notifications;

  const ChangeNotifications({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class Logout extends SettingsEvent {}

class Support extends SettingsEvent {
  final String message;
  final String messageType;

  const Support({required this.message, required this.messageType});

  @override
  List<Object> get props => [message];
  }
