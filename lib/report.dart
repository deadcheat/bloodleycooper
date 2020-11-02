import 'timing.dart';
import 'package:bloodleycooper/Converter.dart';

class Report {
  const Report(
    this.id,
    this.date,
    this.timing,
    this.first,
    this.second,
  );
  final int id;
  final DateTime date;
  final Timing timing;
  final Measurement first;
  final Measurement second;

  Measurement average() {
    return new Measurement(
        ((this.first.maximal + this.second.maximal) / 2).round(),
        ((this.first.minimal + this.second.minimal) / 2).round(),
        ((this.first.pulse + this.second.pulse) / 2).round());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date.millisecondsSinceEpoch,
      'year': date.year,
      'month': date.month,
      'day': date.day,
      'timing': timing.toCode(),
      'first_min': first.minimal,
      'first_max': first.maximal,
      'first_pul': first.pulse,
      'second_min': second.minimal,
      'second_max': second.maximal,
      'second_pul': second.pulse,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Map<int, List<Report>> fromMap(List<Map> data) {
    Map<int, List<Report>> result = new Map<int, List<Report>>();
    data.forEach((value) {
      Report r = new Report(
        value["id"],
        new DateTime.fromMillisecondsSinceEpoch(value["date"]),
        new Timing(value: value["timing"]),
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
      int key =
          BPConverter.yyyyMMDDtoInt(r.date.year, r.date.month, r.date.day);
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
