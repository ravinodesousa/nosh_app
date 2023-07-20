import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as Badges;

class ItemDetail extends StatefulWidget {
  const ItemDetail({super.key, required this.itemDetails, this.previousRoute});
  final Product itemDetails;
  final String? previousRoute;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = false;

  int quantity = 1;
  String userType = '';
  int cartItems = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    List<CartItem> temp2 = await getCartItems(
        prefs.getString("userId") as String,
        prefs.containsKey("canteenId")
            ? prefs.getString("canteenId") as String
            : '');

    setState(() {
      userType = prefs.getString("userType") as String;
      cartItems = temp2.length;
    });
  }

  void quantityBtnHandler(String action) {
    if (action == "INCREMENT" && quantity < 20) {
      setState(() {
        quantity = ++quantity;
      });
    } else if (action == "DECREMENT" && quantity > 1) {
      setState(() {
        quantity = --quantity;
      });
    }
  }

  void addToCartHandler() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _loading = true;
    });
    Map<String, dynamic> data = await addToCart(
        prefs.getString("userId") ?? '', widget.itemDetails.id ?? '', quantity);

    Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: data["status"] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    initData();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (widget.previousRoute == "HOME") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.grey.shade100,
          actions: [
            userType == "USER"
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cart(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17, right: 20),
                      child: Badges.Badge(
                        badgeContent: Text("${cartItems}"),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                          size: 25,
                        ),
                        badgeStyle: Badges.BadgeStyle(badgeColor: Colors.white),
                      ),
                    ),
                  )
                : Spacer()
          ]),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.itemDetails.image ??
                        "https://images.unsplash.com/photo-1572490122747-3968b75cc699?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bWlsa3NoYWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 30, left: 30, right: 30),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.itemDetails.name ?? '',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Text(
                                "${widget.itemDetails.price ?? 0} Rs",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              if ((widget.itemDetails.rating ?? 0) > 0) ...[
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                    decoration: new BoxDecoration(
                                        color:
                                            (widget.itemDetails.rating ?? 0) > 2
                                                ? Colors.green
                                                : Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 2,
                                          bottom: 2),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${widget.itemDetails.rating ?? 0}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    )),
                              ]
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.itemDetails.category?.name
                                      .toString()
                                      .toUpperCase() ??
                                  '')
                            ],
                          ),
                          widget.itemDetails.type == "Veg"
                              ? Image.asset(
                                  "assets/icons/veg.png",
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                )
                              : Image.asset(
                                  "assets/icons/non_veg.png",
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.itemDetails.description ?? ''}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      userType == "USER"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Quantity",
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            quantityBtnHandler("INCREMENT");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    bottomLeft:
                                                        Radius.circular(30))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Text(
                                            quantity.toString(),
                                            style: TextStyle(fontSize: 19),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            quantityBtnHandler("DECREMENT");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30),
                                                    bottomRight:
                                                        Radius.circular(30))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    addToCartHandler();
                                  },
                                  child: Text("Add To Cart"),
                                )
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
