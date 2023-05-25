import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/add_menu_item.dart';
import 'package:nosh_app/screens/edit_menu_item.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<Product> _menuList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMenu();
  }

  void initMenu() async {
    final SharedPreferences prefs = await _prefs;

    List<Product> temp = await getAllMenuItems(
        prefs.getString("userId") as String, true,
        category: null);
    setState(() {
      _menuList = temp;
      _loading = false;
    });
  }

  void changeProductStatus(String id, bool status) async {
    setState(() {
      _loading = true;
      _menuList = [];
    });
    Map<String, dynamic> result = await updateItemStatus(id, status);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Product Status Updated successfully"
          : "Failed to Update Product Status. Please try again."),
    ));

    initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Menu"), actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddMenuItem()));
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Item",
            style: TextStyle(color: Colors.white),
          ),
        )
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
        child: !_loading && _menuList.length > 0
            ? ListView.custom(
                childrenDelegate: SliverChildBuilderDelegate(
                childCount: _menuList.length,
                (context, index) {
                  Product item = _menuList.elementAt(index);

                  return Card(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8, right: 8, top: 15, bottom: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      item.image ??
                                          'http://via.placeholder.com/640x360',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Amount: ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${item.price}/-",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(item.category ?? ''),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        // Text(item.type ?? '')
                                        item.type == "Veg"
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
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            EditMenuItem(productData: item),
                                      ));
                                    },
                                    child: Icon(Icons.edit, size: 18),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 5),
                                      padding: EdgeInsets.all(5),
                                      backgroundColor: Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10, // <-- SEE HERE
                                ),
                                (item.is_active ?? false)
                                    ? SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            changeProductStatus(
                                                item.id as String, false);
                                          },
                                          child: Icon(Icons.close, size: 18),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 5),
                                            padding: EdgeInsets.all(5),
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            changeProductStatus(
                                                item.id as String, true);
                                          },
                                          child: Icon(Icons.check, size: 18),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 5),
                                            padding: EdgeInsets.all(5),
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ]),
                    ),
                  );
                },
              ))
            : !_loading && _menuList.length == 0
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      "No Items Found",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ))
                : SizedBox(),
      ),
    );
  }
}
