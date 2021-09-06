import 'package:flutter/material.dart';
import '../constants.dart';

class MsgBox extends StatelessWidget {
  final String? title;
  final String? content;

  MsgBox({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title!),
      content: Text(this.content!),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text('OK'),
        ),
      ],
    );
  }
}

dynamic ErrorMsg(context, e) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => MsgBox(
      title: 'Error Caught',
      content: e.toString(),
    ),
  );
}
