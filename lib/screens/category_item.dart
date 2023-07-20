import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/item_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as Badges;

class CategoryItem extends StatefulWidget {
  const CategoryItem(
      {super.key, required this.category, required this.categoryId});
  final String category;
  final String categoryId;
  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<Product> _items = [];

  String userType = '';
  int cartItems = 0;

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
    final SharedPreferences prefs = await _prefs;

    List<Product> temp = await getAllMenuItems(
        prefs.getString("userType") == "USER"
            ? prefs.getString("canteenId") as String
            : prefs.getString("userId") as String,
        false,
        category: widget.category != "All" ? widget.categoryId : null,
        status: "ALL");

    List<CartItem> temp2 = await getCartItems(
        prefs.getString("userId") as String,
        prefs.containsKey("canteenId")
            ? prefs.getString("canteenId") as String
            : '');

    setState(() {
      _items = temp;
      cartItems = temp2.length;
      _loading = false;
      userType = prefs.getString("userType") as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.category),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
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
                      padding: const EdgeInsets.only(top: 17, right: 10),
                      child: Badges.Badge(
                        badgeContent: Text("${cartItems}"),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          // size: 25,
                        ),
                        badgeStyle: Badges.BadgeStyle(badgeColor: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: Colors.white))
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
        child: RefreshIndicator(
          onRefresh: () {
            initData();
            return Future(() => null);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.65),
                physics: BouncingScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (BuildContext buildCtx, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ItemDetail(
                                previousRoute: "",
                                itemDetails: _items[index],
                              )));
                    },
                    child: Card(
                      color: Color.fromARGB(255, 240, 240, 240),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 150,
                                  // width: 50,
                                  child: Image.network(
                                    _items[index].image ??
                                        "https://images.unsplash.com/photo-1572490122747-3968b75cc699?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bWlsa3NoYWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_items[index].name ?? ''),
                                  _items[index].type == "Veg"
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_items[index].price ?? ''}/- Rs",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  // Text("Rating"),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
