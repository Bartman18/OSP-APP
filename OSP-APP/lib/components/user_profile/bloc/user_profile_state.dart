part of 'user_profile_bloc.dart';

final class UserProfileState extends Equatable {
  final StateStatus status;
  final String statusMessage;
  final String errorMessage;

  const UserProfileState({
    this.status = StateStatus.initial,
    this.statusMessage = '',
    this.errorMessage = '',
  });

  UserProfileState copyWith({
    UserProfileModel? userProfile,
    StateStatus? status,
    String? statusMessage,
    String? errorMessage,
  }) => UserProfileState(
    status: status ?? this.status,
    statusMessage: statusMessage ?? this.statusMessage,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object> get props => [ status, statusMessage, errorMessage ];

}
