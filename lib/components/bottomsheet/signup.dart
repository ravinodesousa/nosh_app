import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/institution.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/screens/verify_otp.dart';

class SignupBottomSheet extends StatefulWidget {
  const SignupBottomSheet({super.key, required this.onSigninCallback});

  final SigninCallback onSigninCallback;

  @override
  State<SignupBottomSheet> createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<SignupBottomSheet> {
  bool _loading = true;
  String _selectedUserType = 'Student';
  var userTypes = [
    'Student',
    'Canteen Owner',
  ];
  Institution _selectedInstitution = new Institution();
  List<Institution>? institutionNames = [];

  String? nameError = null;
  String? emailError = null;
  String? passwordError = null;
  String? mobileNoError = null;
  String? canteenNameError = null;

  TextEditingController signupEmail = new TextEditingController();
  TextEditingController signupPassword = new TextEditingController();
  TextEditingController signupName = new TextEditingController();
  TextEditingController signupMobileNo = new TextEditingController();
  TextEditingController signupCanteenName = new TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // fill instituion dropdown
    initializeDropdowns();
  }

  void initializeDropdowns() async {
    List<Institution> temp = await getAllInstitutions();

    print(temp);
    if (temp.length > 0) {
      setState(() {
        institutionNames = temp;
        _selectedInstitution = institutionNames!.first;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void signupHandler(BuildContext context) async {
    Map<String, dynamic> emailValidationResult = isValidEmail(signupEmail.text);
    Map<String, dynamic> passwordValidationResult =
        isValidPassword(signupPassword.text);
    Map<String, dynamic> mobileValidationResult =
        isValidMobileNo(signupMobileNo.text.trim());

    setState(() {
      emailError = emailValidationResult["error"] ?? null;
      passwordError = passwordValidationResult["error"] ?? null;
      nameError = signupName.text.trim() == '' ? "Full name is required" : null;
      mobileNoError = mobileValidationResult["error"] ?? null;
      canteenNameError = _selectedUserType == "Canteen Owner" &&
              signupCanteenName.text.trim() == ''
          ? "Canteen name is required"
          : null;
    });
    print("1222 called");
    if (emailValidationResult["is_valid"] &&
        passwordValidationResult["is_valid"] &&
        nameError == null &&
        mobileValidationResult["is_valid"] &&
        canteenNameError == null) {
      print("signup called");
      Map<String, dynamic> data = await signup(
          _selectedUserType == "Student" ? "USER" : "CANTEEN",
          signupName.text,
          signupEmail.text,
          signupPassword.text,
          signupMobileNo.text,
          _selectedInstitution.id as String,
          signupCanteenName.text);

      print(data);

      Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: data["successful"] ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      if (data["successful"]) {
        // todo: redirect to verify otp screen  to verify the mobile number

        String mobileNo = signupMobileNo.text;

        signupName.clear();
        signupEmail.clear();
        signupPassword.clear();
        signupMobileNo.clear();
        signupCanteenName.clear();

        Navigator.pop(context);
        widget.onSigninCallback(context);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                VerifyOtp(mobileNo: mobileNo, type: "SIGNUP")));
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
        height: MediaQuery.of(context).size.height < 700
            ? MediaQuery.of(context).size.height
            : 700,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    "Create an account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "Ease your efforts with us",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    // TextFormField(
                    //   style: TextStyle(color: Colors.grey.shade700),
                    //   decoration: InputDecoration(
                    //     labelStyle: TextStyle(color: Colors.black),
                    //     hintText: "Select User Type",
                    //     labelText: "SIGNUP AS",
                    //     prefixIcon: Icon(
                    //       Icons.verified_user_outlined,
                    //       color: Colors.black,
                    //     ),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey.shade700),
                    //     ),
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.grey.shade700,
                    //       ),
                    //     ),
                    //   ),
                    //   controller: emailsignup,
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.verified_user_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              // Initial Value
                              value: _selectedUserType,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of userTypes
                              items: userTypes.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                print("_selectedUserType ${newValue}");
                                setState(() {
                                  _selectedUserType = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        errorText: nameError,
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your full name",
                        labelText: "FULL NAME",
                        prefixIcon: Icon(
                          Icons.person_outline_sharp,
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
                      controller: signupName,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        errorText: emailError,
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your email",
                        labelText: "EMAIL",
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
                      controller: signupEmail,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: obscurePassword,
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
                              obscurePassword = !obscurePassword;
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
                      controller: signupPassword,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        errorText: mobileNoError,
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter your Mobile No",
                        labelText: "MOBILE NO",
                        prefixIcon: Icon(
                          Icons.mobile_friendly,
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
                    SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.business),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              // Initial Value
                              value: _selectedInstitution.id,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of userTypes
                              items: institutionNames?.map((Institution items) {
                                return DropdownMenuItem(
                                  value: items.id,
                                  child: Text(items.name ?? ''),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (dynamic newValue) {
                                dynamic matchedInstitution = institutionNames
                                    ?.firstWhere((institution) =>
                                        institution.id == newValue);
                                setState(() {
                                  _selectedInstitution = matchedInstitution;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    if (_selectedUserType == "Canteen Owner")
                      TextFormField(
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: canteenNameError,
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "Select your Canteen Name",
                          labelText: "CANTEEN NAME",
                          prefixIcon: Icon(
                            Icons.storefront,
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
                        controller: signupCanteenName,
                      ),

                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => VerifyOtp()),
                        // );
                        signupHandler(context);
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
                                  "Sign Up",
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
                          "Already a user?",
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
                    SizedBox(
                      height: 20,
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
