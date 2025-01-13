import 'dart:developer';
//import 'dart:math' ;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:osp/components/general_views/home/bloc/home_bloc.dart';
import 'package:osp/components/general_views/home/model/event.dart';
import 'package:osp/core/appearance.dart';
import 'package:osp/core/enums/statuses.dart';
import 'package:osp/widgets/bottom_navigation/bottom_bar.dart';
import 'package:osp/widgets/bottom_navigation/dashboard_view.dart';
import 'package:osp/widgets/card.dart';
import 'package:osp/components/general_views/home/widgets/event.dart';
import 'package:osp/widgets/skeleton.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:osp/core/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:osp/core/repositories/user.dart';
import 'package:get_it/get_it.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final UserRepository _userRepository = GetIt.instance<UserRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  Widget _buildTitleWidget(BuildContext context) {
    
    return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
      CoreColors.profileTwo,
      CoreColors.profile,
    ])
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.settings);
                },
                child: Container(
                  width: 160,
                  height: 60,
                  child: Text(
                    "mRemiza",
                    style: CoreTheme.boldTextStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: CoreColors.white
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Maciej",
                    style: CoreTheme.thinTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Siedlak",
                    style: CoreTheme.thinTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 16,
                    ),
                  ),
                    
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Align(
          //widthFactor: 0.7,
          alignment: Alignment.centerRight,
          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wyjazdy 2024: 000",
                    style: CoreTheme.thinTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Twoje wyjazdy: 000",
                    style: CoreTheme.thinTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 12,
                    ),
                  ),
                    
                ],
              ),
        ),
      ],
    ),
    );
  }

  Widget _buildSubTitleWidget(BuildContext context) {
    
    return Container(
      height: 56,
      padding: EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
        color: CoreColors.primary.withOpacity(0.5),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        
        child: Text(
            "Moje Wydarzenia",
            style: CoreTheme.baseTextStyle.copyWith(
              color: CoreColors.white,
              fontSize: 28,
            ),    
        ),
      ),
    );
  }

  Widget _buildForYou(HomeState state) {
    List<EventModel> _events = [
      EventModel(id:1, title: "Zdejmowanie chuja z drzewa", eventDate: DateTime(99999), place: "Drzewo", type: "wspinaczka", description: "mało ważne", personLimit: 2, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Pożar", eventDate: DateTime(9999), place: "Dom twojej starej", type: "gaszenie", description: "description", personLimit: 6, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Wóda", eventDate: DateTime(9999), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Piwo", eventDate: DateTime(9999), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Alkohol", eventDate: DateTime(1), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Alkohol", eventDate: DateTime(1), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Alkohol", eventDate: DateTime(1), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Alkohol", eventDate: DateTime(1), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Alkohol", eventDate: DateTime(1), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
    ];
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Wrap(
            children: [
              if (index == 0) _buildTitleWidget(context),
              _buildSubTitleWidget(context),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    const SizedBox(height: 10,),
                    for (EventModel _event in _events)
                      Event(event: _event), 
                  ],
                )
                
              
            ],
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 20),
        itemCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.stateStatus == StateStatus.loading) {
            context.loaderOverlay.show();
          }
          if (state.stateStatus != StateStatus.loading) {
            context.loaderOverlay.hide();
          }
        },
        builder: (BuildContext context, HomeState state) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: CoreColors.black,
                ),
              ),
          DashboardView(
            highlightedTab: BottomBarTab.home,
             child: Skeleton(
                //padding: const EdgeInsets.only(left: 20, right: 20),
                removeAppBar: true,
                backgroundColor: Colors.transparent,
                child: _buildForYou(state),
              ),
          ),
            ],
          );
        }
    );
  }
}
