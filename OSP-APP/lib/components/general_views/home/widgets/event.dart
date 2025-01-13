import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:osp/components/general_views/home/model/event.dart';
import 'package:osp/core/appearance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:osp/core/routes.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:osp/core/helpers.dart';

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
  bool isStatOpen = false;



  @override
  Widget build(BuildContext context) {
    
    String locale = context.locale.languageCode;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return new GestureDetector(
        onTap: (){
          setState(() {
            isStatOpen = !isStatOpen;
          });
        },
        child: Column(
      children: [
        SizedBox(
          height:  90,
          width: screenWidth,
          child:  Stack(
            children: [
                Container(
                  height: 185,
                  width: screenWidth,
                      decoration: BoxDecoration(
                        color: CoreColors.primary
                      ),
                  ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 44,
                        child: FittedBox(
                          fit: BoxFit.contain,
                        child: Text(
                            event.title,
                            textAlign: TextAlign.left,
                            style: CoreTheme.boldTextStyle.copyWith(
                              
                              color: CoreColors.white,
                              //fontSize: 32,
                            ),
                        ),
                          ),
                        ),
                        const SizedBox(height: 5), Text(
                            DateFormat("dd.MM.yyyy").format(event.eventDate),
                            
                            style: CoreTheme.baseTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 10,
                            ),
                          ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 155,
                    alignment: Alignment.center,
                    
                      decoration: BoxDecoration(
                        color: CoreColors.gray.withAlpha(40),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    
                      
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ Text(
                            "Ilość osób "+ "1/"+event.personLimit.toString(),
                            
                            style: CoreTheme.baseTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
              
              
              ),
            ],
          ),
        ),
        if (isStatOpen)
        
        
          Container(
            height: 200,
          decoration: BoxDecoration(
            color: CoreColors.primary.withOpacity(0.8),
          ),
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Miejsce:",
                  style: CoreTheme.baseTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 16,
                            ),),
                Container(
                  child: Text(
                    event.place,
                    style: CoreTheme.thinTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 16,
                            ),),
                ),
                Container(
                  height: 90,
                  child: Text(
                    "Opis: " + event.description,
                    style: CoreTheme.thinTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 16,
                            ),),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {}, 
                      child: Text("Dołącz",
                      style: CoreTheme.thinTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 16,
                            ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(CoreColors.primary),
                        foregroundColor: WidgetStatePropertyAll(CoreColors.primary),
                      )
                      ),
                    ElevatedButton(
                      onPressed: () {}, 
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor: WidgetStatePropertyAll(Colors.transparent),
                        shadowColor:  WidgetStatePropertyAll(Colors.transparent),
                      ),
                    child: Text("Zrezygnuj",
                    style: CoreTheme.thinTextStyle.copyWith(
                              color: CoreColors.white,
                              fontSize: 16,
                            ),)
                    ),
                  ],
                )
            
              ],
            )
          ),
          ),
        
        SizedBox(height: 10,)
      ],
        
    ),
    );
  }
}