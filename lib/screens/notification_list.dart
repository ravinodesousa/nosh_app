import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/date.dart';
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
  List<dynamic> _notifications = [];

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

    List<dynamic> temp =
        await getNotifications(prefs.getString("userId") as String);
    setState(() {
      _notifications = temp;
      _loading = false;
    });
  }

  String getImage(String status) {
    String path = "assets/icons";
    switch (status) {
      case "ORDER-PLACED":
        {
          return "${path}/icon_order_placed.png";
        }
      case "ORDER-ACCEPTED":
        {
          return "${path}/icon_order_accepted.png";
        }
      case "ORDER-READY":
        {
          return "${path}/icon_order_ready.png";
        }
      case "ORDER-CANCELED":
        {
          return "${path}/icon_order_canceled.png";
        }
      case "ORDER-REJECTED":
        {
          return "${path}/icon_order_canceled.png";
        }
      case "ORDER-DELIVERED":
        {
          return "${path}/icon_order_delivered.png";
        }
      case "MONEY-CREDITED":
        {
          return "${path}/icon_money_credited.png";
        }
      case "MONEY-REQUESTED":
        {
          return "${path}/icon_money_requested.png";
        }
      case "NEW-CANTEEN-REGISTRATION":
        {
          return "${path}/icon_user_registered.png";
        }
      default:
        {
          return "${path}/icon_order_accepted.png";
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
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
                                    child: Image.asset(
                                      getImage(_notifications[index]["type"]),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 95,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_notifications[index]["title"]
                                            as String),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          _notifications[index]["message"]
                                              as String,
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            formatDateTime(_notifications[index]
                                                ["date"] as String),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey.shade700),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
