import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/auth.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool _loading = false;

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
          child: OtpView(context),
        ),
      ),
    );
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Auth()),
                    );
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
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: text("Didn't receive the OTP?",
                        textColor: Color.fromARGB(255, 215, 215, 215),
                        isLongText: true)),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: text("Resend it in 60s",
                        textColor: Color.fromARGB(255, 215, 215, 215),
                        isLongText: true)),
                GestureDetector(
                  onTap: () {
                    // bottomsheet(context);
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      child: text1("Resent OTP",
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                text("You have been successfully registered!",
                    textColor: Colors.white,
                    fontSize: 20.0,
                    isLongText: true,
                    isCentered: true,
                    fontFamily: 'Semibold'),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    // bottomsheet(context);
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      child: text1("LOGIN",
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
