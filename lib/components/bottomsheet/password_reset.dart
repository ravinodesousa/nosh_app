import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class PasswordResetBottomSheet extends StatefulWidget {
  const PasswordResetBottomSheet({super.key, required this.onSigninCallback});

  final SigninCallback onSigninCallback;

  @override
  State<PasswordResetBottomSheet> createState() =>
      _PasswordResetBottomSheetState();
}

class _PasswordResetBottomSheetState extends State<PasswordResetBottomSheet> {
  bool _loading = false;

  TextEditingController signupMobileNo = new TextEditingController();
  TextEditingController resetPassword = new TextEditingController();
  TextEditingController resetConfirmPassword = new TextEditingController();

  bool show_otp = false;

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
        height: MediaQuery.of(context).size.height < 580
            ? MediaQuery.of(context).size.height
            : 580,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    "Reset Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your Mobile No",
                        labelText: "Mobile No",
                        prefixIcon: Icon(
                          Icons.mail_outline_sharp,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      controller: signupMobileNo,
                    ),
                    SizedBox(
                      height: 40,
                    ),

// Otp view
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
                                content:
                                    Text('Code entered is $verificationCode'),
                              );
                            });
                      }, // end onSubmit
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your password",
                        labelText: "PASSWORD",
                        prefixIcon: Icon(
                          Icons.lock_outline_sharp,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      controller: resetPassword,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your password",
                        labelText: "CONFIRM PASSWORD",
                        prefixIcon: Icon(
                          Icons.lock_outline_sharp,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      controller: resetConfirmPassword,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          show_otp = true;
                        });
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
                                  "Reset",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your password?",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              widget.onSigninCallback(context);
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef SigninCallback = void Function(BuildContext context);
