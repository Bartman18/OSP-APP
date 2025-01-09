import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fox_core/components/general_views/home/model/event.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fox_core/core/routes.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:fox_core/core/helpers.dart';

class Event extends StatefulWidget {
  final EventModel event;

  const Event({
    super.key,
    required this.event,
  });
  
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {

final double _radius = 10;

late EventModel event;

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    String locale = context.locale.languageCode;
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isStatOpen = false;
    return SizedBox(
      height: isStatOpen ? 300 : 185,
      width: screenWidth,
      child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Stack(
        children: [
          
            Container(
              height: 185,
              width: screenWidth,
                child: Image.asset(
                  'assets/placeholder/stadion.png',
                  fit: BoxFit.cover,
                ),
              ),
            Container(
              height: 185,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [CoreColors.black.withOpacity(0), CoreColors.black.withOpacity(1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  )
              ),
            ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "",//DateFormat("dd MMMM, HH:mm").format(date),
                  
                  style: CoreTheme.baseTextStyle.copyWith(
                    color: CoreColors.white,
                    fontSize: 10,
                  ),
                ),
          ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                            color: CoreColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Nasalization",
                          ),
                        ),
                        
                      ],
                    ),
                    const Spacer(flex: 1,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "match.team2.name,",
                          style: TextStyle(
                            color: CoreColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Nasalization",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: CoreColors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                        ),
                        const Spacer(flex: 1,),
                    SizedBox(width: 5,),
                    Text(
                      "VS",
                      style: CoreTheme.baseTextStyle.copyWith(
                        color: CoreColors.white.withOpacity(0.5),
                        fontFamily: "Nasalization",
                        fontSize: 13,
                      ),
                      ),
                    SizedBox(width: 5,),
                    
                        const Spacer(flex: 1,),

                     Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: CoreColors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
          //),
        ],
      ),
      ),
    );
  }
}