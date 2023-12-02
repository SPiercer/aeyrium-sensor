import 'dart:async';

import 'package:flutter/services.dart';

const EventChannel _sensorEventChannel =
    EventChannel('plugins.aeyrium.com/sensor');

class SensorEvent {
  /// Pitch from the device in radians
  /// A pitch is a rotation around a lateral (X) axis that passes through the device from side to side
  final double pitchX;

  ///Roll value from the device in radians
  ///A roll is a rotation around a longitudinal (Y) axis that passes through the device from its top to bottom
  final double rollY;

  //Azimuth value from the device in radians
  //An azimuth is a rotation around a vertical (Z) axis that passes through the device from top to bottom
  final double azimuthZ;

  SensorEvent(this.pitchX, this.rollY, this.azimuthZ);

  @override
  String toString() =>
      '[Event: (pitch: $pitchX, roll: $rollY, azimuth: $azimuthZ)]';
}

class AeyriumSensor {
  static late Stream<SensorEvent> _sensorEvents;

  AeyriumSensor._();

  /// A broadcast stream of events from the device rotation sensor.
  static Stream<SensorEvent> get sensorEvents {
    _sensorEvents = _sensorEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => _listToSensorEvent(event.cast<double>()));

    return _sensorEvents;
  }

  static SensorEvent _listToSensorEvent(List<double> list) {
    return SensorEvent(
      list[0],
      list[1],
      list[2],
    );
  }
}
