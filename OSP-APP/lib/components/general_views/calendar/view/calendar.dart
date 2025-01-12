import 'dart:developer';
//import 'dart:math' ;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_core/components/general_views/calendar/bloc/calendar_bloc.dart';
import 'package:fox_core/components/general_views/home/bloc/home_bloc.dart';
import 'package:fox_core/components/general_views/home/model/event.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/enums/statuses.dart';
import 'package:fox_core/widgets/bottom_navigation/bottom_bar.dart';
import 'package:fox_core/widgets/bottom_navigation/dashboard_view.dart';
import 'package:fox_core/widgets/card.dart';
import 'package:fox_core/components/general_views/home/widgets/event.dart';
import 'package:fox_core/widgets/skeleton.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fox_core/core/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
    String profilePicture = _userRepository.profile.profilePicture;
    
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
            "Kalendarz",
            style: CoreTheme.baseTextStyle.copyWith(
              color: CoreColors.white,
              fontSize: 28,
            ),    
        ),
      ),
    );
  }
  

  Widget _buildForYou(CalendarState state) {
    List<EventModel> _events = [
      EventModel(id:1, title: "Zdejmowanie chuja z drzewa", eventDate: DateTime(99999), place: "Drzewo", type: "wspinaczka", description: "mało ważne", personLimit: 2, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Pożar", eventDate: DateTime(9999), place: "Dom twojej starej", type: "gaszenie", description: "description", personLimit: 6, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Wóda", eventDate: DateTime(9999), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
      EventModel(id:1, title: "Piwo", eventDate: DateTime(9999), place: "Żabka", type: "ważne", description: "Współpraca", personLimit: 16, eventConfirmed: true, userId: 1),
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
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      
                      headerStyle: HeaderStyle(
                        decoration: BoxDecoration(color: CoreColors.primary),
                        titleTextStyle: CoreTheme.semiBlackTextStyle.copyWith(color: CoreColors.white),
                        formatButtonTextStyle: CoreTheme.semiBlackTextStyle.copyWith(color: CoreColors.white),
                      ),
                      calendarStyle: CalendarStyle(
                        //outsideDecoration: BoxDecoration(color: CoreColors.primary),
                        //defaultDecoration: BoxDecoration(color: CoreColors.primary),
                        rowDecoration: BoxDecoration(color: CoreColors.primary.withOpacity(0.8)),
                        defaultTextStyle: CoreTheme.semiBlackTextStyle.copyWith(
                          color: CoreColors.white
                        ),
                      ),
                      
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: CoreTheme.baseTextStyle.copyWith(
                          color: CoreColors.white,
                        ),
                        weekendStyle: CoreTheme.baseTextStyle.copyWith(
                          color: Colors.amber,
                        ),
                        decoration: BoxDecoration(
                          color: CoreColors.primary,
                        )
                        
                      ),
                      
                    ),
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
    return BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          
        },
        builder: (BuildContext context, CalendarState state) {
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
