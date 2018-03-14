import 'timing.dart';

class Report {
  const Report(
    this.id,
    this.day,
    this.timing,
    this.first,
    this.second,
  );
  final int id;
  final DateTime day;
  final Timing timing;
  final Measurement first;
  final Measurement second;

  Measurement average() {
    return new Measurement(
        ((this.first.minimal + this.second.minimal) / 2).round(),
        ((this.first.maximal + this.second.maximal) / 2).round(),
        ((this.first.pulse + this.second.pulse) / 2).round());
  }

  Map toMap() {
    Map map = {
      "date": day,
      "timing": timing.toCode(),
      "first_min": first.minimal,
      "first_max": first.maximal,
      "first_pul": first.pulse,
      "second_min": second.minimal,
      "second_max": second.maximal,
      "second_pul": second.pulse,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
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
