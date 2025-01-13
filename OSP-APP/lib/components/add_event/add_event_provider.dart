import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osp/components/add_event/add_event.dart';
import 'package:osp/components/add_event/bloc/add_event_instance.dart';

class AddEventProvider extends StatelessWidget {
  const AddEventProvider({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider.value(
          value: addEventBlocInstance,
          child: AddEventView(),
        ),
      );
}
