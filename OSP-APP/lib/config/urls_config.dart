class URLSConfig {
  static Map<String, dynamic> config = {};
  static final Map<String, URLSConfig> _cache = {};

  URLSConfig._internal(Map<String, dynamic> cfg) {
    config = cfg;
  }

  factory URLSConfig(Map<String, dynamic> config) {
    late dynamic instance;

    if (_cache.containsKey('instance') && _cache['instance'] is URLSConfig) {
      instance = _cache['instance'];
    } else {
      instance = URLSConfig.set(config: config);
    }

    return instance is URLSConfig ? instance : URLSConfig.set(config: config);
  }

  factory URLSConfig.set({required Map<String, dynamic> config}) {
    return _cache.putIfAbsent('instance', () => URLSConfig._internal(config));
  }

  static String get api => config['api'];
  static String get web => config['web'];

}
