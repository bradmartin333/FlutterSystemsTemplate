import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'oboe_ffi_method_channel.dart';

abstract class OboeFfiPlatform extends PlatformInterface {
  /// Constructs a OboeFfiPlatform.
  OboeFfiPlatform() : super(token: _token);

  static final Object _token = Object();

  static OboeFfiPlatform _instance = MethodChannelOboeFfi();

  /// The default instance of [OboeFfiPlatform] to use.
  ///
  /// Defaults to [MethodChannelOboeFfi].
  static OboeFfiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OboeFfiPlatform] when
  /// they register themselves.
  static set instance(OboeFfiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
