import 'package:flutter/material.dart';
import 'package:bloodpit/report.dart';

import 'package:bloodpit/datepicker.dart';

class AddReportDialog extends StatefulWidget {
  @override
  AddReportDialogState createState() => new AddReportDialogState();
}

class AddReportDialogState extends State<AddReportDialog> {
  final formKey = new GlobalKey<FormState>();
  static final double _diastolic_default = 130.0;
  static final double _systolic_default = 80.0;
  static final double _pulse_default = 80.0;
  static final double _bp_max = 220.0;
  static final double _bp_min = 30.0;
  static final double _p_max = 150.0;
  static final double _p_min = 30.0;
  double _first_diastolic = _diastolic_default;
  double _first_systolic = _systolic_default;
  double _first_pulse = _pulse_default;
  double _second_diastolic = _diastolic_default;
  double _second_systolic = _systolic_default;
  double _second_pulse = _pulse_default;
  DateTime _date = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Add New Report'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(new Report(
                null,
                _date,
                new Measurement(_first_diastolic.toInt(),
                    _first_systolic.toInt(), _first_pulse.toInt()),
                new Measurement(_second_diastolic.toInt(),
                    _second_systolic.toInt(), _second_pulse.toInt()),
              ));
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
              new DatePicker(
                labelText: 'Date',
                selectedDate: _date,
                selectDate: (DateTime date) {
                  setState(() {
                    _date = date;
                  });
                },
              ),
              new Container(
                margin: new EdgeInsets.only(),
                alignment: Alignment.centerLeft,
                child: new Text("Timing(Morning/Evening)",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                alignment: Alignment.centerLeft,
                child: new Text("1st time measurement",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " + _first_diastolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_diastolic,
                  activeColor: Colors.green,
                  min: _bp_min,
                  max: _bp_max,
                  divisions: (_bp_max - _bp_min).toInt(),
                  onChanged: (double value) {
                    setState(() {
                      _first_diastolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " + _first_systolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_systolic,
                  activeColor: Colors.green,
                  min: _bp_min,
                  max: _bp_max,
                  divisions: (_bp_max - _bp_min).toInt(),
                  onChanged: (double value) {
                    setState(() {
                      _first_systolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text("Pulse: " + _first_pulse.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _first_pulse,
                  activeColor: Colors.green,
                  min: _p_min,
                  max: _p_max,
                  divisions: (_p_max - _p_min).toInt(),
                  onChanged: (double value) {
                    setState(() {
                      _first_pulse = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 15.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text("2nd time measurement",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " + _second_diastolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_diastolic,
                  activeColor: Colors.purple,
                  min: _bp_min,
                  max: _bp_max,
                  divisions: (_bp_max - _bp_min).toInt(),
                  onChanged: (double value) {
                    setState(() {
                      _second_diastolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " + _second_systolic.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_systolic,
                  activeColor: Colors.purple,
                  min: _bp_min,
                  max: _bp_max,
                  divisions: (_bp_max - _bp_min).toInt(),
                  onChanged: (double value) {
                    setState(() {
                      _second_systolic = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text("Pulse: " + _second_pulse.toInt().toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Slider(
                  value: _second_pulse,
                  activeColor: Colors.purple,
                  min: _p_min,
                  max: _p_max,
                  divisions: 120,
                  onChanged: (double value) {
                    setState(() {
                      _second_pulse = value;
                    });
                  }),
              new Container(
                margin: new EdgeInsets.only(
                  top: 15.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text("Average",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Diastolic: " +
                        ((_first_diastolic + _second_diastolic) / 2)
                            .toInt()
                            .toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text(
                    "Systolic: " +
                        ((_first_systolic + _second_systolic) / 2)
                            .toInt()
                            .toString(),
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
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
