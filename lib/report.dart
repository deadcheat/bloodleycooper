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
        ((this.first.maximal + this.second.maximal) / 2).round(),
        ((this.first.minimal + this.second.minimal) / 2).round(),
        ((this.first.pulse + this.second.pulse) / 2).round());
  }

  int mapKey() {
    DateTime d = this.day;
    return (d.year * 1000) + (d.month * 10) + (d.day);
  }

  Map toMap() {
    Map map = {
      "date": day.millisecondsSinceEpoch,
      "year": day.year,
      "month": day.month,
      "day": day.day,
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

  static Map<int, List<Report>> fromMap(List<Map> data) {
    Map<int, List<Report>> result = new Map<int, List<Report>>();
    data.forEach((value) {
      Report r = new Report(
        value["id"],
        value["day"],
        value["timing"],
        new Measurement(
          value["first_max"],
          value["first_min"],
          value["first_pul"],
        ),
        new Measurement(
          value["second_max"],
          value["second_min"],
          value["second_pul"],
        ),
      );
      int key = r.mapKey();
      if (result.containsKey(key)) {
        result[key].add(r);
      } else {
        List<Report> list = new List<Report>();
        list.add(r);
        result[key] = list;
      }
    });
    return result;
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
