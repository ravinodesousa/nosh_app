import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserList extends StatefulWidget {
  const UserList({super.key, required this.userType});

  final String userType;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<User> _users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    List<User> temp =
        await getAllUsers(widget.userType, fetchInactiveUsers: true);

    setState(() {
      _loading = false;
      _users = temp;
    });
  }

  void userStatusChangeHandler(String userId, String status) async {
    setState(() {
      _loading = true;
      _users = [];
    });

    Map<String, dynamic> result = await updateUserStatus(userId, status);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "User Status Updated successfully"
          : "Failed to Update User Status. Please try again."),
    ));

    if (result["status"] == 200) {
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userType),
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
        child: !_loading && _users.length > 0
            ? ListView.custom(
                childrenDelegate: SliverChildBuilderDelegate(
                childCount: _users.length,
                (context, index) {
                  return Card(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "User : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${_users[index].username ?? ''}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Chip(
                                        backgroundColor:
                                            _users[index].userStatus ==
                                                    "PENDING"
                                                ? Colors.blue
                                                : _users[index].userStatus ==
                                                        "ACCEPTED"
                                                    ? Colors.green
                                                    : Colors.red,
                                        labelStyle: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                        label: Text(
                                            '${_users[index].userStatus ?? ''}'))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_users[index].userType == "CANTEEN") ...[
                              Row(
                                children: [
                                  Text(
                                    "Canteen Name : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${_users[index].canteenName ?? ''}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                            Row(
                              children: [
                                Text(
                                  "Institution : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${_users[index].institution ?? ''}'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${_users[index].email ?? ''}'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Mobile No : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${_users[index].mobileNo ?? ''}'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_users[index].userStatus == "PENDING" ||
                                    _users[index].userStatus == "REJECTED")
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        userStatusChangeHandler(
                                            _users[index].id as String,
                                            "ACCEPTED");
                                      },
                                      child: Icon(Icons.check, size: 18),
                                      style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 5),
                                        padding: EdgeInsets.all(5),
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ),
                                if (_users[index].userStatus == "PENDING")
                                  SizedBox(
                                    width: 30,
                                  ),
                                if (_users[index].userStatus == "PENDING" ||
                                    _users[index].userStatus == "ACCEPTED")
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        userStatusChangeHandler(
                                            _users[index].id as String,
                                            "REJECTED");
                                      },
                                      child: Icon(Icons.close, size: 18),
                                      style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 5),
                                        padding: EdgeInsets.all(5),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ]),
                    ),
                  );
                },
              ))
            : !_loading && _users.isEmpty
                ? Center(
                    child: Text(
                    "No Users Found...",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ))
                : SizedBox(),
      ),
    );
  }
}
