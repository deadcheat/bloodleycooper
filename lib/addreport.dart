import 'package:flutter/material.dart';

class AddReportDialog extends StatefulWidget {
  @override
  AddReportDialogState createState() => new AddReportDialogState();
}

class AddReportDialogState extends State<AddReportDialog> {
  final formKey = new GlobalKey<FormState>();
  double _diastolic = 135.0;
  double _systolic = 85.0;
  DateTime _date = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Report'),
        // actions: [
        //   new FlatButton(
        //       onPressed: () {
        //         //TODO: Handle save
        //       },
        //       child: new Text('SAVE',
        //           style: Theme
        //               .of(context)
        //               .textTheme
        //               .subhead
        //               .copyWith(color: Colors.white))),
        // ],
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
              new Row(children: <Widget>[
                new Radio<int>(
                  value: 0,
                  groupValue: 1,
                  // onChanged: handleRadioValueChanged
                ),
                new Text("Morning"),
                new Radio<int>(
                  value: 1,
                  groupValue: 2,
                  // onChanged: handleRadioValueChanged
                ),
                new Text("Evening"),
              ]),
              new Text("first"),
              new Slider(
                  value: _diastolic,
                  min: 50.0,
                  max: 250.0,
                  divisions: 200,
                  onChanged: (double value) {
                    setState(() {
                      _diastolic = value;
                    });
                  }),
              new Text(_diastolic.toInt().toString()),
              new Slider(
                  value: _systolic,
                  min: 50.0,
                  max: 250.0,
                  divisions: 200,
                  onChanged: (double value) {
                    setState(() {
                      _systolic = value;
                    });
                  }),
              new Text(_systolic.toInt().toString()),
              new Text("second"),
              new Slider(
                  value: _diastolic,
                  min: 50.0,
                  max: 250.0,
                  divisions: 200,
                  onChanged: (double value) {
                    setState(() {
                      _diastolic = value;
                    });
                  }),
              new Text(_diastolic.toInt().toString()),
              new Slider(
                  value: _systolic,
                  min: 50.0,
                  max: 250.0,
                  divisions: 200,
                  onChanged: (double value) {
                    setState(() {
                      _systolic = value;
                    });
                  }),
              new Text(_systolic.toInt().toString()),
              // new TextFormField(
              //   decoration: new InputDecoration(labelText: 'Your email'),
              //       !val.contains('@') ? 'Not a valid email.' : null,
              //   // onSaved: (val) => _email = val,
              // ),
              // new TextFormField(
              //   decoration: new InputDecoration(labelText: 'Your password'),
              //   validator: (val) =>
              //       val.length < 6 ? 'Password too short.' : null,
              //   // onSaved: (val) => _password = val,
              //   obscureText: true,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
