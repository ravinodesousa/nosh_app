import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/commission.dart';
import 'package:nosh_app/screens/dashboard.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/menu_list.dart';
import 'package:nosh_app/screens/notification_list.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:nosh_app/screens/payments.dart';
import 'package:nosh_app/screens/profile.dart';
import 'package:nosh_app/screens/qr_scan.dart';
import 'package:nosh_app/screens/auth.dart';
import 'package:nosh_app/screens/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var selectedItem = -1;
  String? username = '';
  String? mobileNo = '';
  String? profilePicture = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      username = prefs.getString("userName") ?? '';
      mobileNo = prefs.getString("mobileNo") ?? '';
      profilePicture = prefs.getString("profilePicture") ?? '';
    });
  }

  void logoutHandler() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear().then((value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Auth()),
              (Route<dynamic> route) => false)
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
                          color: Palette.brown,
                          borderRadius: new BorderRadius.only(
                              bottomRight: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0))),
                      /*User Profile*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                              backgroundImage: NetworkImage(profilePicture == ''
                                  ? "https://www.w3schools.com/howto/img_avatar.png"
                                  : profilePicture as String),
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
                                    child: text1(username ?? '',
                                        textColor: Colors.white,
                                        fontFamily: 'Medium',
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8),
                                  text(mobileNo ?? '',
                                      textColor: Colors.white, fontSize: 14.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                getDrawerItem(Icons.dashboard, "Dashboard", 1,
                    ind: "dashboard", tags: Dashboard()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.list, "User List", 2,
                    ind: "user-list",
                    tags: UserList(
                      userType: "USER",
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.list, "Canteen List", 3,
                    ind: "canteen-list",
                    tags: UserList(
                      userType: "CANTEEN",
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.money, "Commission", 4,
                    ind: "commission", tags: Commission()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.payments, "Payments", 5,
                    ind: "payments", tags: Payments()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(
                    Icons.supervised_user_circle_outlined, "Profile", 6,
                    ind: "profile", tags: Profile()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(color: Color(0XFFDADADA), height: 1),
                ),
                getDrawerItem(Icons.logout, "Logout", 7, ind: "log"),
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
