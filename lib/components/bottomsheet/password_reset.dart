import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/validation.dart';

class PasswordResetBottomSheet extends StatefulWidget {
  const PasswordResetBottomSheet({super.key, required this.onSigninCallback});

  final SigninCallback onSigninCallback;

  @override
  State<PasswordResetBottomSheet> createState() =>
      _PasswordResetBottomSheetState();
}

class _PasswordResetBottomSheetState extends State<PasswordResetBottomSheet> {
  bool _loading = false;

  TextEditingController resetMobileNo = new TextEditingController();
  TextEditingController resetPassword = new TextEditingController();
  TextEditingController resetConfirmPassword = new TextEditingController();

  String? mobileError = null;
  String? passwordError = null;
  String? confirmPasswordError = null;

  bool show_otp = false;
  bool is_otp_verified = false;
  bool obscure_password = true;
  bool obscure_confirm_password = true;

  String otp = '';

  void resetStateHandler() {
    setState(() {
      show_otp = false;
      is_otp_verified = false;
      mobileError = null;
      passwordError = null;
      confirmPasswordError = null;
      otp = '';
      obscure_password = true;
      obscure_confirm_password = true;
    });

    resetMobileNo.clear();
    resetPassword.clear();
    resetConfirmPassword.clear();
  }

  void _handleResetPasswordHandler() async {
    if (!show_otp) {
      // check if mobile number is entered
      Map<String, dynamic> validateMobileNo =
          isValidMobileNo(resetMobileNo.text.trim());
      setState(() {
        mobileError = validateMobileNo["error"];
      });

      if (validateMobileNo["is_valid"]) {
        // todo: call api to send OTP
        Map<String, dynamic>? response =
            await sendOTP(resetMobileNo.text.trim(), "RESET");
        print("response3333 ${response}");
        Fluttertoast.showToast(
            msg: response!["message"] ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor:
                response!["status"] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        if (response!["status"] == 200) {
          setState(() {
            show_otp = true;
          });
        }
      }
    } else if (!is_otp_verified) {
      // check if otp is entered

      if (otp.length != 5) {
        Fluttertoast.showToast(
            msg: "Enter OTP",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // todo: call api to verify OTP
        Map<String, dynamic>? response =
            await verifyOTP(resetMobileNo.text.trim(), otp, "RESET");
        print("response3333 ${response}");
        Fluttertoast.showToast(
            msg: response!["message"] ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor:
                response!["status"] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        if (response!["status"] == 200) {
          setState(() {
            is_otp_verified = true;
          });
        }
      }
    } else {
      // check if password and confirm password are entered
      String? validatePassword =
          resetPassword.text.trim() == '' ? "Password is required" : null;
      String? validateConfirmPassword = resetConfirmPassword.text.trim() == ''
          ? "Confirm Password is required"
          : resetConfirmPassword.text.trim() != resetPassword.text.trim()
              ? "Confirm password doesn't match with password"
              : null;
      setState(() {
        passwordError = validatePassword;
        confirmPasswordError = validateConfirmPassword;
      });

      if (passwordError == null && confirmPasswordError == null) {
        // todo: call api to reset OTP

        Map<String, dynamic>? response = await resetUserPassword(
            resetMobileNo.text.trim(), resetPassword.text);
        print("response3333 ${response}");
        Fluttertoast.showToast(
            msg: response!["message"] ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor:
                response!["status"] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        if (response!["status"] == 200) {
          resetStateHandler();
        }
      }
    }
    // !show_otp
    //   ? "Send OTP"
    //   : is_otp_verified
    //       ? "Reset"
    //       : "Verify OTP"
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
        height: MediaQuery.of(context).size.height < 580
            ? MediaQuery.of(context).size.height
            : !show_otp
                ? 350
                : !is_otp_verified
                    ? 450
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
                        errorText: mobileError,
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your Mobile No",
                        labelText: "Mobile Number",
                        prefixIcon: Icon(
                          Icons.phone_iphone,
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
                      enabled: show_otp || is_otp_verified ? false : true,
                      controller: resetMobileNo,
                    ),
                    SizedBox(
                      height: show_otp ? 40 : 0,
                    ),

// Otp view
                    if (show_otp)
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
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return AlertDialog(
                          //         title: Text("Verification Code"),
                          //         content:
                          //             Text('Code entered is $verificationCode'),
                          //       );
                          //     });
                          setState(() {
                            otp = verificationCode;
                          });
                        }, // end onSubmit
                      ),

                    SizedBox(
                      height: show_otp ? 40 : 0,
                    ),

                    if (is_otp_verified) ...[
                      TextFormField(
                        obscureText: obscure_password,
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: passwordError,
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
                        obscureText: obscure_confirm_password,
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: confirmPasswordError,
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
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                obscure_confirm_password =
                                    !obscure_confirm_password;
                              });
                            },
                            child: Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        controller: resetConfirmPassword,
                      )
                    ],

                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        _handleResetPasswordHandler();
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
                                  !show_otp
                                      ? "Send OTP"
                                      : is_otp_verified
                                          ? "Reset"
                                          : "Verify OTP",
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
                              resetStateHandler();
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
