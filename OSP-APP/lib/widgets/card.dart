import 'dart:ffi' hide Size;
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fox_core/components/general_views/home/model/bets.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fox_core/core/routes.dart';
import 'package:fox_core/widgets/buttons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:fox_core/core/helpers.dart';

class AdCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String buttonURL;
  final Image? backgroundImage;
  final String? backgroundImageURL;


  const AdCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonURL,
    this.backgroundImage,
    this.backgroundImageURL,
  });

  final double _radius = 27;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.languageCode;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: 185,
      width: screenWidth,
      child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Stack(
        children: [
          
            Container(
              height: 185,
              width: screenWidth,
                child: Image.asset( 
                  backgroundImageURL!, 
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppElevatedButton(
                        buttonText: buttonText, 
                        onClick: () => {buttonURL},
                        buttonStyle: AppElevatedButton.copyWithDefaultStyle(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8)
                        ),
                        ),
                        Text(
                          title,
                          style: CoreTheme.boldTextStyle.copyWith(
                            fontSize: 18,
                            color: CoreColors.white,
                          ),
                        ),
                        Text(
                        subtitle,
                        style: CoreTheme.baseTextStyle.copyWith(
                            fontSize: 13,
                            color: CoreColors.white.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
            ),
        ],
      ),
      ),
    );
  }
}