import 'package:flutter/material.dart';

class AddReportDialog extends StatefulWidget {
  @override
  AddReportDialogState createState() => new AddReportDialogState();
}

class AddReportDialogState extends State<AddReportDialog> {
  final formKey = new GlobalKey<FormState>();
  double _first_diastolic = 135.0;
  double _first_systolic = 85.0;
  double _first_pulse = 80.0;
  double _second_diastolic = 135.0;
  double _second_systolic = 85.0;
  double _second_pulse = 80.0;
  int _timing = 0;
  DateTime _date = new DateTime.now();

  void handleTimingChanged(int value) {
    setState(() {
      _timing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Add New Report'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new AddReportDialog();
              },
              fullscreenDialog: true));
        },
        tooltip: 'Add Record',
        child: new Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new Container(
                margin: new EdgeInsets.only(left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("Timing(Morning/Evening)",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio<int>(
                        value: 0,
                        groupValue: _timing,
                        onChanged: handleTimingChanged,
                        // onChanged: handleRadioValueChanged
                      ),
                      new Text("Morning"),
                      new Radio<int>(
                        value: 1,
                        activeColor: Colors.orange,
                        groupValue: _timing,
                        onChanged: handleTimingChanged,
                        // onChanged: handleRadioValueChanged
                      ),
                      new Text("Evening"),
                    ]),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("1st time measurement",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " + _first_diastolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_diastolic,
                  activeColor: Colors.green,
                  min: 30.0,
                  max: 250.0,
                  divisions: 220,
                  onChanged: (double value) {
                    setState(() {
                      _first_diastolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " + _first_systolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_systolic,
                  activeColor: Colors.green,
                  min: 30.0,
                  max: 250.0,
                  divisions: 220,
                  onChanged: (double value) {
                    setState(() {
                      _first_systolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("Pulse: " + _first_pulse.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_pulse,
                  activeColor: Colors.green,
                  min: 30.0,
                  max: 150.0,
                  divisions: 120,
                  onChanged: (double value) {
                    setState(() {
                      _first_pulse = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 15.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("2nd time measurement",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " + _second_diastolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_diastolic,
                  activeColor: Colors.purple,
                  min: 30.0,
                  max: 250.0,
                  divisions: 220,
                  onChanged: (double value) {
                    setState(() {
                      _second_diastolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " + _second_systolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_systolic,
                  activeColor: Colors.purple,
                  min: 30.0,
                  max: 250.0,
                  divisions: 220,
                  onChanged: (double value) {
                    setState(() {
                      _second_systolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("Pulse: " + _second_pulse.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_pulse,
                  activeColor: Colors.purple,
                  min: 30.0,
                  max: 150.0,
                  divisions: 120,
                  onChanged: (double value) {
                    setState(() {
                      _second_pulse = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(top: 15.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text("Average",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " +
                        ((_first_diastolic + _second_diastolic) / 2)
                            .toInt()
                            .toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " +
                        ((_first_systolic + _second_systolic) / 2)
                            .toInt()
                            .toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Pulse: " +
                        ((_first_pulse + _second_pulse) / 2).toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
