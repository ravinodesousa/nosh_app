import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    final SharedPreferences prefs = await _prefs;

    List<Map<String, dynamic>> temp =
        await getNotifications(prefs.getString("userId") as String);
    setState(() {
      _notifications = temp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.black54,
        opacity: 0.7,
        progressIndicator: Theme(
          data: ThemeData.dark(),
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 30,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            initData();
            return Future(() => null);
          },
          child: !_loading && _notifications.length > 0
              ? ListView.custom(
                  childrenDelegate: SliverChildBuilderDelegate(
                  childCount: _notifications.length,
                  (context, index) {
                    return Card(
                      color: Color.fromARGB(255, 241, 241, 241),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Image.network(
                                      "https://hips.hearstapps.com/hmg-prod/images/delish-220524-chocolate-milkshake-001-ab-web-1654180529.jpg?crop=0.647xw:0.972xh;0.177xw,0.0123xh&resize=1200:*",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("Notification title"),
                                      Text("Notification body..............")
                                    ],
                                  ),
                                ],
                              ),
                              Text("a day ago")
                            ]),
                      ),
                    );
                  },
                ))
              : Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No notifications found....",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              initData();
                            },
                            icon: Icon(Icons.refresh),
                            label: Text("Refresh"))
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
