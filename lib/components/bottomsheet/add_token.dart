import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddTokenBottomSheet extends StatefulWidget {
  const AddTokenBottomSheet({super.key, required this.initCallback});

  final Callback initCallback;

  @override
  State<AddTokenBottomSheet> createState() => _AddTokenBottomSheetState();
}

class _AddTokenBottomSheetState extends State<AddTokenBottomSheet> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  String? amountError = null;
  String userId = '';

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
    });
  }

  void addTokenHandler() async {
    setState(() {
      amountError =
          num.tryParse(tokenAmount.text) == null ? "Invalid Number" : null;
    });

    if (amountError == null) {
      initPayment(num.tryParse(tokenAmount.text) as num);
      //
      // User? userData = await login(tokenAmount.text, loginPassword.text);
      // print(userData);
      // if (userData != null) {
      //   // todo: redirect to home screen
      //   final SharedPreferences prefs = await _prefs;
      //   prefs.setString("userId", userData.id as String);
      //   prefs.setString("userType", userData.userType as String);
      //   prefs.setString("userName", userData.username as String);
      //   prefs.setString("canteenName", userData.canteenName as String);
      //   prefs.setString("email", userData.email as String);
      //   prefs.setString("mobileNo", userData.mobileNo as String);

      //   if (userData.userType == "USER") {
      //     Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => CanteenList()));
      //   } else if (userData.userType == "CANTEEN") {
      //     Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => Home()));
      //   }
      // }
    }
  }

  void initPayment(num amount) {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': razorpayKey,
      'amount': amount * 100,
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
    Map<String, dynamic> result = await addTokenToAccoount(
        userId, response.paymentId as String, tokenAmount.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Successfully added tokens to balance"
          : "Failed to add tokens to balance. Please try again."),
    ));

    Navigator.pop(context);

    widget.initCallback();
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print("External Wallet Selected \n ${response.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      color: Colors.black54,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.blue,
        strokeWidth: 5.0,
      ),
      child: Container(
        height: 290,
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
                "Add Tokens",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white70,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: amountError,
                          labelText: "Amount",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Enter amount",
                          prefixIcon: Icon(
                            Icons.money,
                            color: Colors.black,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade700)),
                          //border: InputBorder.none,
                        ),
                        controller: tokenAmount,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  addTokenHandler();
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
                            "Pay",
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
      ),
    );
  }
}

typedef Callback = void Function();
