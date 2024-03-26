import 'package:flutter/material.dart';
import 'package:wovie/constants.dart';

class MsgBox extends StatelessWidget {
  final String? title;
  final String? content;
  final String? successText;
  final String? failureText;
  final bool? hideFailureButton;
  final Function()? onPressedSuccess;
  final Function()? onPressedFailure;

  MsgBox({
    this.title,
    this.content,
    this.onPressedSuccess,
    this.onPressedFailure,
    this.failureText = 'Cancel',
    this.successText = 'Ok',
    this.hideFailureButton = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var _onPressedSuccess = this.onPressedSuccess ??
        () {
          Navigator.pop(context);
        };
    var _onPressedFailure = this.onPressedFailure ??
        () {
          Navigator.pop(context);
        };
    return AlertDialog(
      elevation: 5,
      title: Text(
        this.title!,
        style: Theme.of(context).dialogTheme.titleTextStyle!.copyWith(
              fontSize: width / 18,
            ),
      ),
      content: Text(
        this.content!,
        style: Theme.of(context).dialogTheme.contentTextStyle!.copyWith(
              fontSize: width / 22,
            ),
      ),
      actions: [
        this.hideFailureButton!
            ? Container()
            : TextButton(
                onPressed: _onPressedFailure,
                child: Text(
                  this.failureText!,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
        TextButton(
          onPressed: _onPressedSuccess,
          child: Text(
            this.successText!,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ],
    );
  }
}

Future<dynamic> connectionErrorMsg(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => MsgBox(
      hideFailureButton: true,
      title: 'Network Error!',
      content: kConnectionErrorMsg,
    ),
  );
}

dynamic errorMsg(context, e) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => MsgBox(
      title: 'Error Caught',
      content: e.toString(),
    ),
  );
}
