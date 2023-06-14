import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/auth.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/dashboard.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key, required this.mobileNo, required this.type});

  final String? mobileNo;
  final String? type;
  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  String otp = '';
  int timer = 60;
  bool is_otp_verified = false;

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      setState(() {
        timer = timer - 1;
      });

      if (timer == 0) {
        _timer.cancel();
      }
    });
  }

  void verifyOTPHandler() async {
    if (otp.length == 5) {
      Map<String, dynamic>? response =
          await verifyOTP(widget.mobileNo as String, otp, "SIGNUP");
      print("response3333 ${response}");

      if (response!["status"] == 200) {
        if (widget.type == "LOGIN") {
          final SharedPreferences prefs = await _prefs;
          prefs.setBool("isMobileNoConfirmed", true);
        }
        setState(() {
          is_otp_verified = true;
        });
      } else {
        Fluttertoast.showToast(
            msg: response!["message"] ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor:
                response!["status"] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Enter OTP',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void resendOTPHandler() async {
    Map<String, dynamic>? response =
        await sendOTP(widget.mobileNo as String, "SIGNUP");
    print("response3333 ${response}");

    Fluttertoast.showToast(
        msg: response!["message"] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: response!["status"] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    if (response!["status"] == 200) {
      setState(() {
        timer = 60;
      });

      startCountdown();
    }
  }

  Widget OtpView(BuildContext context) {
    return Stack(
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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text("Verify your OTP",
                      textColor: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Semibold'),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: text(
                          "Enter OTP Received on registered Mobile Number",
                          isCentered: true,
                          textColor: Color.fromARGB(255, 201, 201, 201),
                          isLongText: true)),
                  SizedBox(
                    height: 50,
                  ),
                  OtpTextField(
                    numberOfFields: 5,
                    borderColor: Color(0xFF512DA8),
                    cursorColor: Colors.white,
                    styles: [
                      TextStyle(color: Colors.white),
                      TextStyle(color: Colors.white),
                      TextStyle(color: Colors.white),
                      TextStyle(color: Colors.white),
                      TextStyle(color: Colors.white)
                    ],
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      setState(() {
                        otp = verificationCode;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      verifyOTPHandler();
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child: text1("SUBMIT",
                            textColor: Color(0xFF000000),
                            isCentered: true,
                            fontFamily: 'Medium',
                            textAllCaps: true),
                        decoration:
                            boxDecoration(bgColor: Colors.white, radius: 6)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  if (timer > 0)
                    Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: text("Resend otp in ${timer}s",
                            textColor: Color.fromARGB(255, 215, 215, 215),
                            isLongText: true)),
                  if (timer == 0) ...[
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: text("Didn't receive the OTP?",
                            textColor: Color.fromARGB(255, 215, 215, 215),
                            isLongText: true)),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        resendOTPHandler();
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                          child: text1("Resend OTP",
                              textColor: Color(0xFF000000),
                              isCentered: true,
                              fontFamily: 'Medium',
                              textAllCaps: true),
                          decoration:
                              boxDecoration(bgColor: Colors.white, radius: 6)),
                    ),
                  ]
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget SuccessView(BuildContext context) {
    return Stack(
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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 250),
                  text("You have been successfully verified!",
                      textColor: Colors.white,
                      fontSize: 20.0,
                      isLongText: true,
                      isCentered: true,
                      fontFamily: 'Semibold'),
                  SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // bottomsheet(context);
                      if (widget.type == "SIGNUP") {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Auth()));
                      } else if (widget.type == "LOGIN") {
                        final SharedPreferences prefs = await _prefs;
                        String userType = prefs.getString("userType") as String;

                        print("userType2333 ${userType}");

                        if (userType == "USER") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CanteenList()));
                        } else if (userType == "CANTEEN") {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Home()));
                        } else if (userType == "ADMIN") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Dashboard()));
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child: text1(widget.type == "SIGNUP" ? "LOGIN" : "HOME",
                            textColor: Color(0xFF000000),
                            isCentered: true,
                            fontFamily: 'Medium',
                            textAllCaps: true),
                        decoration:
                            boxDecoration(bgColor: Colors.white, radius: 6)),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
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
          child: is_otp_verified ? SuccessView(context) : OtpView(context),
        ),
      ),
    );
  }
}
