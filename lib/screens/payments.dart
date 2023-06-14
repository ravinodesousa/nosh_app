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

    List<Payment> temp = await getPayments(_selectedMonth.toString());

    setState(() {
      _loading = false;
      _payments = temp;
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

  @override
  Widget build(BuildContext context) {
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
                      child: ListView.custom(
                          childrenDelegate: SliverChildBuilderDelegate(
                        childCount: _payments.length,
                        (context, index) {
                          return Card(
                            color: Colors.grey.shade300,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Canteen : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${_payments[index].canteenName ?? ''}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Pay Amount : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${_payments[index].totalAmount ?? ''}'),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${formatDateTime(_payments[index].startDate ?? '')}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "End Date : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${formatDateTime(_payments[index].endDate ?? '')}'),
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
                                          "Status : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Chip(
                                            backgroundColor:
                                                _payments[index].status ==
                                                        "UNPAID"
                                                    ? Colors.blue
                                                    : Colors.green,
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                            label: Text(
                                                '${_payments[index].status ?? ''}'))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_payments[index].status == "UNPAID")
                                      SizedBox(
                                        width: 140,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            changePaymentStatus(
                                                _payments[index].id as String);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.money, size: 18),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Pay Amount",
                                                style: TextStyle(fontSize: 17),
                                              )
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 5),
                                            padding: EdgeInsets.all(5),
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                      )
                                  ]),
                            ),
                          );
                        },
                      )),
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
