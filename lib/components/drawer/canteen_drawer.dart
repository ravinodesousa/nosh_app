import 'package:flutter/material.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/menu_list.dart';
import 'package:nosh_app/screens/notification_list.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:nosh_app/screens/qr_scan.dart';
import 'package:nosh_app/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenDrawer extends StatefulWidget {
  const CanteenDrawer({super.key});

  @override
  State<CanteenDrawer> createState() => _CanteenDrawerState();
}

class _CanteenDrawerState extends State<CanteenDrawer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var selectedItem = -1;
  List<String> username = [];

  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = ["User", "1"];
    counter = 0;
  }

  void logoutHandler() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear().then((value) => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Splash()))
        });
  }

  Widget getDrawerItem(IconData icon, String name, int pos, {var tags, ind}) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedItem = pos;
        });
        if (tags != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => tags));
        } else if (ind == "log") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Confirmation",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              content: Text(
                "Are you sure you want to logout?",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    logoutHandler();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("No",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        } else if (ind == "home") {
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //   builder: (context) {
          //     return HomeView();
          //   },
          // ), (route) => false);
        }
      },
      child: Container(
        color: selectedItem == pos ? Color(0XFFF2ECFD) : Colors.white,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 20,
            ),
            //SvgPicture.asset(icon, width: 20, height: 20),
            SizedBox(width: 20),
            text2(name,
                textColor:
                    selectedItem == pos ? Color(0XFF5959fc) : Color(0XFF212121),
                fontSize: 18.0,
                fontFamily: 'Medium')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        elevation: 8,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 30, right: 10),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 40, 20, 40),
                      decoration: new BoxDecoration(
                          color: Color(0XFF5959fc),
                          borderRadius: new BorderRadius.only(
                              bottomRight: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0))),
                      /*User Profile*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://www.w3schools.com/howto/img_avatar.png"),
                              radius: 40),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: text1("Test User 1",
                                        textColor: Colors.white,
                                        fontFamily: 'Medium',
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8),
                                  text("9876543210",
                                      textColor: Colors.white, fontSize: 14.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                getDrawerItem(Icons.dashboard, "Home", 1,
                    ind: "home", tags: Home()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.list, "View Orders", 2,
                    ind: "view-orders", tags: OrderList()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.list_alt, "Edit Menu", 3,
                    ind: "edit-menu", tags: MenuList()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.notifications, "Notifications", 4,
                    ind: "notifications", tags: NotificationList()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.notifications, "Scan QR Code", 5,
                    ind: "scan-qr", tags: QRScan()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.logout, "Logout", 6, ind: "log"),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}