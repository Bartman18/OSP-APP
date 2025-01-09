import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Zodiac {
  static String zodiacSolver({required DateTime date, bool translate = false}) {
    String sign = 'N/A';

    switch (date.month) {
      case 1:
        if (21 > date.day) {
          sign = 'capricorn';
        } else {
          sign = 'aquarius';
        }
      case 2:
        if (20 > date.day) {
          sign = 'aquarius';
        } else {
          sign = 'pisces';
        }
      case 3:
        if (21 > date.day) {
          sign = 'pisces';
        } else {
          sign = 'aries';
        }
      case 4:
        if (21 > date.day) {
          sign = 'aries';
        } else {
          sign = 'taurus';
        }
      case 5:
        if (22 > date.day) {
          sign = 'taurus';
        } else {
          sign = 'gemini';
        }
      case 6:
        if (22 > date.day) {
          sign = 'gemini';
        } else {
          sign = 'cancer';
        }
      case 7:
        if (24 > date.day) {
          sign = 'cancer';
        } else {
          sign = 'leo';
        }
      case 8:
        if (24 > date.day) {
          sign = 'leo';
        } else {
          sign = 'virgo';
        }
      case 9:
        if (24 > date.day) {
          sign = 'virgo';
        } else {
          sign = 'libra';
        }
      case 10:
        if (24 > date.day) {
          sign = 'libra';
        } else {
          sign = 'scorpio';
        }
      case 11:
        if (23 > date.day) {
          sign = 'scorpio';
        } else {
          sign = 'sagittarius';
        }
      case 12:
        if (23 > date.day) {
          sign = 'sagittarius';
        } else {
          sign = 'capricorn';
        }
    }

    return translate
        ? 'N/A' != sign ? 'zodiac.$sign'.tr() : sign
        : sign;
  }

  static List<String> get getZodiacs => [
    'capricorn',
    'aquarius',
    'pisces',
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius'
  ];

  static Widget getZodiacSymbol(String sign, {double width = 130}) {
    return SvgPicture.asset(
      'assets/zodiac/$sign.svg',
      width: width,
    );
  }

}