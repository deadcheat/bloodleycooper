import 'package:flutter/material.dart';

class AddReportDialog extends StatefulWidget {
  @override
  AddReportDialogState createState() => new AddReportDialogState();
}

class AddReportDialogState extends State<AddReportDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New entry'),
        actions: [
          new FlatButton(
              onPressed: () {
                //TODO: Handle save
              },
              child: new Text('SAVE',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: new Text("Foo"),
    );
  }
}
