import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/drawer/admin_drawer.dart';
import 'package:nosh_app/components/drawer/canteen_drawer.dart';
import 'package:nosh_app/components/drawer/user_drawer.dart';
import 'package:nosh_app/components/item.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/storage.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/category_item.dart' as category_item_screen;
import 'package:nosh_app/screens/search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as Badges;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // List<Category> Categories = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Map<String, dynamic> _trendingItems = {
    "categories": [],
    "data": [],
    "trendingFoods": []
  };
  bool _loading = false;

  String userId = "";
  String userType = "USER";
  String userName = '';
  String email = '';
  String canteenName = '';
  String mobileNo = '';
  String? carouselImage = null;
  int cartItems = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      // Categories = getFilterFavourites();
      initData();
    } catch (e) {
      print("error");
    }
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    final SharedPreferences prefs = await _prefs;

    Map<String, dynamic> trendingItems = await getTrendingItems(
        prefs.getString("userType") == "USER"
            ? prefs.getString("canteenId") as String
            : prefs.getString("userId") as String);

    String? tempCarouselImage = await getCarouselImage(
        prefs.getString("userType") == "USER"
            ? prefs.getString("canteenId") as String
            : prefs.getString("userId") as String);

    (trendingItems["categories"] as List).add({
      "_id": "",
      "name": "All",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/nosh-canteen-mgt.appspot.com/o/all-foods.png?alt=media&token=33be3a37-ec2d-4c78-89cb-109d2295dd17"
    });

    List<CartItem> temp = await getCartItems(
        prefs.getString("userId") as String,
        prefs.containsKey("canteenId")
            ? prefs.getString("canteenId") as String
            : '');

    setState(() {
      userId = prefs.getString("userId") as String;
      userType = prefs.getString("userType") as String;
      userName = prefs.getString("userName") as String;
      email = prefs.getString("email") as String;
      canteenName = prefs.getString("canteenName") as String;
      mobileNo = prefs.getString("mobileNo") as String;
      _trendingItems = trendingItems;
      carouselImage = tempCarouselImage;
      cartItems = temp.length;
      _loading = false;
    });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print(img);
    if (img != null) {
      List<String> filename = img!.name.split(".");
      print("name ${filename.toString()}");
      if (['jpeg', 'jpg', 'png'].contains(filename.last)) {
        String uploadedFileurl = await uploadFile(File(img!.path));
        print("uploadedFileurl: ${uploadedFileurl}");
        if (uploadedFileurl != '') {
          Map<String, dynamic> result =
              await uploadCanteenCoverImage(userId as String, uploadedFileurl);

          Fluttertoast.showToast(
              msg: result["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor:
                  result["successful"] == true ? Colors.green : Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          print("result : ${result}");
          if (result["successful"] == true) {
            initData();
          }
        } else {
          Fluttertoast.showToast(
              msg: "Failed to upload image. Try again...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Only following image formats are allowed: jpeg,jpg,png",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      // todo: show toast about camera error
      Fluttertoast.showToast(
          msg: "Failed to upload image. Try again...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height * 0.28;
    var width = MediaQuery.of(context).size.width;

    /* ModalProgressHUD - creates an overlay to display loader */

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colors.black,
            )),
        drawer: userType == "CANTEEN"
            ? CanteenDrawer()
            : (userType == "USER" ? UserDrawer() : AdminDrawer()),
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
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: expandHeight,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  titleSpacing: 0,
                  backgroundColor: innerBoxIsScrolled
                      ? Color(0xFFffffff)
                      : Color(0xFFffffff),
                  actionsIconTheme: IconThemeData(
                    opacity: 0.0,
                  ),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.black,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      );
                    },
                  ),
                  title: Container(
                    height: 60,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              // IconButton(
                              //   icon: Icon(Icons.menu, color: Colors.black,size: 25,),
                              //   onPressed: () {
                              //     _scaffoldKey.currentState.openDrawer();
                              //   },
                              // ),
                              SizedBox(
                                width: 10,
                              ),
                              text('Home',
                                  textColor: Colors.black,
                                  fontSize: 25.0,
                                  fontFamily: 'Bold'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Search(),
                                    ),
                                  );
                                },
                              ),
                              userType == "USER"
                                  ? Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Cart(),
                                              ),
                                            );
                                          },
                                          child: Badges.Badge(
                                            badgeContent: Text("${cartItems}"),
                                            child: Icon(
                                              Icons.shopping_cart,
                                              color: Colors.black,
                                              size: 25,
                                            ),
                                            badgeStyle: Badges.BadgeStyle(
                                                badgeColor: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                            right: 11,
                                            top: 11,
                                            child: new Container())
                                      ],
                                    )
                                  : SizedBox(width: 0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                    height: expandHeight,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: PageView(
                            children: <Widget>[
                              InstaSlider(
                                img: carouselImage != null
                                    ? carouselImage as String
                                    : "assets/home2.jpg",
                                imageType:
                                    carouselImage != null ? "NETWORK" : "LOCAL",
                                heading: "Hi, " + userName + "!!",
                                subheading: "~Where tasteful creations begin.",
                              ),
                            ],
                          ),
                        ),
                        if (userType == "CANTEEN")
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 15, right: 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    checkPermissions();
                                  },
                                  child: Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.zero),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Palette.brown),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(color: Palette.brown)))),
                                ),
                              ))
                      ],
                    ),
                  )),
                ),
              ];
            },
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: Color(0xFFf8f8f8),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(width: 5.0, height: 50.0),
                        TyperAnimatedTextKit(
                            onTap: () {
                              print("Tap Event");
                            },
                            text: ["Feeling Hungry? Try Nosh!!!"],
                            textStyle: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Bold",
                                color: Colors.green),
                            textAlign: TextAlign.start),
                        SizedBox(width: 5.0, height: 50.0),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      height: 160,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, bottom: 16),
                                child: text1("Filter your Category",
                                    fontSize: 20.0, fontFamily: 'Medium'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _trendingItems["categories"]?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  CategoryItem cat = CategoryItem.fromJson(
                                      _trendingItems["categories"]![index]);
                                  return Filter(
                                    title: cat.name,
                                    image: cat.image,
                                    index: index,
                                    id: cat.id,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    if ((_trendingItems["trendingFoods"]?.length ?? 0) > 0) ...[
                      Container(
                        decoration: boxDecoration(showShadow: true, radius: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mHeading("Trending Items"),
                              ],
                            ),
                            SizedBox(
                              height: 240,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(bottom: 8.0),
                                itemCount:
                                    _trendingItems["trendingFoods"]?.length ??
                                        0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Product prod = Product.fromJson(
                                      _trendingItems["trendingFoods"]![index]);
                                  return Item(
                                      index: index,
                                      name: prod.name ?? '',
                                      image: prod.image ?? '',
                                      price: '${prod.price}' ?? '',
                                      rating: 3,
                                      description: "test",
                                      category: prod.category as CategoryItem,
                                      type: prod.type ?? '',
                                      inv: "45",
                                      rate1: 4,
                                      rate2: 4,
                                      rate3: 4,
                                      rate4: 4,
                                      rate5: 4,
                                      ratingcount: 4,
                                      reviewcount: 34,
                                      item: prod);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                    ...(_trendingItems["data"] as List)
                        .map(
                          (dynamic item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              decoration:
                                  boxDecoration(showShadow: true, radius: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      mHeading(item["name"]),
                                      mViewAll(
                                        context,
                                        "View All",
                                        tags: category_item_screen.CategoryItem(
                                            category: item["name"],
                                            categoryId: item["id"]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 240,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      itemCount: item["items"]?.length ?? 0,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        Product prod = Product.fromJson(
                                            item["items"][index]);
                                        return Item(
                                            index: index,
                                            name: prod.name ?? '',
                                            image: prod.image ?? '',
                                            price: '${prod.price}' ?? '',
                                            rating: 3,
                                            description: "test",
                                            category:
                                                prod.category as CategoryItem,
                                            type: prod.type ?? '',
                                            inv: "45",
                                            rate1: 4,
                                            rate2: 4,
                                            rate3: 4,
                                            rate4: 4,
                                            rate5: 4,
                                            ratingcount: 4,
                                            reviewcount: 34,
                                            item: prod);
                                      },
                                    ),
                                  ),
                                ].toList(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InstaSlider extends StatelessWidget {
  final String img, heading, subheading, imageType;

  InstaSlider(
      {Key? key,
      required this.img,
      required this.imageType,
      required this.heading,
      required this.subheading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: imageType == "LOCAL"
                ? Image.asset(img, fit: BoxFit.cover)
                : Image.network(img, fit: BoxFit.cover)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(heading,
                          textColor: Colors.white,
                          fontSize: 24.0,
                          fontFamily: 'Bold',
                          maxLine: 2),
                      SizedBox(
                        height: 10,
                      ),
                      text1(subheading,
                          textColor: Colors.white,
                          fontFamily: 'Andina',
                          isLongText: true),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0),
        //   ),
        // )
      ],
    );
  }
}

class Filter extends StatelessWidget {
  String? title;
  String? image;
  int? index;
  String? id;

  Filter({this.title, this.image, this.index, this.id});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => category_item_screen.CategoryItem(
                category: title as String, categoryId: id as String)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Container(
              decoration:
                  boxDecoration(bgColor: Colors.grey.shade200, radius: 12),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  image.toString(),
                  height: width * 0.12,
                  width: width * 0.12,
                ),
              ),
            ),
            text(title.toString(), textColor: Color(0xFF757575))
          ],
        ),
      ),
    );
  }
}
