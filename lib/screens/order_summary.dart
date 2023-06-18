import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:nosh_app/screens/order_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary(
      {super.key,
      required this.cartItems,
      required this.timeSlot,
      required this.userDetails});

  final List<CartItem> cartItems;
  final String timeSlot;
  final User? userDetails;

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  bool _showPlaceOrderLoader = false;
  List<CartItem> _orderitems = [];

  String _paymentdropdownvalue = 'Online';
  var _payments = [
    "Online",
    "Token",
    "Cash On Delivery",
  ];

  String userId = "";
  String canteenId = "";
  String userName = '';
  String mobileNo = '';

  num orderTotal = 0;

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
      canteenId = prefs.getString("canteenId") as String;
      userName = prefs.getString("userName") as String;
      mobileNo = prefs.getString("mobileNo") as String;
      _orderitems = widget.cartItems;
      orderTotal = calculateOrderTotal();
    });
  }

  num calculateOrderTotal() {
    num total = 0;
    widget.cartItems.forEach((item) {
      total += (item.price! * (item.quantity ?? 0));
    });

    return total;
  }

  void quantityBtnHandler(String action, int index) {
    if (action == "INCREMENT" && _orderitems[index].quantity! < 20) {
      _orderitems[index].quantity = _orderitems[index].quantity! + 1;
      setState(() {
        _orderitems = _orderitems;
      });
    } else if (action == "DECREMENT" && _orderitems[index].quantity! > 1) {
      _orderitems[index].quantity = _orderitems[index].quantity! - 1;
      setState(() {
        _orderitems = _orderitems;
      });
    }

    setState(() {
      orderTotal = calculateOrderTotal();
    });
  }

  void placeOrderHandler(String? txnId) async {
    setState(() {
      _showPlaceOrderLoader = true;
      _loading = true;
    });

    // ONLINE, TOKEN, COD
    String paymentMode = _paymentdropdownvalue == "Online"
        ? "ONLINE"
        : _paymentdropdownvalue == "Token"
            ? "TOKEN"
            : "COD";

    Map<String, dynamic> data = await placeOrder(userId, canteenId,
        widget.timeSlot, paymentMode, _orderitems, txnId, orderTotal);

    if (data["status"] == 200) {
      Fluttertoast.showToast(
          msg: "Order placed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Timer timer = Timer(
          Duration(seconds: 2),
          () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderStatus(
                          id: data["id"],
                          status: "ORDER-PLACED",
                        )))
              });
    } else {
      Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      _showPlaceOrderLoader = false;
      _loading = false;
    });
  }

  /* Payment code START */

  void initPayment() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': razorpayKey,
      'amount': orderTotal * 100,
      'name': 'Nosh',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    print(
        "Payment Failed \n Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}\nresponse:${response.toString()}");

    Fluttertoast.showToast(
        msg: response.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("Payment Successful \n Payment ID: ${response.toString()}");

    placeOrderHandler(response.paymentId);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print("External Wallet Selected \n ${response.toString()}");
  }

  /* Payment code END */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.black,
        opacity: 0.4,
        progressIndicator: _showPlaceOrderLoader
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    // 'assets/icons/icon_food_ready.zip',
                    'assets/icons/icon_confirming_order.json',
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    "Placing order....",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            : Theme(
                data: ThemeData.dark(),
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 30,
                ),
              ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 70,
                  ),
                  Column(
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(mobileNo)
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Slot",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.timeSlot,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Palette.brown),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Total",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${orderTotal} /-",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Palette.brown),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: DropdownButton(
                      isExpanded: true,
                      // Initial Value
                      value: _paymentdropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: _payments.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          _paymentdropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_paymentdropdownvalue == "Token" &&
                  widget.userDetails != null) ...[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available Tokens : ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      "${widget.userDetails?.tokenBalance}",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
              SizedBox(
                height: 20,
              ),
              Text(
                "Order Details",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.custom(
                      childrenDelegate: SliverChildBuilderDelegate(
                childCount: _orderitems.length,
                (context, index) {
                  return Card(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      _orderitems[index].image ??
                                          "https://hips.hearstapps.com/hmg-prod/images/delish-220524-chocolate-milkshake-001-ab-web-1654180529.jpg?crop=0.647xw:0.972xh;0.177xw,0.0123xh&resize=1200:*",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "x${_orderitems[index].quantity} - "),
                                        Text(
                                          "${_orderitems[index].name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text("Price: "),
                                        Text('${_orderitems[index].price}/-',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        _orderitems[index].type == "Veg"
                                            ? Image.asset(
                                                "assets/icons/veg.png",
                                                fit: BoxFit.cover,
                                                width: 25,
                                                height: 25,
                                              )
                                            : Image.asset(
                                                "assets/icons/non_veg.png",
                                                fit: BoxFit.cover,
                                                width: 25,
                                                height: 25,
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    quantityBtnHandler("INCREMENT", index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    "${_orderitems[index].quantity}",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    quantityBtnHandler("DECREMENT", index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  );
                },
              ))),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_paymentdropdownvalue == "Online") {
                        initPayment();
                      } else {
                        placeOrderHandler(null);
                      }
                    },
                    child: const Text('Place Order'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
