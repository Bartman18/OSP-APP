import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_core/components/general_views/calendar/bloc/calendar_bloc.dart';
import 'package:fox_core/components/general_views/calendar/view/calendar.dart';

class CalendarProvider extends StatelessWidget {
  const CalendarProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (_) => CalendarBloc(),
      child: const Calendar(),
    ),
  );

}