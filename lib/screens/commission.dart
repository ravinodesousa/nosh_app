import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Commission extends StatefulWidget {
  const Commission({super.key});

  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<dynamic> _commissions = [];
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

    Map<String, dynamic> temp = await getCommission(_selectedMonth.toString());

    setState(() {
      _loading = false;
      _commissions = temp["data"] ?? [];
      totalCommission = temp["totalCommission"] ?? 0;
    });
  }

  void userStatusChangeHandler(String userId, String status) async {
    setState(() {
      _loading = true;
      _commissions = [];
      totalCommission = 0;
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
        title: Text("Commissions"),
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
              Text(
                "Total Earned: ${totalCommission}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              !_loading && _commissions.length > 0
                  ? Expanded(
                      child: ListView.custom(
                          childrenDelegate: SliverChildBuilderDelegate(
                        childCount: _commissions.length,
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
                                                '${_commissions[index]["name"] ?? ''}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Commission : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${_commissions[index]["totalRevenueEarned"] ?? ''}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        },
                      )),
                    )
                  : !_loading && _commissions.isEmpty
                      ? Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "No Data found",
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
