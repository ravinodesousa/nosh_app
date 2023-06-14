import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/bottomsheet/add_token.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/token_history.dart';
import 'package:nosh_app/helpers/date.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Tokens extends StatefulWidget {
  const Tokens({super.key});

  @override
  State<Tokens> createState() => _TokensState();
}

class _TokensState extends State<Tokens> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<TokenHistory> _tokenList = [];
  String userType = '';
  num availableBalance = 0;
  // final old_payment_date = new DateFormat("E, d MMM yyyy HH:mm:ss");
  // final new_payment_date = new DateFormat("dd/MM/yyyy hh:mm a");

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

    Map<String, dynamic> temp =
        await getTokenHistory(prefs.getString("userId") as String);

    print("tokens: ${temp}");
    setState(() {
      _loading = false;
      _tokenList = temp["token_history"].cast<TokenHistory>();
      availableBalance = temp["balance"];
      userType = prefs.getString("userType") as String;
    });
  }

  bottomsheetaddtoken(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(builder).viewInsets.bottom),
            child: AddTokenBottomSheet(
              initCallback: () {
                setState(() {
                  _loading = true;
                  _tokenList = [];
                  availableBalance = 0;
                });

                initData();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tokens"), actions: [
        IconButton(
            onPressed: () {
              bottomsheetaddtoken(context);
            },
            icon: Icon(Icons.add))
      ]),
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
              SizedBox(
                height: 100,
                child: Card(
                  elevation: 6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Token Balance : ",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${availableBalance}",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                elevation: 6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Token History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Divider(
                          color: Palette.brown,
                          thickness: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: !_loading && _tokenList.length > 0
                          ? ListView.custom(
                              childrenDelegate: SliverChildBuilderDelegate(
                              childCount: _tokenList.length,
                              (context, index) {
                                // List<String>? dateArr =
                                //     _tokenList[index].payment_date?.split(" ");

                                return Card(
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text('${index + 1}]'),
                                              Text(
                                                'Balance Included : ',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '${_tokenList[index].balance_included ?? ''} Tokens',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text('${index + 1}]'),
                                              Text(
                                                'Paid Price : ',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                'Rs ${_tokenList[index].payment_amount ?? ''} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Credited on:',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                // '${dateArr![0]}, ${dateArr![1]} ${dateArr![2]} ${dateArr![3]}, ${dateArr![4]}',
                                                formatDateTime(_tokenList[index]
                                                        .payment_date ??
                                                    ''),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            ],
                                          )
                                        ]),
                                  ),
                                );
                              },
                            ))
                          : !_loading && _tokenList.isEmpty
                              ? Center(
                                  child: Text(
                                  "No records found...",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ))
                              : SizedBox(),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
