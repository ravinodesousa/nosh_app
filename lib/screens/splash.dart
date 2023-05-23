import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/bottomsheet/password_reset.dart';
import 'package:nosh_app/components/bottomsheet/signin.dart';
import 'package:nosh_app/components/bottomsheet/signup.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/institution.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/verify_otp.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _loading = false;

  TextEditingController loginEmail = new TextEditingController();
  TextEditingController loginPassword = new TextEditingController();

  TextEditingController signupMobileNo = new TextEditingController();

  String? emailError = null;
  String? passwordError = null;

  bottomsheetsignup(BuildContext context) {
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
        builder: (context) {
          return SignupBottomSheet(onSigninCallback: (context) {
            bottomsheetsignin(context);
          });
        });
  }

  bottomsheetreset(BuildContext context) {
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
          return PasswordResetBottomSheet(onSigninCallback: (context) {
            bottomsheetsignin(context);
          });
        });
  }

  bottomsheetsignin(BuildContext context) {
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
          return SigninBottomSheet(
              onSignupCallback: (context) => {bottomsheetsignup(context)},
              onResetPasswordCallback: (context) =>
                  {bottomsheetreset(context)});
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
                    margin: EdgeInsets.only(top: 80),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: text1("Nosh",
                          textColor: Colors.white,
                          fontSize: 28.0,
                          fontFamily: 'Regular'),
                    ),
                    decoration: boxDecoration2(
                        radius: 12, bgColor: Color(0xFF56303030))),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Color(0xFF56303030)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        text("Nosh",
                            textColor: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Semibold'),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: text("Where tasteful creations begin.",
                                textColor: Color(0xFF9D9D9D),
                                isLongText: true)),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            bottomsheetsignin(context);
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                              child: text1("Get Started",
                                  textColor: Color(0xFF000000),
                                  isCentered: true,
                                  fontFamily: 'Medium',
                                  textAllCaps: true),
                              decoration: boxDecoration(
                                  bgColor: Colors.white, radius: 6)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
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
