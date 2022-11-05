import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compass_heading/compass_heading_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCompassHeading platform = MethodChannelCompassHeading();
  const MethodChannel channel = MethodChannel('compass_heading');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
