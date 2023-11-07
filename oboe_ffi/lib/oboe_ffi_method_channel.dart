import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'oboe_ffi_platform_interface.dart';

/// An implementation of [OboeFfiPlatform] that uses method channels.
class MethodChannelOboeFfi extends OboeFfiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('oboe_ffi');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
