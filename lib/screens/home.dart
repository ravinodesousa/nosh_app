import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/drawer/admin_drawer.dart';
import 'package:nosh_app/components/drawer/canteen_drawer.dart';
import 'package:nosh_app/components/drawer/user_drawer.dart';
import 'package:nosh_app/components/item.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/category_item.dart';
import 'package:nosh_app/screens/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, String>> Categories = [
    {"title": "Fast Food", "image": "assets/icons/fast-food.png"},
    {"title": "Drinks", "image": "assets/icons/drinks.png"},
    {"title": "Dessert", "image": "assets/icons/dessert.png"},
    {"title": "All", "image": "assets/icons/all-foods.png"}
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<String, List<Product>> _trendingItems = {
    "fastFoods": [],
    "desserts": [],
    "drinks": []
  };
  bool _loading = true;

  String userId = "";
  String userType = "USER";
  String userName = '';
  String email = '';
  String canteenName = '';
  String mobileNo = '';

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
    final SharedPreferences prefs = await _prefs;

    Map<String, List<Product>> trendingItems = await getTrendingItems(
        prefs.getString("userType") == "USER"
            ? prefs.getString("canteenId") as String
            : prefs.getString("userId") as String);

    setState(() {
      userId = prefs.getString("userId") as String;
      userType = prefs.getString("userType") as String;
      userName = prefs.getString("userName") as String;
      email = prefs.getString("email") as String;
      canteenName = prefs.getString("canteenName") as String;
      mobileNo = prefs.getString("mobileNo") as String;
      _trendingItems = trendingItems;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(Colors.transparent);
    double expandHeight = MediaQuery.of(context).size.height * 0.28;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colors.white,
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
                  actionsIconTheme: IconThemeData(opacity: 0.0),
                  title: Container(
                    height: 60,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                                        new IconButton(
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Cart(),
                                              ),
                                            );
                                          },
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
                                img: "assets/home2.jpg",
                                heading: "Hi, " + userName + "!!",
                                subheading: "~Where tasteful creations begin.",
                              ),
                              // InstaSlider(
                              //   img: "assets/home6.jpg",
                              //   heading: "Hi, " + userName + "!!",
                              //   subheading: "~Where tasteful creations begin.",
                              // ),
                            ],
                          ),
                        ),
                        // if (userType == "CANTEEN")
                        //   Align(
                        //       alignment: Alignment.bottomRight,
                        //       child: Padding(
                        //         padding:
                        //             const EdgeInsets.only(bottom: 15, right: 5),
                        //         child: ElevatedButton(
                        //           onPressed: () {},
                        //           child: Icon(
                        //             Icons.file_upload_outlined,
                        //             color: Colors.white,
                        //             size: 30,
                        //           ),
                        //           style: ButtonStyle(
                        //               padding:
                        //                   MaterialStateProperty.all<EdgeInsets>(
                        //                       EdgeInsets.zero),
                        //               foregroundColor:
                        //                   MaterialStateProperty.all<Color>(
                        //                       Colors.white),
                        //               backgroundColor:
                        //                   MaterialStateProperty.all<Color>(
                        //                       Palette.brown),
                        //               shape: MaterialStateProperty.all<
                        //                       RoundedRectangleBorder>(
                        //                   RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10),
                        //                       side: BorderSide(color: Palette.brown)))),
                        //         ),
                        //       ))
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
                                itemCount: Categories.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Filter(
                                    title: Categories[index]["title"],
                                    image: Categories[index]["image"],
                                    index: index,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      decoration: boxDecoration(showShadow: true, radius: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mHeading("Fast Food"),
                              mViewAll(
                                context,
                                "View All",
                                tags: CategoryItem(category: "Fast Food"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 8.0),
                              itemCount:
                                  _trendingItems["fastFoods"]?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(
                                    index: index,
                                    name: _trendingItems["fastFoods"]![index]
                                            .name ??
                                        '',
                                    image: _trendingItems["fastFoods"]![index]
                                            .image ??
                                        '',
                                    price:
                                        '${_trendingItems["fastFoods"]![index].price}' ??
                                            '',
                                    rating: 3,
                                    description: "test",
                                    category:
                                        _trendingItems["fastFoods"]![index]
                                                .category ??
                                            '',
                                    type: _trendingItems["fastFoods"]![index]
                                            .type ??
                                        '',
                                    inv: "45",
                                    rate1: 4,
                                    rate2: 4,
                                    rate3: 4,
                                    rate4: 4,
                                    rate5: 4,
                                    ratingcount: 4,
                                    reviewcount: 34,
                                    item: _trendingItems["fastFoods"]![index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      decoration: boxDecoration(showShadow: true, radius: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mHeading("Drinks"),
                              mViewAll(
                                context,
                                "View All",
                                tags: CategoryItem(category: "Drinks"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 8.0),
                              itemCount: _trendingItems["drinks"]?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(
                                    index: index,
                                    name:
                                        _trendingItems["drinks"]![index].name ??
                                            '',
                                    image: _trendingItems["drinks"]![index]
                                            .image ??
                                        '',
                                    price:
                                        '${_trendingItems["drinks"]![index].price}' ??
                                            '',
                                    rating: 3,
                                    description: "test",
                                    category: _trendingItems["drinks"]![index]
                                            .category ??
                                        '',
                                    type:
                                        _trendingItems["drinks"]![index].type ??
                                            '',
                                    inv: "45",
                                    rate1: 4,
                                    rate2: 4,
                                    rate3: 4,
                                    rate4: 4,
                                    rate5: 4,
                                    ratingcount: 4,
                                    reviewcount: 34,
                                    item: _trendingItems["drinks"]![index]);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Container(
                    //   decoration: boxDecoration(showShadow: true, radius: 0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       mHeading("Get Inspired By Collections"),
                    //       SizedBox(
                    //         height: 250,
                    //         child: ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: dashlistings.length,
                    //           shrinkWrap: true,
                    //           itemBuilder: (context, index) {
                    //             return Collection(dashlistings[index], index);
                    //           },
                    //         ),
                    //       ),
                    //       SizedBox(height: 16.0),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      decoration: boxDecoration(showShadow: true, radius: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mHeading("Desserts"),
                              mViewAll(
                                context,
                                "View All",
                                tags: CategoryItem(category: "Desserts"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 8.0),
                              itemCount:
                                  _trendingItems["desserts"]?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Item(
                                    index: index,
                                    name: _trendingItems["desserts"]![index]
                                            .name ??
                                        '',
                                    image: _trendingItems["desserts"]![
                                                index]
                                            .image ??
                                        '',
                                    price:
                                        '${_trendingItems["desserts"]![index].price}' ??
                                            '',
                                    rating: 3,
                                    description: "test",
                                    category: _trendingItems["desserts"]![index]
                                            .category ??
                                        '',
                                    type: _trendingItems["desserts"]![index]
                                            .type ??
                                        '',
                                    inv: "45",
                                    rate1: 4,
                                    rate2: 4,
                                    rate3: 4,
                                    rate4: 4,
                                    rate5: 4,
                                    ratingcount: 4,
                                    reviewcount: 34,
                                    item: _trendingItems["desserts"]![index]);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
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
  final String img, heading, subheading;

  InstaSlider(
      {Key? key,
      required this.img,
      required this.heading,
      required this.subheading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(img, fit: BoxFit.cover)),
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
                Column(
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
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Filter extends StatelessWidget {
  String? title;
  String? image;
  int? index;

  Filter({this.title, this.image, this.index});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryItem(
                  category: title as String,
                )));
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
                child: Image.asset(
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
