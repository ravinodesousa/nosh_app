import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/payment.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/date.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<Payment> _payments = [];
  num totalCommission = 0;
  DateTime? _selectedMonth = null;
  String? userType;
  Map<String, dynamic>? adminData;

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
    final SharedPreferences prefs = await _prefs;

    Map<String, dynamic>? temp = await getPayments(
        _selectedMonth.toString(), prefs.getString("userType") as String);

    print(temp);
    setState(() {
      _loading = false;
      _payments = temp != null ? temp["payments"] : [];
      userType = prefs.getString("userType") as String;
      adminData = temp != null ? temp["admin"] : null;
    });
  }

  void changePaymentStatus(String paymentId) async {
    setState(() {
      _loading = true;
      _payments = [];
    });

    Map<String, dynamic> result = await updatePaymentStatus(paymentId);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Payment Status Updated successfully"
          : "Failed to Update Payment Status. Please try again."),
    ));

    if (result["status"] == 200) {
      initData();
    }
  }

  void showMonthPicker(BuildContext ctx) async {
    final selected = await showMonthYearPicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: Locale("en"),
    );

    print(selected);
    if (selected != null) {
      setState(() {
        _selectedMonth = selected;
      });
      initData();
    }
  }

  void callNumHandler(String number) async {
    final Uri phoneUrl = Uri(
      scheme: 'tel',
      path: number,
    );

    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      throw "Can't call that number.";
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
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
          child: Column(
            children: [
              if (_selectedMonth != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    _selectedMonth.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ElevatedButton(
                  onPressed: () {
                    showMonthPicker(context);
                  },
                  child: Text("Pick Month..")),
              SizedBox(
                height: 10,
              ),
              !_loading && _payments.length > 0
                  ? Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(children: [
                            if (_payments
                                        .where((element) =>
                                            element.type == "CANTEEN")
                                        .length >
                                    0 &&
                                userType == "ADMIN") ...[
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "Payment to Canteens",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ..._payments
                                  .where((element) => element.type == "CANTEEN")
                                  .map((payment) => Card(
                                        color: Colors.grey.shade300,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Canteen : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${payment.canteenName ?? ''}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Pay Amount : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${payment.totalAmount ?? ''}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Start Date : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${formatDateTime(payment.startDate ?? '')}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "End Date : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        '${formatDateTime(payment.endDate ?? '')}'),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Status : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Chip(
                                                        backgroundColor:
                                                            payment.status ==
                                                                    "UNPAID"
                                                                ? Colors.blue
                                                                : Colors.green,
                                                        labelStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                        label: Text(
                                                            '${payment.status ?? ''}'))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (payment.status ==
                                                        "UNPAID")
                                                      SizedBox(
                                                        width: 140,
                                                        height: 30,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            changePaymentStatus(
                                                                payment.id
                                                                    as String);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.money,
                                                                  size: 18),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Pay Amount",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17),
                                                              )
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            textStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        5),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      width: 140,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          callNumHandler(userType ==
                                                                  "ADMIN"
                                                              ? payment
                                                                      .canteenMobileNo
                                                                  as String
                                                              : adminData![
                                                                      "mobileNo"]
                                                                  as String);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone,
                                                                size: 18),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              userType ==
                                                                      "ADMIN"
                                                                  ? "Call Canteen"
                                                                  : "Call Admin",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            )
                                                          ],
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          textStyle: TextStyle(
                                                              fontSize: 5),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          backgroundColor:
                                                              Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ]),
                                        ),
                                      )),
                            ],
                            if (_payments
                                    .where((element) => element.type == "ADMIN")
                                    .length >
                                0) ...[
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  userType == "ADMIN"
                                      ? "Payment from Canteens"
                                      : "Payment to Admin",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ..._payments
                                  .where((element) => element.type == "ADMIN")
                                  .map((payment) => Card(
                                        color: Colors.grey.shade300,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Canteen : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${payment.canteenName ?? ''}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Pay Amount : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${payment.totalAmount ?? ''}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Start Date : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            '${formatDateTime(payment.startDate ?? '')}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "End Date : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        '${formatDateTime(payment.endDate ?? '')}'),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Status : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Chip(
                                                        backgroundColor:
                                                            payment.status ==
                                                                    "UNPAID"
                                                                ? Colors.blue
                                                                : Colors.green,
                                                        labelStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                        label: Text(
                                                            '${payment.status ?? ''}'))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (payment.status ==
                                                            "UNPAID" &&
                                                        userType == "ADMIN")
                                                      SizedBox(
                                                        width: 140,
                                                        height: 30,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            changePaymentStatus(
                                                                payment.id
                                                                    as String);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.money,
                                                                  size: 18),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Amount Paid",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17),
                                                              )
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            textStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        5),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      width: 140,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          callNumHandler(userType ==
                                                                  "ADMIN"
                                                              ? payment
                                                                      .canteenMobileNo
                                                                  as String
                                                              : adminData![
                                                                      "mobileNo"]
                                                                  as String);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone,
                                                                size: 18),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              userType ==
                                                                      "ADMIN"
                                                                  ? "Call Canteen"
                                                                  : "Call Admin",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            )
                                                          ],
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          textStyle: TextStyle(
                                                              fontSize: 5),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          backgroundColor:
                                                              Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ))
                            ]
                          ]),
                        ),
                      ),
                    )
                  : !_loading && _payments.isEmpty
                      ? Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "No data found",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
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
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
