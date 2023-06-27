import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/institution.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/storage.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/auth.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Institution _selectedInstitution = new Institution();
  List<Institution>? institutionNames = [];

  String? nameError = null;
  String? emailError = null;
  String? passwordError = null;
  String? cpasswordError = null;
  String? mobileNoError = null;
  String? canteenNameError = null;
  String? itemImageError = null;

  TextEditingController profileEmail = new TextEditingController();
  TextEditingController profilePassword = new TextEditingController();
  TextEditingController profileCPassword = new TextEditingController();
  TextEditingController profileName = new TextEditingController();
  TextEditingController profileMobileNo = new TextEditingController();
  TextEditingController profileCanteenName = new TextEditingController();

  bool obscurePassword = true;
  bool obscureCPassword = true;
  bool changePassword = false;
  bool profilePicChanged = false;
  bool _loading = true;
  User? userData = null;
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;
    initializeDropdowns();

    User? fetchedUser =
        await getUserDetails(prefs.getString("userId") as String);

    print("fetchedUser ${fetchedUser.toString()}");
    setState(() {
      userId = prefs.getString("userId") as String;
      userData = fetchedUser;
      _loading = false;
    });

    if (fetchedUser != null) {
      print("institution id ${fetchedUser.institutionId ?? ''}");
      profileEmail.text = fetchedUser.email ?? '';
      // profilePassword.text = fetchedUser.password ?? '';
      profileName.text = fetchedUser.username ?? '';
      profileMobileNo.text = fetchedUser.mobileNo ?? '';
      profileCanteenName.text = fetchedUser.canteenName ?? '';
      profilePassword.clear();
      profileCPassword.clear();
      changePassword = false;

      setState(() {
        _selectedInstitution = institutionNames!.firstWhere(
            (institution) => institution.id == fetchedUser?.institutionId,
            orElse: () => institutionNames!.first);
      });
    }
  }

  void initializeDropdowns() async {
    List<Institution> temp = await getAllInstitutions();

    print(temp);
    if (temp.length > 0) {
      setState(() {
        institutionNames = temp;
        _selectedInstitution = institutionNames!.first;
      });
    }
  }

  void updateProfileHandler(BuildContext context) async {
    Map<String, dynamic> emailValidationResult =
        isValidEmail(profileEmail.text);
    Map<String, dynamic> passwordValidationResult =
        isValidPassword(profilePassword.text);
    Map<String, dynamic> mobileValidationResult =
        isValidMobileNo(profileMobileNo.text.trim());

    print(passwordValidationResult);
    setState(() {
      emailError = emailValidationResult["error"] ?? null;
      passwordError = changePassword
          ? (passwordValidationResult["is_valid"]
              ? null
              : passwordValidationResult["error"])
          : null;

      cpasswordError = changePassword &&
              profilePassword.text.trim() != profileCPassword.text.trim()
          ? "Password and Confirm password are different"
          : null;
      nameError =
          profileName.text.trim() == '' ? "Full name is required" : null;
      mobileNoError = mobileValidationResult["error"] ?? null;
      canteenNameError = userData?.userType == "CANTEEN" &&
              profileCanteenName.text.trim() == ''
          ? "Canteen name is required"
          : null;
    });
    print("1222 called");
    if (emailValidationResult["is_valid"] &&
        passwordError == null &&
        cpasswordError == null &&
        nameError == null &&
        mobileValidationResult["is_valid"] &&
        canteenNameError == null) {
      print("update profile called");

      String? uploadedFileurl = '';
      if (profilePicChanged) {
        uploadedFileurl = await uploadFile(File(image!.path));
      } else {
        uploadedFileurl = userData?.profilePicture;
      }

      if ((profilePicChanged && uploadedFileurl != '') ||
          (!profilePicChanged)) {
        Map<String, dynamic> data = await updateProfile(
          userId,
          uploadedFileurl,
          null,
          profileName.text.trim(),
          profileEmail.text.trim(),
          profileMobileNo.text.trim(),
          _selectedInstitution.id as String,
          profileCanteenName.text,
          changePassword,
          profilePassword.text,
        );

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
          // initData();

          Timer(Duration(seconds: 3), () {
            logoutHandler();
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Failed to Upload Product image. Please try again.")));
      }
    }
  }

  void logoutHandler() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear().then((value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Auth()),
              (Route<dynamic> route) => false)
        });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print(img);
    if (img != null) {
      List<String> filename = img!.name.split(".");
      print("name ${filename.toString()}");
      if (['jpeg', 'jpg', 'png'].contains(filename.last)) {
        setState(() {
          image = img;
          itemImageError = null;
          profilePicChanged = true;
        });
      } else {
        setState(() {
          itemImageError =
              "Only following image formats are allowed: jpeg,jpg,png";
        });
      }
    } else {
      // todo: show toast about camera error
    }
  }

  void imageSelectionHandler() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void checkPermissions() async {
    await Permission.storage.request();
    await Permission.photos.request();
    var permissionStatus = null;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      permissionStatus = await Permission.storage.status;
    } else {
      permissionStatus = await Permission.photos.status;
    }

    if (permissionStatus == PermissionStatus.granted) {
      imageSelectionHandler();
    } else {
      // todo : show toast
      print(
          'Permission not granted. Try Again with permission access. ${permissionStatus}');
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.black,
        opacity: 0.4,
        progressIndicator: Theme(
          data: ThemeData.dark(),
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 30,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: image != null
                        ? InkWell(
                            onTap: () {
                              checkPermissions();
                            },
                            child: Image.file(
                              //to show image, you type like this.
                              File(image!.path),
                              fit: BoxFit.contain,
                              // width: MediaQuery.of(context).size.width,
                              // height: 300,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              checkPermissions();
                            },
                            child: userData != null &&
                                    userData?.profilePicture != ''
                                ? Image.network(
                                    userData?.profilePicture ?? '',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  )
                                : Image.asset(
                                    "assets/images/img_avatar.png",
                                    fit: BoxFit.cover,
                                    // width: 25,
                                    // height: 25,
                                  ),
                          )),
                SizedBox(
                  height: 30,
                ),
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
                  controller: profileName,
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
                  controller: profileEmail,
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
                  controller: profileMobileNo,
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
                            dynamic matchedInstitution =
                                institutionNames?.firstWhere((institution) =>
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
                if (userData?.userType == "CANTEEN")
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
                    controller: profileCanteenName,
                  ),
                if (!changePassword) ...[
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        changePassword = true;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "want to change password? ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "click here",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (changePassword) ...[
                  SizedBox(
                    height: 10,
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
                    controller: profilePassword,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: obscureCPassword,
                    style: TextStyle(color: Colors.grey.shade700),
                    decoration: InputDecoration(
                      errorText: cpasswordError,
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "Enter your password again",
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
                            obscureCPassword = !obscureCPassword;
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
                    controller: profileCPassword,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => VerifyOtp()),
                    // );
                    updateProfileHandler(context);
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
                              "Update",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
