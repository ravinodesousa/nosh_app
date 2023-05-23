import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';

class CanteenList extends StatefulWidget {
  const CanteenList({super.key});

  @override
  State<CanteenList> createState() => _CanteenListState();
}

class _CanteenListState extends State<CanteenList> {
  bool _loading = true;
  List<User> _canteens = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    List<User> temp = await getAllUsers("CANTEEN");
    setState(() {
      _canteens = temp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                    ..._canteens
                                        .map((User tmpUser) => GestureDetector(
                                              onTap: () {
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
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      tmpUser.canteenName ?? '',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )),
                                              ),
                                            ))
                                  ],
                                )
                              : !_loading && _canteens.length == 0
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Canteen's found",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ))
                                  : null,
                        )
                      ]),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
