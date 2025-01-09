class SubscriptionSteps {
  static Map<String, dynamic> config = {};
  static final Map<String, SubscriptionSteps> _cache = {};

  SubscriptionSteps._internal(Map<String, dynamic> cfg) {
    config = cfg;
  }

  factory SubscriptionSteps(Map<String, dynamic> config) {
    late dynamic instance;

    if (_cache.containsKey('instance') && _cache['instance'] is SubscriptionSteps) {
      instance = _cache['instance'];
    } else {
      instance = SubscriptionSteps.set(config: config);
    }

    return instance is SubscriptionSteps ? instance : SubscriptionSteps.set(config: config);
  }

  factory SubscriptionSteps.set({required Map<String, dynamic> config}) {
    return _cache.putIfAbsent('instance', () => SubscriptionSteps._internal(config));
  }

  static int get pages => config['steps'] ?? 5;

}
