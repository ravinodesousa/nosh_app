import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nosh_app/components/drawer/canteen_drawer.dart';
import 'package:nosh_app/components/drawer/user_drawer.dart';
import 'package:nosh_app/components/item.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> Listings1 = ["Fast Food", "Drinks", "Dessert", "All"];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String role = "user";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      // Listings1 = getFilterFavourites();
    } catch (e) {
      print("error");
    }
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
        drawer: CanteenDrawer(),
        // UserDrawer() , AdminDrawer()
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandHeight,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                titleSpacing: 0,
                backgroundColor:
                    innerBoxIsScrolled ? Color(0xFFffffff) : Color(0xFFffffff),
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Search()));
                              },
                            ),
                            role == "user"
                                ? Stack(
                                    children: <Widget>[
                                      new IconButton(
                                        icon: Icon(
                                          Icons.shopping_cart,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => Cart(
                                          //     ),
                                          //   ),
                                          // );
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
                              heading: "Hii, " + "User" + "!!",
                              subheading: "~Where tasteful creations begin.",
                            ),
                            InstaSlider(
                              img: "assets/home6.jpg",
                              heading: "Hii, " + "User" + "!!",
                              subheading: "~Where tasteful creations begin.",
                            )
                          ],
                        ),
                      ),
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
                              itemCount: Listings1.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Filter(
                                  listings1: Listings1[index],
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
                            mViewAll(context, "View All", tags: null),
                          ],
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 8.0),
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Item(
                                index: index,
                                name: "Burger ${index + 1}",
                                image:
                                    "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YnVyZ2VyfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                                price: "90",
                                rating: 3,
                                description: "test",
                                category: "drinks",
                                type: "soft-drink",
                                inv: "45",
                                docid: "2442424",
                                rate1: 4,
                                rate2: 4,
                                rate3: 4,
                                rate4: 4,
                                rate5: 4,
                                ratingcount: 4,
                                reviewcount: 34,
                              );
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
                            mViewAll(context, "View All", tags: null),
                          ],
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 8.0),
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Item(
                                index: index,
                                name: "Drink ${index + 1}",
                                image:
                                    "https://www.jiomart.com/images/product/original/491121060/coca-cola-1-75-l-product-images-o491121060-p491121060-0-202206022121.jpg",
                                price: "90",
                                rating: 3,
                                description: "test",
                                category: "drinks",
                                type: "soft-drink",
                                inv: "45",
                                docid: "2442424",
                                rate1: 4,
                                rate2: 4,
                                rate3: 4,
                                rate4: 4,
                                rate5: 4,
                                ratingcount: 4,
                                reviewcount: 34,
                              );
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
                            mViewAll(context, "View All", tags: null),
                          ],
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 8.0),
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Item(
                                index: index,
                                name: "Dessert ${index + 1}",
                                image:
                                    "https://cdn.loveandlemons.com/wp-content/uploads/2021/06/summer-desserts-500x500.jpg",
                                price: "90",
                                rating: 3,
                                description: "test",
                                category: "drinks",
                                type: "soft-drink",
                                inv: "45",
                                docid: "2442424",
                                rate1: 4,
                                rate2: 4,
                                rate3: 4,
                                rate4: 4,
                                rate5: 4,
                                ratingcount: 4,
                                reviewcount: 34,
                              );
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
  String? listings1;
  int? index;

  Filter({this.listings1, this.index});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => model.tags));
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Container(
              decoration: boxDecoration(bgColor: Colors.red, radius: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.network(
                  "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80",
                  height: width * 0.12,
                  width: width * 0.12,
                ),
              ),
            ),
            text(listings1.toString(), textColor: Color(0xFF757575))
          ],
        ),
      ),
    );
  }
}
