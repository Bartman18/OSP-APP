import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/general_views/dashboard/dashboard_bloc.dart';
import 'package:fox_core/components/general_views/home/bloc/home_bloc.dart';
import 'package:fox_core/components/general_views/home/view/home.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:get_it/get_it.dart';

class DashboardProvider extends StatelessWidget {
  const DashboardProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DashboardBloc(user: GetIt.instance<UserRepository>())),
            BlocProvider(create: (_) => HomeBloc()..add(LoadBets())),
          ],
          child: const Home(),
        ),
      );
}
