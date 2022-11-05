import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'compass_heading_event.dart';
import 'compass_heading_platform_interface.dart';

/// An implementation of [CompassHeadingPlatform] that uses method channels.
class MethodChannelCompassHeading extends CompassHeadingPlatform {
  final Stream<CompassHeadingEvent> _compassHeadingEvents = const Stream.empty();
  final StreamController<CompassHeadingEvent> _compassHeadingController = StreamController<CompassHeadingEvent>();
  AccelerometerEvent _accelerometerEvent = AccelerometerEvent(0.0, 0.0, 0.0);

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('compass_heading');

  MethodChannelCompassHeading(){
    _compassHeadingController.addStream(_compassHeadingEvents);
    accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerEvent = event;
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      final accDotMag = _accelerometerEvent.x * event.x + 
                        _accelerometerEvent.y * event.y + 
                        _accelerometerEvent.z * event.z;
                        
      final accNorm = _accelerometerEvent.x * _accelerometerEvent.x + 
                      _accelerometerEvent.y * _accelerometerEvent.y + 
                      _accelerometerEvent.z * _accelerometerEvent.z;

      final correctedX = event.x - _accelerometerEvent.x * accDotMag / accNorm;
      final correctedY = event.y - _accelerometerEvent.y * accDotMag / accNorm;
      // final correctedZ = event.z - _accelerometerEvent.z * accDotMag / accNorm;

      double heading = atan2(correctedY, correctedX) * 180.0 / pi;
      if(heading < 0.0) heading += 360.0;
      
      _compassHeadingController.add(CompassHeadingEvent(heading));
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<CompassHeadingEvent> get compassHeadingEvents {
    return _compassHeadingEvents;
  }
}
