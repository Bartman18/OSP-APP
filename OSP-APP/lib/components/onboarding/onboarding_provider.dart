import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/onboarding/bloc/onboarding_bloc.dart';
import 'package:fox_core/components/onboarding/view/onboarding.dart';

class OnboardingProvider extends StatelessWidget {
  const OnboardingProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (_) => OnboardingBloc()..add(OnboardingStart()),
      child: const Onboarding(),
    ),
  );

}