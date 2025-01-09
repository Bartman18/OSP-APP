part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final SettingsView view;
  final SettingsAction action;
  final StateStatus status;
  final String errorMessage;

  const SettingsState({
    this.view = SettingsView.menu,
    this.action = SettingsAction.idle,
    this.status = StateStatus.initial,
    this.errorMessage = '',
  });

  SettingsState copyWith({
    SettingsView? view,
    SettingsAction? action,
    StateStatus? status,
    String? errorMessage,
  }) =>
      SettingsState(
        view: view ?? this.view,
        action: action ?? this.action,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object> get props => [view, action, status, errorMessage];
}
