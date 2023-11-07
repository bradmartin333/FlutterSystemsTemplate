import 'package:flutter_test/flutter_test.dart';
import 'package:oboe_ffi/oboe_ffi.dart';
import 'package:oboe_ffi/oboe_ffi_platform_interface.dart';
import 'package:oboe_ffi/oboe_ffi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOboeFfiPlatform
    with MockPlatformInterfaceMixin
    implements OboeFfiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OboeFfiPlatform initialPlatform = OboeFfiPlatform.instance;

  test('$MethodChannelOboeFfi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOboeFfi>());
  });

  test('getPlatformVersion', () async {
    OboeFfi oboeFfiPlugin = OboeFfi();
    MockOboeFfiPlatform fakePlatform = MockOboeFfiPlatform();
    OboeFfiPlatform.instance = fakePlatform;

    expect(await oboeFfiPlugin.getPlatformVersion(), '42');
  });
}
