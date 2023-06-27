import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenList extends StatefulWidget {
  const CanteenList({super.key});

  @override
  State<CanteenList> createState() => _CanteenListState();
}

class _CanteenListState extends State<CanteenList> {
  bool _loading = true;
  List<dynamic> _canteens = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Widget CanteenCard(dynamic tmpUser) {
    if ((tmpUser["special_items"] as List).length > 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  tmpUser["user"]["canteenName"] ?? '',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              "Today's special",
              style: TextStyle(
                  shadows: [Shadow(color: Colors.white, offset: Offset(0, -7))],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationThickness: 4,
                  fontSize: 15,
                  color: Colors.transparent,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: (tmpUser["special_items"] as List)
                        .map((dynamic item) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                ))
          ],
        ),
      );
    } else {
      return Align(
          alignment: Alignment.center,
          child: Text(
            tmpUser["user"]["canteenName"] ?? '',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
          ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    List<dynamic> temp = await getCanteenListWithSpecialMenu();
    print("temp ${temp}");
    setState(() {
      _canteens = temp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */
    return ModalProgressHUD(
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
        child: Scaffold(
          body: Container(
              child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/dash2.jpg",
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width),
                height: (MediaQuery.of(context).size.height),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Color(0xFF56303030)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: text("Choose your Canteen",
                                textColor: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Semibold'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 130,
                            child: _canteens.length > 0 && !_loading
                                ? GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 30,
                                            crossAxisSpacing: 30),
                                    children: [
                                      ..._canteens.map((dynamic tmpUser) =>
                                          GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences prefs =
                                                  await _prefs;
                                              prefs.setString(
                                                  "canteenId",
                                                  tmpUser["user"]["_id"]
                                                      as String);

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home()));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow[700],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CanteenCard(tmpUser)),
                                          ))
                                    ],
                                  )
                                : !_loading && _canteens.length == 0
                                    ? Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "No Canteen's found",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.black),
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
                                      )
                                    : null,
                          )
                        ]),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
