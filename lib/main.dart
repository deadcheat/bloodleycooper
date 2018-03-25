import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:bloodpit/addreport.dart';
import 'package:bloodpit/report.dart';
import 'package:bloodpit/timing.dart';
import 'package:square_calendar/square_calendar.dart';
import 'package:bloodpit/database.dart';
import 'package:bloodpit/Converter.dart';

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
    setState(() {
      _displayDate = r.date;
      final key =
          BPConverter.yyyyMMDDtoInt(r.date.year, r.date.month, r.date.day);
      _displayingReports = _monthReports[key];
      if (_displayingReports == null) {
        _displayingReports = new List<Report>();
        _monthReports[key] = _displayingReports;
      }
      _displayingReports.add(r);
    });
  }

  void _weekDataChange() {
    setState(() {
      _displayingReports = _monthReports[BPConverter.yyyyMMDDtoInt(
          _displayDate.year, _displayDate.month, _displayDate.day)];
      if (_displayingReports == null) {
        _displayingReports = new List<Report>();
      }
    });
  }

  Future _findReportsByYYYMM(num year, num month) async {
    await _provider.openDB();
    try {
      final result = await _provider.findReports(year, month);
      _monthReports = result;
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
      // body: _buildReports(),
      body: new Column(
        children: <Widget>[
          new Text(new DateFormat.yMMM().format(_displayDate)),
          new Expanded(
            child: new SquareCalendar(
              year: _displayDate.year,
              month: _displayDate.month,
              gestureBuilder: (child, int, date, base, first, last) {
                return new GestureDetector(
                  child: child,
                  onTap: () {
                    _displayDate = date;
                    _weekDataChange();
                  },
                );
              },
            ),
          ),
          new Expanded(
            child: _buildReports(),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Report r =
              await Navigator.of(context).push(new MaterialPageRoute<Report>(
                  builder: (BuildContext context) {
                    return new AddReportDialog();
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

  Widget _buildReports() {
    return new ListView.builder(
      itemCount: (_displayingReports == null) ? 0 : _displayingReports.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, int i) {
        return _buildLine(this._displayingReports[i]);
      },
    );
  }

  Widget _buildLine(Report r) => new Column(
        children: <Widget>[
          _buildRow(r),
          new Divider(
            height: 10.0,
          ),
        ],
      );

  Widget _buildRow(Report r) => new ListTile(
        leading: new Container(
          child: new CircleAvatar(
            child: new Text(
              '${r.date.month.toString()}/${r.date.day.toString()}',
              style: new TextStyle(fontSize: 12.0),
              // DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.4),
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
