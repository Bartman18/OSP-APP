import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/sign_up/bloc/sign_up_bloc_instance.dart';
import 'package:fox_core/components/sign_up/bloc/sign_up_state.dart';
import 'package:fox_core/components/sign_up/view/sign_in_or_up.dart';

import 'bloc/sign_up_event.dart';

class SignInOrUpArgs {
  final SignInOrUpContext viewContext;
  SignInOrUpArgs({required this.viewContext});
}

class SignInOrUpProvider extends StatelessWidget {
  final SignInOrUpArgs arguments;

  const SignInOrUpProvider({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: BlocProvider.value(
      value: signUpBloc..add(SetContext(context: arguments.viewContext)),
      child: const SignInOrUp(),
    ),
  );
}
