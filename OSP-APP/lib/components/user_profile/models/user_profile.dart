import 'dart:convert';

import 'package:fox_core/components/user_profile/models/user_fridge_model.dart';
import 'package:fox_core/components/user_profile/models/user_score_model.dart';
import 'package:fox_core/core/settings_dict.dart';

class AppleIntegration {
  final String id;

  const AppleIntegration({required this.id});

  Map<String, dynamic> toJSON() {
    return {'id': id};
  }

  factory AppleIntegration.fromJSON(Map<String, dynamic> data) {
    return AppleIntegration(id: data['id'] ?? '');
  }
}

class GoogleIntegration {
  final String mail;

  const GoogleIntegration({required this.mail});

  Map<String, dynamic> toJSON() {
    return {'mail': mail};
  }

  factory GoogleIntegration.fromJSON(Map<String, dynamic> data) {
    return GoogleIntegration(mail: data['mail'] ?? '');
  }
}

class UserIntegrations {
  AppleIntegration? apple;
  GoogleIntegration? google;

  UserIntegrations();

  bool get hasGoogleIntegration => google is GoogleIntegration;
  bool get hasAppleIntegration => apple is AppleIntegration;
  bool get hasFacebookIntegration => apple is AppleIntegration;

  Map<String, dynamic> toJSON() {
    return {
      'apple': apple?.toJSON(),
      'google': google?.toJSON(),
    };
  }

  factory UserIntegrations.fromJSON(Map<String, dynamic> data) {
    UserIntegrations instance = UserIntegrations();

    if (null != data['apple']) {
      instance.apple = AppleIntegration.fromJSON(data);
    }

    if (null != data['google']) {
      instance.google = GoogleIntegration.fromJSON(data);
    }

    return instance;
  }

  factory UserIntegrations.fromApiResponse(Map<String, dynamic> data) {
    UserIntegrations instance = UserIntegrations();

    if (data['integrations'].isEmpty) {
      return instance;
    }

    for (Map<String, dynamic> integration in data['integrations']) {
      String type = integration['integration'] ?? '-1';
      Map<String, dynamic> details =
          integration['details'] is String ? (jsonDecode(integration['details']) ?? '{}') : {};

      switch (type) {
        case 'google':
          instance.google = GoogleIntegration.fromJSON(details);
          break;
        case 'apple':
          instance.apple = AppleIntegration.fromJSON(details);
          break;
      }
    }

    return instance;
  }
}

class UserProfileModel {
  UserIntegrations? integrations;
  int id;
  String name;
  String profilePicture;
  String email;
  int? currentTeamId;
  String? profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? twoFactorConfirmedAt;
  UserFridgeModel? fridge;
  UserScoreModel? score;

  bool notifications;

  UserProfileModel({
    this.id = -1,
    this.name = '',
    this.profilePicture = '',
    this.email = '',
    this.integrations,
    this.notifications = DefaultSettingsDictionary.notifications,
    this.currentTeamId = -1,
    this.profilePhotoPath = '',
    this.createdAt,
    this.updatedAt,
    this.twoFactorConfirmedAt,
    this.fridge,
    this.score,
  }) {
    integrations ??= UserIntegrations();
  }

  factory UserProfileModel.fromJSON(Map<String, dynamic> data) {
    UserProfileModel userProfile = UserProfileModel(
      id: data['id'] ?? -1,
      name: data['name'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      email: data['email'] ?? '',
      notifications: data['notifications'] ?? DefaultSettingsDictionary.notifications,
      currentTeamId: data['currentTeamId'] ?? -1,
      profilePhotoPath: data['profilePhotoPath'] ?? '',
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      twoFactorConfirmedAt: data['twoFactorConfirmedAt'] != null
          ? DateTime.parse(data['twoFactorConfirmedAt'])
          : null,
      fridge: data['fridge'] != null ? UserFridgeModel.fromJson(data['fridge']) : null,
      score: data['score'] != null ? UserScoreModel.fromJson(data['score']) : null,
    );

    userProfile.notifications = (data['notifications'] ?? DefaultSettingsDictionary.notifications);
    return userProfile;
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'integrations': integrations?.toJSON(),
      'notifications': notifications,
    };
  }

  void loadFromApiResponse(Map<String, dynamic> response) {
    purgeModel();

    id = response['id'] ?? -1;
    name = response['name'] ?? '';
    profilePicture = response['profile_photo_url'] ?? '';
    notifications = response['profile']['notifications'] ?? DefaultSettingsDictionary.notifications;
  }

  void purgeModel() {
    id = -1;
    name = '';
    email = '';
    profilePicture = '';
    notifications = DefaultSettingsDictionary.notifications;
  }
}
