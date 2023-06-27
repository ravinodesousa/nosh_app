import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/screens/menu_list.dart';
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

class EditMenuItem extends StatefulWidget {
  const EditMenuItem({super.key, required this.productData});

  final Product productData;

  @override
  State<EditMenuItem> createState() => _EditMenuItemState();
}

class _EditMenuItemState extends State<EditMenuItem> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  bool _loading = false;
  String? _categorydropdownvalue = '';
  String _typedropdownvalue = 'Veg';

  List<CategoryItem> categories = [];
  var types = ['Veg', 'Non-Veg'];

  String? itemNameError = null;
  String? itemDescError = null;
  String? itemAmountError = null;
  String? itemImageError = null;

  TextEditingController itemName = new TextEditingController();
  TextEditingController itemDesc = new TextEditingController();
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

  void updateItemHandler() async {
    final SharedPreferences prefs = await _prefs;

    dynamic itemNameValidation =
        itemName.text.trim() == "" ? "Item name is required" : null;

    final number = num.tryParse(itemAmount.text.trim());
    dynamic itemAmountValidation = number == null ? "Invalid Number" : null;

    dynamic itemImageValidation =
        image == null && widget.productData.image == ''
            ? "Image not selected"
            : null;

    dynamic itemDescValidation =
        itemDesc.text.isEmpty ? "Description required" : null;

    setState(() {
      itemNameError = itemNameValidation;
      itemDescError = itemDescValidation;
      itemAmountError = itemAmountValidation;
      itemImageError = itemImageValidation;
    });

    if (itemNameValidation == null &&
        itemAmountValidation == null &&
        itemImageValidation == null &&
        itemDescValidation == null) {
      String uploadedFileurl = widget.productData.image as String;

      if (image != null) {
        uploadedFileurl = await uploadFile(File(image!.path));
      }

      if (uploadedFileurl != '') {
        Map<String, dynamic> result = await updateItem(
            prefs.getString("userId") as String,
            widget.productData.id as String,
            itemName.text,
            itemDesc.text,
            uploadedFileurl,
            itemAmount.text,
            _categorydropdownvalue,
            _typedropdownvalue);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["status"] == 200
              ? "Product Updated successfully"
              : "Failed to Update Product. Please try again."),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Failed to Upload Product image. Please try again.")));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    List<CategoryItem> temp = await getCategories(false);

    itemName.text = widget.productData.name as String;
    itemDesc.text = widget.productData.description as String;
    itemAmount.text = '${widget.productData.price}';

    setState(() {
      categories = temp;
      _typedropdownvalue = widget.productData.type as String;
      _loading = false;
      _categorydropdownvalue = widget.productData.category?.id as String;
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
      appBar: AppBar(title: Text("Edit Item")),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 40, left: 20, right: 20, top: 40),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: image != null || widget.productData.image != ''
                              ? InkWell(
                                  onTap: () {
                                    checkPermissions();
                                  },
                                  child: image != null
                                      ? Image.file(
                                          //to show image, you type like this.
                                          File(image!.path),
                                          fit: BoxFit.contain,
                                          // width: MediaQuery.of(context).size.width,
                                          // height: 300,
                                        )
                                      : Image.network(
                                          //to show image, you type like this.
                                          widget.productData.image as String,
                                          fit: BoxFit.contain,
                                          // width: MediaQuery.of(context).size.width,
                                          // height: 300,
                                        ),
                                )
                              : Card(
                                  color: Colors.grey,
                                  child: IconButton(
                                    onPressed: () {
                                      checkPermissions();
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
                      hintText: "Enter price",
                      labelText: "Price",
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
                  TextFormField(
                    style: TextStyle(color: Colors.grey.shade700),
                    decoration: InputDecoration(
                      errorText: itemDescError,
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "Enter item description",
                      labelText: "Description",
                      prefixIcon: Icon(
                        Icons.description,
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
                    controller: itemDesc,
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
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 50,
                              child: DropdownButton(
                                isExpanded: true,
                                // Initial Value
                                value: _categorydropdownvalue,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: categories.map((CategoryItem items) {
                                  return DropdownMenuItem(
                                    value: items.id,
                                    child: Text(items.name ?? ''),
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
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 50,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MenuList()));
                        },
                        child: Text("CANCEL"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateItemHandler();
                        },
                        child: Text("UPDATE ITEM"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
