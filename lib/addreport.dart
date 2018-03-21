import 'package:flutter/material.dart';
import 'package:bloodpit/report.dart';
import 'package:bloodpit/timing.dart';
import 'package:bloodpit/datepicker.dart';
import 'package:bloodpit/disabledfocus.dart';

class AddReportDialog extends StatefulWidget {
  @override
  AddReportDialogState createState() => new AddReportDialogState();
}

class AddReportDialogState extends State<AddReportDialog> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Timing _timing = Timing.MORNING;
  DateTime _date = new DateTime.now();
  final _fSCon = new TextEditingController();
  final _fDCon = new TextEditingController();
  final _fPCon = new TextEditingController();
  final _sSCon = new TextEditingController();
  final _sDCon = new TextEditingController();
  final _sPCon = new TextEditingController();
  final _aSCon = new TextEditingController();
  final _aDCon = new TextEditingController();
  final _aPCon = new TextEditingController();

  void handleTimingChanged(Timing value) {
    setState(() {
      _timing = value;
    });
  }

  String _validate(String value) {
    if (value.isEmpty) return 'required';
    if (parseWithZero(value) == 0) return 'zero is no way';
    final RegExp nameExp = new RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value)) return 'numbers only';
    return null;
  }

  int parseWithZero(String value) {
    return int.parse(value, onError: (v) => 0);
  }

  void _refleshAverage() {
    final averageD =
        (parseWithZero(_fDCon.text) + parseWithZero(_sDCon.text)) / 2;
    final averageS =
        (parseWithZero(_fSCon.text) + parseWithZero(_sSCon.text)) / 2;
    final averageP =
        (parseWithZero(_fPCon.text) + parseWithZero(_sPCon.text)) / 2;
    _aDCon.text = averageD.toInt().toString();
    _aSCon.text = averageS.toInt().toString();
    _aPCon.text = averageP.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    _fSCon.addListener(_refleshAverage);
    _fDCon.addListener(_refleshAverage);
    _fPCon.addListener(_refleshAverage);
    _sSCon.addListener(_refleshAverage);
    _sDCon.addListener(_refleshAverage);
    _sPCon.addListener(_refleshAverage);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Add New Report'),
      ),
      floatingActionButton: new Builder(
        builder: (context) {
          return new FloatingActionButton(
            onPressed: () {
              final form = _formKey.currentState;
              if (form.validate()) {
                Navigator.of(context).pop(new Report(
                      null,
                      _date,
                      _timing,
                      new Measurement(
                          parseWithZero(_fSCon.text),
                          parseWithZero(_fDCon.text),
                          parseWithZero(_fPCon.text)),
                      new Measurement(
                          parseWithZero(_sSCon.text),
                          parseWithZero(_sDCon.text),
                          parseWithZero(_sPCon.text)),
                    ));
              } else {
                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                        "Invalidated inputs",
                        style: new TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      duration: new Duration(seconds: 3),
                      backgroundColor: Colors.red[300],
                    ));
              }
            },
            tooltip: 'Add Record',
            child: new Icon(Icons.save),
            backgroundColor: Colors.red,
          );
        },
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          // autovalidate: true,
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
                child: new Flexible(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio<Timing>(
                          value: Timing.MORNING,
                          groupValue: _timing,
                          onChanged: handleTimingChanged,
                          // onChanged: handleRadioValueChanged
                        ),
                        new Text("Morning"),
                        new Radio<Timing>(
                          value: Timing.EVENING,
                          activeColor: Colors.orange,
                          groupValue: _timing,
                          onChanged: handleTimingChanged,
                          // onChanged: handleRadioValueChanged
                        ),
                        new Text("Evening"),
                      ]),
                ),
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
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: new Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _fSCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _fDCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        child: new Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _fPCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                  ],
                ),
              ),
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
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: new Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _sSCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _sDCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        child: new Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        controller: _sPCon,
                        keyboardType: TextInputType.number,
                        validator: _validate,
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 15.0,
                ),
                alignment: Alignment.centerLeft,
                child: new Text("Averages",
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Container(
                margin: new EdgeInsets.only(
                  top: 10.0,
                ),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: new Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        focusNode: new AlwaysDisabledFocusNode(),
                        controller: _aSCon,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        focusNode: new AlwaysDisabledFocusNode(),
                        controller: _aDCon,
                      ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        child: new Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.end,
                        focusNode: new AlwaysDisabledFocusNode(),
                        controller: _aPCon,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
