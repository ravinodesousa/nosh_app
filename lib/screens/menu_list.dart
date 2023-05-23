import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/add_menu_item.dart';
import 'package:nosh_app/screens/home.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  bool _loading = true;
  List<Product> _menuList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMenu();
  }

  void initMenu() async {
    List<Product> temp =
        await getAllMenuItems("6457ff37b9f3e807e11cccd6", true);
    setState(() {
      _menuList = temp;
      _loading = false;
    });
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
                      padding: EdgeInsets.all(8),
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
                                      item.image ?? '',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(item.name ?? ''),
                                    Text("Amount: ${item.price}/-")
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(Icons.check, size: 18),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 5),
                                      padding: EdgeInsets.all(5),
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5, // <-- SEE HERE
                                ),
                                SizedBox(
                                  width: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(Icons.close, size: 18),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 5),
                                      padding: EdgeInsets.all(5),
                                      backgroundColor: Colors.red,
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
