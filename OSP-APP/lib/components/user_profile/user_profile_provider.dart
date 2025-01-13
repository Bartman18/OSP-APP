import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osp/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:osp/components/user_profile/view/user_profile.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:get_it/get_it.dart';

class UserProfileArgs {
  final bool isEditMode;
  UserProfileArgs({this.isEditMode = false});
}

class UserProfileProvider extends StatelessWidget {
  final UserProfileArgs arguments;

  const UserProfileProvider({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (_) =>
          UserProfileBloc(repository: GetIt.instance<UserRepository>()),
      child: UserProfile(isEditMode: arguments.isEditMode),
    ),
  );
}
