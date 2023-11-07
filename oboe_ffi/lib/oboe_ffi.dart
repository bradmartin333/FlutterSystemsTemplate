
import 'oboe_ffi_platform_interface.dart';

class OboeFfi {
  Future<String?> getPlatformVersion() {
    return OboeFfiPlatform.instance.getPlatformVersion();
  }
}
