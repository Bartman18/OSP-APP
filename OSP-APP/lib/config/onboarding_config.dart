class OnboardingConfig {
  static Map<String, dynamic> config = {};
  static final Map<String, OnboardingConfig> _cache = {};

  OnboardingConfig._internal(Map<String, dynamic> cfg) {
    config = cfg;
  }

  factory OnboardingConfig(Map<String, dynamic> config) {
    late dynamic instance;

    if (_cache.containsKey('instance') && _cache['instance'] is OnboardingConfig) {
      instance = _cache['instance'];
    } else {
      instance = OnboardingConfig.set(config: config);
    }

    return instance is OnboardingConfig ? instance : OnboardingConfig.set(config: config);
  }

  factory OnboardingConfig.set({required Map<String, dynamic> config}) {
    return _cache.putIfAbsent('instance', () => OnboardingConfig._internal(config));
  }

  static int get pages => config['pages'] ?? 1;

}
