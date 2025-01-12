import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:fox_core/core/translatable.dart';

class EventModel {
  final int id;
  final String title;
  final DateTime eventDate;
  final String place;
  final String type;
  final String description;
  final int personLimit;
  final bool eventConfirmed;
  final int userId;

  EventModel({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.place,
    required this.type,
    required this.description,
    required this.personLimit,
    required this.eventConfirmed,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['event_id'] ?? 0,
      title: json['title'] ?? "",
      eventDate: DateTime.parse(json['event_date']),
      place: json['place'] ?? "",
      type: json['type'] ?? "",
      description: json['description'] ?? "",
      personLimit: json['person_limit'] ?? 0,
      eventConfirmed: json['event_confirmed'] ?? false,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': id,
      'title': title,
      'event_date': eventDate.toIso8601String(),
      'place': place,
      'type': type,
      'description': description,
      'person_limit': personLimit,
      'event_confirmed': eventConfirmed,
      'user_id': userId
    };
  }
}
