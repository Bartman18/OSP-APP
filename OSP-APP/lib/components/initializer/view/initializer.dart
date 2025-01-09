import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/initializer/bloc/initializer_bloc.dart';
import 'package:fox_core/core/routes.dart';
import 'package:fox_core/widgets/fullscreen_loader.dart';

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializerBloc, InitializerState>(
        listenWhen: (InitializerState previousState, InitializerState state) {
      return previousState.status != state.status;
    },
    listener: (BuildContext context, InitializerState state) {
    if (!context.mounted) {
    return;
    }

    switch (state.status) {
    case InitializerStatus.forceUpdate:
    Navigator.pushReplacementNamed(context, Routes.errorRequireUpdate);
    break;

    case InitializerStatus.notFirstRun:
    Navigator.pushReplacementNamed(context, Routes.onboarding);
    break;

    case InitializerStatus.finished:
    Navigator.pushReplacementNamed(context, Routes.onboarding);
    break;

    case InitializerStatus.userLogged:
    Navigator.pushReplacementNamed(context, Routes.home);
    break;

      default: break;
    }
    },
      child: const FullscreenLoader(),
    );
  }
}