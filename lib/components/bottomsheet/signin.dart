import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/dashboard.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninBottomSheet extends StatefulWidget {
  const SigninBottomSheet(
      {super.key,
      required this.onSignupCallback,
      required this.onResetPasswordCallback});

  final Callback onSignupCallback;
  final Callback onResetPasswordCallback;

  @override
  State<SigninBottomSheet> createState() => _SigninBottomSheetState();
}

class _SigninBottomSheetState extends State<SigninBottomSheet> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  bool obscure_password = true;
  String? emailError = null;
  String? passwordError = null;

  TextEditingController loginEmail = new TextEditingController();
  TextEditingController loginPassword = new TextEditingController();

  String? fcmToken = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      fcmToken = prefs.getString("fcmToken");
    });
  }

  void loginHandler() async {
    Map<String, dynamic> emailValidationResult = isValidEmail(loginEmail.text);
    Map<String, dynamic> passwordValidationResult =
        isValidPassword(loginPassword.text);

    setState(() {
      emailError = emailValidationResult["error"] ?? null;
      passwordError = passwordValidationResult["error"] ?? null;
    });

    if (emailValidationResult["is_valid"] &&
        passwordValidationResult["is_valid"]) {
      //
      print("fcmToken ${fcmToken}");
      Map<String, dynamic> response =
          await login(fcmToken, loginEmail.text, loginPassword.text);
      print(response);
      if (response["successful"]) {
        User? userData = response["data"] as User;
        // todo: redirect to home screen

        final SharedPreferences prefs = await _prefs;
        prefs.setString("userId", userData.id as String);
        prefs.setString("userType", userData.userType as String);
        prefs.setString("userName", userData.username as String);
        prefs.setString("canteenName", userData.canteenName as String);
        prefs.setString("email", userData.email as String);
        prefs.setString("mobileNo", userData.mobileNo as String);

        if (userData.isMobileNoConfirmed ?? false) {
          prefs.setBool(
              "isMobileNoConfirmed", userData.isMobileNoConfirmed as bool);

          if (userData.userType == "USER") {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CanteenList()));
          } else if (userData.userType == "CANTEEN") {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home()));
          } else if (userData.userType == "ADMIN") {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Dashboard()));
          }
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  VerifyOtp(mobileNo: userData.mobileNo, type: "LOGIN")));
        }
      } else {
        Fluttertoast.showToast(
            msg: response["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
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
        height: 490,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "Welcome Back!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Sign in to continue",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white70,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: emailError,
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Enter your email",
                          prefixIcon: Icon(
                            Icons.mail_outline_sharp,
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
                        controller: loginEmail,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white70,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey.shade700),
                        obscureText: obscure_password,
                        decoration: InputDecoration(
                          errorText: passwordError,
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.lock_outline_sharp,
                            color: Colors.black,
                          ),
                          hintText: "Enter your password",
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                obscure_password = !obscure_password;
                              });
                            },
                            child: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade700)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade700)),
                          //border: InputBorder.none
                        ),
                        controller: loginPassword,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  loginHandler();
                  // if ((emaillog.text != null || emaillog.text != "") &&
                  //     (passlog.text != null || passlog.text != "")) {
                  //   setState(() {
                  //     _loading = true;
                  //   });
                  //   Navigator.pop(context);
                  //   // todo: Auth call to backend
                  //   // await _auth
                  //   //     .login(emaillog.text, passlog.text, context)
                  //   //     .then(
                  //   //   (result) async {
                  //   //     if (result != null) {
                  //   //       await fetchData();
                  //   //       if (phn == null) {
                  //   //         Navigator.push(
                  //   //             context,
                  //   //             MaterialPageRoute(
                  //   //                 builder: (context) => Mobile()));
                  //   //       } else {
                  //   //         Navigator.pushAndRemoveUntil(context,
                  //   //             MaterialPageRoute(
                  //   //           builder: (context) {
                  //   //             return HomeView();
                  //   //           },
                  //   //         ), (route) => false);
                  //   //       }
                  //   //     }
                  //   //   },
                  //   // );
                  //   setState(() {
                  //     _loading = false;
                  //   });
                  // } else {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //             title: Text('Incomplete Information'),
                  //             content:
                  //                 Text('Please Enter All The Details'),
                  //             actions: [
                  //               TextButton(
                  //                 child: Text('Ok'),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               )
                  //             ],
                  //           ));
                  // }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const CanteenList()),
                  // );
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
                            "Log In",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          )
                        : CupertinoActivityIndicator(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //     child: Divider(
                    //   color: Colors.grey,
                    // )),
                    Text(
                      "Forgot Password? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // bottomsheetreset(context);
                        widget.onResetPasswordCallback(context);
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                    // Expanded(
                    //     child: Divider(
                    //   color: Colors.grey,
                    // )),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SignInButton(Buttons.Google,
                  //     text: "Sign Up with Google", onPressed: () async {
                  //   setState(() {
                  //     _loading = true;
                  //   });
                  //   Navigator.pop(context);
                  //   final result = await _auth.signInWithGoogle();
                  //   if (result != null) {
                  //     await fetchData();
                  //     if (phn == null) {
                  //       setState(() {
                  //         _loading = false;
                  //       });
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Mobile()));
                  //     } else {
                  //       setState(() {
                  //         _loading = false;
                  //       });
                  //       Navigator.pushAndRemoveUntil(context,
                  //           MaterialPageRoute(
                  //         builder: (context) {
                  //           return HomeView();
                  //         },
                  //       ), (route) => false);
                  //     }
                  //   }
                  // }),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                      onTap: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                        Navigator.pop(context);
                        // bottomsheetsignup(context);
                        widget.onSignupCallback(context);
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef Callback = void Function(BuildContext context);
