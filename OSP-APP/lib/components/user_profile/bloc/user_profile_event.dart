part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends UserProfileEvent {}

class MaybeSaveData extends UserProfileEvent {
  final UserProfileModel userProfile;

  const MaybeSaveData({required this.userProfile});
}
