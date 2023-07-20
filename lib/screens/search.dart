import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/item_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController searchController = new TextEditingController();

  String? searchError = null;
  bool _loading = false;
  List<Product> _items = [];

  String userType = '';
  String canteenId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      userType = prefs.getString("userType") as String;
      canteenId = prefs.getString("userType") == "USER"
          ? prefs.getString("canteenId") as String
          : prefs.getString("userId") as String;
    });
  }

  void searchProducts() async {
    String? searchValidation =
        searchController.text.trim() == "" ? "Item name required" : null;

    setState(() {
      _loading = searchValidation == null ? true : false;
      searchError = searchValidation;
    });

    if (searchValidation == null) {
      List<Product> temp =
          await getSearchedItems(canteenId, searchController.text.trim());

      setState(() {
        _loading = false;
        _items = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
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
      ),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.white70,
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey.shade700),
                      decoration: InputDecoration(
                        errorText: searchError,
                        labelText: "Search item",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: "Enter item name....",
                        suffixIcon: InkWell(
                          onTap: () {
                            searchProducts();
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade700)),
                        //border: InputBorder.none,
                      ),
                      controller: searchController,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
