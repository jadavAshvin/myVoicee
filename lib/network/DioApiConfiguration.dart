import 'package:my_voicee/network/DioApiClient.dart';
import 'package:my_voicee/network/DioClient.dart';

class ApiDioConfiguration {
  final ConfigConfig config;
  static ApiDioConfiguration _configutation;
  final DioClient _apiClient;

  static void initialize(ConfigConfig config) {
    _createConfig(config);
  }

  static void _createConfig(ConfigConfig config) {
    if (_configutation != null) {}
    final client = DioApiClient.createGuestClient(
        config.nativeDeviceId, config.isLoggedIn);
    _configutation = ApiDioConfiguration._(config, DioClient.create(client));
  }

  static ApiDioConfiguration getInstance() {
    if (_configutation == null) {}
    return _configutation;
  }

  static void createNullConfiguration(ConfigConfig config) {
    _configutation = null;
    initialize(config);
  }

  ApiDioConfiguration._(this.config, this._apiClient);

  DioClient get apiClient => _apiClient;
}

class ConfigConfig {
  final String nativeDeviceId;
  bool isLoggedIn;

  ConfigConfig(this.nativeDeviceId, this.isLoggedIn);
}
