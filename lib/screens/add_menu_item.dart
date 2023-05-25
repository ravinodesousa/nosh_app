import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/storage.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({super.key});

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  bool _loading = false;
  String _categorydropdownvalue = 'Fast Food';
  String _typedropdownvalue = 'Veg';

  var categories = ['Fast Food', 'Dessert', 'Drinks'];
  var types = ['Veg', 'Non-Veg'];

  String? itemNameError = null;
  String? itemAmountError = null;
  String? itemImageError = null;

  TextEditingController itemName = new TextEditingController();
  TextEditingController itemAmount = new TextEditingController();

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

  void addItemHandler() async {
    final SharedPreferences prefs = await _prefs;

    dynamic itemNameValidation =
        itemName.text.trim() == "" ? "Item name is required" : null;

    final number = num.tryParse(itemAmount.text.trim());
    dynamic itemAmountValidation = number == null ? "Invalid Number" : null;

    dynamic itemImageValidation = image == null ? "Image not selected" : null;

    setState(() {
      itemNameError = itemNameValidation;
      itemAmountError = itemAmountValidation;
      itemImageError = itemImageValidation;
    });

    print(image!.path);

    if (itemNameValidation == null &&
        itemAmountValidation == null &&
        itemImageValidation == null) {
      String uploadedFileurl = await uploadFile(File(image!.path));

      if (uploadedFileurl != '') {
        Map<String, dynamic> result = await addItem(
            prefs.getString("userId") as String,
            itemName.text,
            uploadedFileurl,
            itemAmount.text,
            _categorydropdownvalue,
            _typedropdownvalue);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["status"] == 200
              ? "Uploaded Product successfully"
              : "Failed to Upload Product. Please try again."),
        ));

        if (result["status"] == 200) {
          setState(() {
            image = null;
            _categorydropdownvalue = 'Fast Food';
            _typedropdownvalue = 'Veg';
          });
          itemName.clear();
          itemAmount.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Failed to Upload Product image. Please try again.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: ModalProgressHUD(
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
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 40),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 150,
                        width: 150,
                        child: image != null
                            ? InkWell(
                                onTap: () async {
                                  await Permission.photos.request();
                                  var permissionStatus =
                                      await Permission.photos.status;
                                  if (permissionStatus.isGranted) {
                                    imageSelectionHandler();
                                  } else {
                                    // todo : show toast
                                    print(
                                        'Permission not granted. Try Again with permission access');
                                  }
                                },
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.contain,
                                  // width: MediaQuery.of(context).size.width,
                                  // height: 300,
                                ),
                              )
                            : Card(
                                color: Colors.grey,
                                child: IconButton(
                                  onPressed: () {
                                    imageSelectionHandler();
                                  },
                                  icon: Icon(Icons.add),
                                  iconSize: 50,
                                ))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(itemImageError ?? "Food Image"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.grey.shade700),
                  decoration: InputDecoration(
                    errorText: itemNameError,
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: "Enter item name",
                    labelText: "Item Name",
                    prefixIcon: Icon(
                      Icons.lunch_dining,
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
                  controller: itemName,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.grey.shade700),
                  decoration: InputDecoration(
                    errorText: itemAmountError,
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: "Enter amount",
                    labelText: "Amount",
                    prefixIcon: Icon(
                      Icons.money,
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
                  controller: itemAmount,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            child: DropdownButton(
                              isExpanded: true,
                              // Initial Value
                              value: _categorydropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: categories.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  _categorydropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            child: DropdownButton(
                              isExpanded: true,
                              // Initial Value
                              value: _typedropdownvalue,

                              // Down Arrow Icon

                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: types.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  _typedropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addItemHandler();
                  },
                  child: Text("ADD ITEM"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                )
              ],
            ),
          )),
    );
  }
}
