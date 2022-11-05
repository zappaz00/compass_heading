/// Consider that these samples may bear effects of Earth's magnetic field as
/// well as local factors such as the metal of the device itself or nearby
/// magnets, though most devices compensate for these factors.
class CompassHeadingEvent {
  /// Constructs an instance with the given [heading] value.
  CompassHeadingEvent(this.heading);

  /// heading in degrees (0-360)
  final double heading;

  @override
  String toString() => '[CompassHeadingEvent (heading: $heading)]';
}