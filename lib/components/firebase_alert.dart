import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, RemoteMessage message) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();

      // todo: handle different notifications
      print(message.data);
    },
  );

  Widget cancelButton = ElevatedButton(
    child: Text("CANCEL"),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(message.notification!.title ?? ''),
    content: Text(message.notification!.body ?? ''),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
