import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:nosh_app/screens/order_status.dart';
import 'package:nosh_app/screens/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

showAlertDialog(BuildContext context, RemoteMessage message) {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Create button
  Widget okButton = ElevatedButton(
    child: Text("VIEW"),
    onPressed: () async {
      Navigator.of(context).pop();
      final SharedPreferences prefs = await _prefs;
      if (prefs.containsKey("userId") &&
          prefs.containsKey("userType") &&
          prefs.containsKey("userName") &&
          prefs.containsKey("canteenName") &&
          prefs.containsKey("email") &&
          prefs.containsKey("mobileNo") &&
          prefs.containsKey("isMobileNoConfirmed")) {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Auth()));
        // {data: {"id":"64899597d96a8daea5630b81"}}
        // print(jsonDecode(message.data["data"])["type"]);
        dynamic notification_data = jsonDecode(message.data["data"]);
        if (notification_data["type"] == "ORDER-PLACED") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => OrderList()));
        } else if (notification_data["type"] == "ORDER-ACCEPTED") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderStatus(
                  id: notification_data["id"], status: "ORDER-ACCEPTED")));
        } else if (notification_data["type"] == "ORDER-READY") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderStatus(
                  id: notification_data["id"], status: "ORDER-READY")));
        } else if (notification_data["type"] == "ORDER-DELIVERED") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderStatus(
                  id: notification_data["id"], status: "ORDER-DELIVERED")));
        } else if (notification_data["type"] == "ORDER-REJECTED") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderStatus(
                  id: notification_data["id"], status: "ORDER-REJECTED")));
        } else if (notification_data["type"] == "ORDER-CANCELED") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderStatus(
                  id: notification_data["id"], status: "ORDER-CANCELED")));
        } else if (notification_data["type"] == "MONEY-CREDITED") {
        } else if (notification_data["type"] == "MONEY-REQUESTED") {
        } else if (notification_data["type"] == "NEW-CANTEEN-REGISTRATION") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserList(
                    userType: "CANTEEN",
                  )));
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please login to view the message",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
