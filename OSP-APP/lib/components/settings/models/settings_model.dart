import 'dart:io';

import 'package:fox_core/api/api_response.dart';
import 'package:fox_core/api/v1/settings.dart';

class Store {
  String url = '';
  String apiVersion = '';
  bool forceUpdate = false;
}

class PublicUrls {
  String regulations = '';
  String privacyPolicy = '';
}


class PublicSettings {
  Store store = Store();
  PublicUrls urls = PublicUrls();

  Future<void> load() async {
    ApiResponse apiResponse = await SettingsApi().public();

    if (ApiResponseStatus.failure == apiResponse.status) {
      return;
    }

    purge();

    Map<String, dynamic> response = apiResponse.content;
    String platformKey = Platform.isIOS ? 'ios' : 'android';

    store.url = response['update'][platformKey]?['url'] ?? '';
    store.apiVersion = response['update'][platformKey]?['version'] ?? '-1';
    store.forceUpdate = response['update'][platformKey]?['force_update'] ?? false;

    urls.regulations = response['urls']?['regulations'] ?? '';
    urls.privacyPolicy = response['urls']?['privacy_policy'] ?? '';
  }

  void purge() {
    store = Store();
    urls = PublicUrls();
  }
}

class PrivateSettings {
  String storeLink = '';

  Future<void> load() async {
    ApiResponse apiResponse = await SettingsApi().private();
    if (ApiResponseStatus.failure == apiResponse.status) {
      return;
    }

    Map<String, dynamic> response = apiResponse.content;
  }
}