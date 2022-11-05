import 'package:compass_heading/compass_heading_event.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compass_heading/compass_heading.dart';
import 'package:compass_heading/compass_heading_platform_interface.dart';
import 'package:compass_heading/compass_heading_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCompassHeadingPlatform
    with MockPlatformInterfaceMixin
    implements CompassHeadingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<CompassHeadingEvent> get compassHeadingEvents => Stream.value(CompassHeadingEvent(1.0));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final CompassHeadingPlatform initialPlatform = CompassHeadingPlatform.instance;

  test('$MethodChannelCompassHeading is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCompassHeading>());
  });

  test('getPlatformVersion', () async {
    CompassHeading compassHeadingPlugin = CompassHeading();
    MockCompassHeadingPlatform fakePlatform = MockCompassHeadingPlatform();
    CompassHeadingPlatform.instance = fakePlatform;

    expect(await compassHeadingPlugin.getPlatformVersion(), '42');
  });

  test('${CompassHeadingPlatform.instance.compassHeadingEvents} are streamed', () async {
    const channelName = 'dev.compass_heading/compass_heading';
    const sensorData = <double>[1.0];
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await CompassHeadingPlatform.instance.compassHeadingEvents.first;

    expect(event.heading, sensorData[0]);
  });
}

void _initializeFakeSensorChannel(String channelName, List<double> sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}