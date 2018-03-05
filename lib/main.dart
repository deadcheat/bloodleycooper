import 'package:bloodpit/addreport.dart';
import 'package:flutter/material.dart';
import 'package:bloodpit/report.dart';
import 'package:bloodpit/timing.dart';

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

class ReportFinder {
  final _reports = <Report>[];
  List<Report> find() {
    _reports.add(new Report(
      new DateTime.now(),
      Timing.EVENING,
      new Measurement(135, 85, 78),
      new Measurement(145, 85, 78),
    ));
    _reports.add(new Report(
      new DateTime.now().subtract(new Duration(days: 1)),
      Timing.EVENING,
      new Measurement(135, 85, 78),
      new Measurement(145, 85, 78),
    ));
    return _reports;
  }
}

class ReportsState extends State<Reports> {
  final _reports = new ReportFinder().find();

  void _addReport() {
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BloodPit'),
      ),
      body: _buildReports(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new AddReportDialog();
              },
              fullscreenDialog: true));
        },
        tooltip: 'Add Record',
        child: new Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildReports() {
    return new ListView.builder(
      itemCount: _reports.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, int i) {
        return _buildLine(this._reports[i]);
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
            child:
                new Text('${r.day.month.toString()}/${r.day.day.toString()}'),
          ),
        ),
        title: new Row(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                child: new Text('S'),
              ),
            ),
            new Text(
              r.average().maximal.toString(),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                child: new Text('D'),
              ),
            ),
            new Text(
              r.average().minimal.toString(),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              child: new CircleAvatar(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                child: new Text('P'),
              ),
            ),
            new Text(
              r.average().pulse.toString(),
            ),
          ],
        ),
      );
}
