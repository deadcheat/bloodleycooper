import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:bloodpit/addreport.dart';
import 'package:bloodpit/report.dart';
import 'package:bloodpit/timing.dart';
import 'package:square_calendar/square_calendar.dart';
import 'package:bloodpit/database.dart';
import 'package:bloodpit/converter.dart';

void main() => runApp(new BloodPit());

class BloodPit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BloodPit',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new Reports(),
    );
  }
}

class Reports extends StatefulWidget {
  @override
  createState() => new ReportsState();
}

class ReportsState extends State<Reports> {
  ReportsState() {
    _findReportsByYYYMM(_displayDate.year, _displayDate.month)
        .then((dynamic) => _weekDataChange());
  }
  var _displayingReports = new List<Report>();
  var _monthReports = new Map<int, List<Report>>();
  final _provider = new ReportDBProvider();

  DateTime _displayDate = new DateTime.now();

  void _addReport(Report r) {
    final date = r.date;
    final key = BPConverter.yyyyMMDDtoInt(date.year, date.month, date.day);
    if (_displayDate.year == date.year && _displayDate.month == date.month) {
      setState(() {
        _displayDate = date;
        _displayingReports = getListFromMap(date);
        _displayingReports.add(r);
        _monthReports[key] = _displayingReports;
      });
    } else {
      _findReportsByYYYMM(_displayDate.year, _displayDate.month)
          .then((dynamic) {
        setState(() {
          _displayDate = date;
          _displayingReports = getListFromMap(date);
          _displayingReports.add(r);
          _monthReports[key] = _displayingReports;
        });
      });
    }
  }

  void _weekDataChange() {
    setState(() {
      _displayingReports = getListFromMap(_displayDate);
    });
  }

  void _dismissReport(Report r) {
    final date = r.date;
    final key = BPConverter.yyyyMMDDtoInt(date.year, date.month, date.day);
    setState(() {
      _displayingReports.remove(r);
      _monthReports[key] = _displayingReports;
    });
  }

  void _changeMonth(int diff) {
    _displayDate = new DateTime(
        _displayDate.year, _displayDate.month + diff, _displayDate.day);
    _findReportsByYYYMM(_displayDate.year, _displayDate.month)
        .then((dynamic) => _weekDataChange());
  }

  List<Report> getListFromMap(DateTime date) {
    final key = BPConverter.yyyyMMDDtoInt(date.year, date.month, date.day);
    if (_monthReports == null || _monthReports[key] == null) {
      return new List<Report>();
    }
    return _monthReports[key];
  }

  Future _findReportsByYYYMM(num year, num month) async {
    await _provider.openDB();
    try {
      final result = await _provider.findReports(year, month);
      _monthReports = result;
      if (_monthReports == null) {
        _monthReports = new Map<int, List<Report>>();
      }
    } finally {
      await _provider.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BloodPit'),
      ),
      body: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Container(
                alignment: Alignment.bottomLeft,
                height: 50.0,
                child: new IconButton(
                  highlightColor: Colors.lightGreen[300],
                  splashColor: Colors.lightGreen[100],
                  icon: const Icon(Icons.arrow_left),
                  tooltip: 'Previous Month',
                  onPressed: () => _changeMonth(-1),
                ),
              ),
              new Container(
                alignment: Alignment.center,
                height: 50.0,
                child: new Text(new DateFormat.yMMM().format(_displayDate),
                    style: new TextStyle(fontSize: 20.0)),
              ),
              new Container(
                alignment: Alignment.bottomLeft,
                height: 50.0,
                child: new IconButton(
                  highlightColor: Colors.lightGreen[300],
                  splashColor: Colors.lightGreen[100],
                  icon: const Icon(Icons.arrow_right),
                  tooltip: 'Next Month',
                  onPressed: () => _changeMonth(1),
                ),
              ),
            ],
          ),
          new Expanded(
            flex: 7,
            child: new Container(
              child: new SquareCalendar(
                year: _displayDate.year,
                month: _displayDate.month,
                gestureBuilder: (child, int, date, base, first, last) {
                  final color = (_isSameDate(date, _displayDate))
                      ? Colors.lightGreen[100]
                      : Colors.transparent;
                  return new Material(
                    color: color,
                    child: new InkWell(
                      splashFactory: InkSplash.splashFactory,
                      highlightColor: Colors.lightGreen[300],
                      splashColor: Colors.lightGreen[100],
                      child: child,
                      onTap: () {
                        _displayDate = date;
                        _weekDataChange();
                      },
                    ),
                  );
                },
                widgetBuilder: (int, date, base, first, last) {
                  var textStyle = new TextStyle(fontWeight: FontWeight.bold);
                  if (base != null && date.month != base.month) {
                    textStyle = textStyle.apply(color: Colors.grey);
                  } else {
                    switch (date.weekday) {
                      case 7:
                        textStyle = textStyle.apply(color: Colors.red);
                        break;
                      case 6:
                        textStyle = textStyle.apply(color: Colors.blue);
                        break;
                      default:
                    }
                  }
                  final dayReports = getListFromMap(date);
                  var hasMorning = false;
                  var hasEvening = false;

                  dayReports.forEach((r) {
                    if (!hasMorning && r.timing == Timing.MORNING) {
                      hasMorning = true;
                    } else if (!hasEvening && r.timing == Timing.EVENING) {
                      hasEvening = true;
                    }
                  });
                  final timingIcons = new List<Widget>();
                  final circleRadius = 8.5;
                  if (hasMorning) {
                    timingIcons.add(new CircleAvatar(
                      radius: circleRadius,
                      backgroundColor: Colors.lightBlue,
                    ));
                  } else {
                    timingIcons.add(new CircleAvatar(
                      radius: circleRadius,
                      backgroundColor: Colors.transparent,
                    ));
                  }
                  if (hasEvening) {
                    timingIcons.add(new CircleAvatar(
                      radius: circleRadius,
                      backgroundColor: Colors.deepOrangeAccent,
                    ));
                  }
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text(
                        date.day.toString(),
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: timingIcons),
                    ],
                  );
                },
              ),
            ),
          ),
          new Divider(
            color: Colors.green,
            height: 16.0,
          ),
          new Expanded(
            flex: 5,
            child: _buildReports(context),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Report r =
              await Navigator.of(context).push(new MaterialPageRoute<Report>(
                  builder: (BuildContext context) {
                    bool hasMorning = false;
                    if (!_isSameDate(_displayDate, new DateTime.now())) {
                      _displayingReports.forEach((r) {
                        if (!hasMorning && r.timing == Timing.MORNING) {
                          hasMorning = true;
                        }
                      });
                    }
                    return new AddReportDialog(
                      _displayDate.year,
                      _displayDate.month,
                      _displayDate.day,
                      hasMorning,
                    );
                  },
                  fullscreenDialog: true));
          if (r == null) {
            return;
          }
          await _provider.openDB();
          final report = await _provider.addReport(r);
          _addReport(report);
          await _provider.close();
        },
        tooltip: 'Add Record',
        child: new Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _isSameDate(DateTime src, DateTime dest) {
    return (src.year == dest.year &&
        src.month == dest.month &&
        src.day == dest.day);
  }

  Widget _buildReports(BuildContext context) {
    const defaultPadding = 16.0;
    return new ListView.builder(
      itemCount: (_displayingReports == null) ? 0 : _displayingReports.length,
      padding: const EdgeInsets.fromLTRB(
          defaultPadding, 0.0, defaultPadding, defaultPadding),
      itemBuilder: (context, int i) {
        return _buildLine(context, this._displayingReports[i]);
      },
    );
  }

  Widget _buildLine(BuildContext context, Report r) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
    return new Dismissible(
      key: new ObjectKey(r),
      child: new Column(
        children: <Widget>[
          _buildRow(r),
          new Divider(
            height: 6.0,
          ),
        ],
      ),
      direction: DismissDirection.endToStart,
      background: new Container(),
      onDismissed: (d) async {
        bool discarded = await showDialog<bool>(
          context: context,
          child: new AlertDialog(
              content: new Text("Delete a selected report, OK?",
                  style: dialogTextStyle),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      final date = r.date;
                      final key = BPConverter.yyyyMMDDtoInt(
                          date.year, date.month, date.day);
                      _displayingReports = _monthReports[key];
                      Navigator.pop(context, false);
                    }),
                new FlatButton(
                    child: const Text('DISCARD'),
                    onPressed: () async {
                      await _provider.openDB();
                      await _provider.delete(r.id);
                      await _provider.close();
                      Navigator.pop(context, true);
                    })
              ]),
        );
        if (discarded) {
          _dismissReport(r);
          Scaffold.of(context).showSnackBar(new SnackBar(
                backgroundColor: Colors.blue[800],
                content: new Text(
                  'Discarded a report successfully',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ));
        } else {
          setState(() {});
        }
      },
      secondaryBackground: new Container(
          color: Colors.redAccent,
          child: const ListTile(
              trailing:
                  const Icon(Icons.delete, color: Colors.white, size: 36.0))),
    );
  }

  Widget _buildRow(Report r) => new ListTile(
        leading: new Container(
          child: new CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: (r.timing == Timing.EVENING)
                ? Colors.deepOrangeAccent
                : Colors.lightBlue,
            child: new Text(
              '${r.date.month.toString()}/${r.date.day.toString()}',
              style: new TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: new Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
            new Text(
              r.average().maximal.toString(),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.blue,
                child: new Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ),
            new Text(
              r.average().minimal.toString(),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                child: new Icon(Icons.favorite, color: Colors.white),
              ),
            ),
            new Text(
              r.average().pulse.toString(),
            ),
          ],
        ),
      );
}
