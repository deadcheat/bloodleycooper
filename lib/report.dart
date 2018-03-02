import 'timing.dart';

class Report {
  const Report(
    this.day,
    this.timing,
    this.first,
    this.second,
  );

  final DateTime day;
  final Timing timing;
  final Measurement first;
  final Measurement second;

  Measurement average() {
    return new Measurement(
      ((this.first.minimal + this.second.minimal)/2).round(),
      ((this.first.maximal + this.second.maximal)/2).round(),
      ((this.first.pulse + this.second.pulse)/2).round());
  }
}

class Measurement {
  Measurement(
    this.maximal,
    this.minimal,
    this.pulse,
  );
  final int minimal; // diastolic
  final int maximal; // systolic
  final int pulse;
}