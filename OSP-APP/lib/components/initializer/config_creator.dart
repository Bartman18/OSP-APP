import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:osp/config/urls_config.dart';

class ConfigCreator {
  Map<String, dynamic> _urls = {};
  Map<String, dynamic> _onboarding = {};

  Future<void> run() async {
    _urls = await _loadURLSConfig();
    _onboarding = await _loadOnboardingConfig();

    await _initializeConfigs();
  }

  Future<void> _initializeConfigs() async {
    URLSConfig.set(config: _urls);
  }

  Future<Map<String, dynamic>> _loadURLSConfig() async {
    if (_urls.isNotEmpty) {
      return _urls;
    }

    String response = await rootBundle.loadString('config/urls.json');
    return await jsonDecode(response);
  }

  Future<Map<String, dynamic>> _loadOnboardingConfig() async {
    if (_onboarding.isNotEmpty) {
      return _onboarding;
    }

    String response = await rootBundle.loadString('config/onboarding.json');
    return await jsonDecode(response);
  }

}
