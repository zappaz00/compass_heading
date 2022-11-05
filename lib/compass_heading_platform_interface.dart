import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'compass_heading_method_channel.dart';
import 'compass_heading_event.dart';

abstract class CompassHeadingPlatform extends PlatformInterface {
  /// Constructs a CompassHeadingPlatform.
  CompassHeadingPlatform() : super(token: _token);

  static final Object _token = Object();

  static CompassHeadingPlatform _instance = MethodChannelCompassHeading();

  /// The default instance of [CompassHeadingPlatform] to use.
  ///
  /// Defaults to [MethodChannelCompassHeading].
  static CompassHeadingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CompassHeadingPlatform] when
  /// they register themselves.
  static set instance(CompassHeadingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// A broadcast stream of events from the device accelerometer.
  Stream<CompassHeadingEvent> get compassHeadingEvents {
    throw UnimplementedError('compassHeadingEvents has not been implemented.');
  }
}
