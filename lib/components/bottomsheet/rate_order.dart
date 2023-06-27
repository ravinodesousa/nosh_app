import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateOrderBottomSheet extends StatefulWidget {
  const RateOrderBottomSheet(
      {super.key, required this.orderItem, required this.initCallback});

  final OrderItem? orderItem;

  /* similar to js callback where we call a function of parent widget. Here onSigninCallback will show signin popup */

  final Callback initCallback;

  @override
  State<RateOrderBottomSheet> createState() => _RateOrderBottomSheetState();
}

class _RateOrderBottomSheetState extends State<RateOrderBottomSheet> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  String? amountError = null;
  String userId = '';
  OrderItem? orderItem = null;

  TextEditingController tokenAmount = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      userId = prefs.getString("userId") as String;
      orderItem = widget.orderItem;
    });
  }

  void rateOrderHandler() async {
    Map<String, dynamic> result = await rateOrder(
        userId,
        orderItem!.id as String,
        orderItem!.products!
            .map((item) => {"id": item.productId, "rating": item.rating})
            .toList());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Order rated successfully"
          : "Failed to rate order. Please try again."),
    ));

    if (result["status"] == 200) {
      Navigator.pop(context);
      widget.initCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */
    return ModalProgressHUD(
      inAsyncCall: _loading,
      color: Colors.black54,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.blue,
        strokeWidth: 5.0,
      ),
      child: orderItem != null
          ? Container(
              height: (250 + (orderItem!.products!.length * 70)) >=
                      MediaQuery.of(context).size.height
                  ? MediaQuery.of(context).size.height
                  : 250 + (orderItem!.products!.length * 70),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                            ))),
                    Text(
                      "Rate Order",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Column(
                        children: [
                          ...orderItem!.products!.map((product) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      product.image ??
                                          "https://hips.hearstapps.com/hmg-prod/images/delish-220524-chocolate-milkshake-001-ab-web-1654180529.jpg?crop=0.647xw:0.972xh;0.177xw,0.0123xh&resize=1200:*",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          product.rating ?? 0 as double,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, index) {
                                        switch (index) {
                                          case 0:
                                            return Icon(
                                              Icons.sentiment_very_dissatisfied,
                                              color: Colors.red,
                                            );
                                          case 1:
                                            return Icon(
                                              Icons.sentiment_dissatisfied,
                                              color: Colors.redAccent,
                                            );
                                          case 2:
                                            return Icon(
                                              Icons.sentiment_neutral,
                                              color: Colors.amber,
                                            );
                                          case 3:
                                            return Icon(
                                              Icons.sentiment_satisfied,
                                              color: Colors.lightGreen,
                                            );
                                          case 4:
                                            return Icon(
                                              Icons.sentiment_very_satisfied,
                                              color: Colors.green,
                                            );
                                          default:
                                            return Container();
                                        }
                                      },
                                      onRatingUpdate: (rating) {
                                        product.rating = rating;
                                        setState(() {
                                          orderItem = orderItem;
                                        });
                                      },
                                      updateOnDrag: true,
                                    )
                                  ],
                                ),
                              ]),
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        rateOrderHandler();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: _loading == false
                              ? Text(
                                  "Submit",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )
                              : CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }
}

typedef Callback = void Function();
