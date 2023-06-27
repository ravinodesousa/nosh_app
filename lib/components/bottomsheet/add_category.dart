import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/storage.dart';
import 'package:nosh_app/helpers/validation.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet(
      {super.key,
      required this.initCallback,
      required this.operation,
      required this.category});

/* similar to js callback where we call a function of parent widget. Here initCallback will reinitalize data in parent widget */
  final Callback initCallback;
  final String? operation;
  final CategoryItem? category;

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;
  bool profilePicChanged = false;
  String? nameError = null;
  String? itemImageError = null;
  String userId = '';

  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController categoryName = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // initalize data
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    // fetching user_id from SharedPreferences
    setState(() {
      userId = prefs.getString("userId") as String;
    });

    if (widget.operation == "UPDATE") {
      categoryName.text = widget.category?.name ?? '';
    }
  }

/* function called when  user clicks on "Pay" button. This will initiate razorpay for payment and on success calls backend server to update the users total tokens */
  void addUpdateCategoryHandler() async {
    print(image);
    setState(() {
      // validating name
      nameError = categoryName.text.isEmpty ? "Name required" : null;
      itemImageError = ((widget.category != null &&
                  widget.category!.image == '' &&
                  image == null) ||
              (widget.category == null && image == null))
          ? "Icon required"
          : null;
    });

    if (nameError == null && itemImageError == null) {
      int status = 0;

      String? uploadedFileurl = '';
      if (profilePicChanged) {
        uploadedFileurl = await uploadFile(File(image!.path));
      } else {
        uploadedFileurl = widget.category?.image;
      }

      if ((profilePicChanged && uploadedFileurl != '') ||
          (!profilePicChanged)) {
        if (widget.operation == "ADD") {
          // calling backend API endpoint to add category
          Map<String, dynamic> result =
              await addCategory(categoryName.text, uploadedFileurl as String);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result["status"] == 200
                ? "Successfully added category"
                : "Failed to add category. Please try again."),
          ));

          status = result["status"];
        } else {
          // calling backend API endpoint to update category
          Map<String, dynamic> result = await updateCategory(
              widget.category?.id as String,
              categoryName.text,
              uploadedFileurl as String);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result["status"] == 200
                ? "Successfully updated category"
                : "Failed to update category. Please try again."),
          ));

          status = result["status"];
        }

        if (status == 200) {
          Navigator.pop(context);
          widget.initCallback();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Failed to Upload category image. Please try again.")));
      }
    }
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
    return ModalProgressHUD(
      inAsyncCall: _loading,
      color: Colors.black54,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.blue,
        strokeWidth: 5.0,
      ),
      child: Container(
        height: 450,
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
                "${widget.operation == 'ADD' ? 'Add' : 'Update'} Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
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
                                child: widget.category != null &&
                                        widget.category?.image != ''
                                    ? Image.network(
                                        widget.category?.image ?? '',
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      )
                                    : Image.asset(
                                        "assets/icons/icon_photo_upload.png",
                                        fit: BoxFit.cover,
                                        // width: 25,
                                        // height: 25,
                                      ),
                              )),
                    if (itemImageError != null)
                      Text(
                        itemImageError as String,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white70,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.grey.shade700),
                        decoration: InputDecoration(
                          errorText: nameError,
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Enter name",
                          prefixIcon: Icon(
                            Icons.text_snippet_outlined,
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
                        controller: categoryName,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  addUpdateCategoryHandler();
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
                            "Save",
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
