import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final notificationList = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
    'Notification 4',
    'Notification 5',
    'Notification 6',
    'Notification 7',
    'Notification 8',
    'Notification 9',
    'Notification 10',
    'Notification 11',
    'Notification 12',
    'Notification 13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Notifications")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: ListView.separated(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitle: Text("Notification body"),
                  title: Text(
                    notificationList[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(
                    "16th April 2023",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 2,
                );
              },
            )));
  }
}
