
import 'package:compass_heading/compass_heading_event.dart';

import 'compass_heading_platform_interface.dart';

class CompassHeading {
  Future<String?> getPlatformVersion() {
    return CompassHeadingPlatform.instance.getPlatformVersion();
  }

  /// A broadcast stream of events from the device accelerometer and magnetometer.
  Stream<CompassHeadingEvent> get compassHeadingEvents {
    return CompassHeadingPlatform.instance.compassHeadingEvents;
  }
}
