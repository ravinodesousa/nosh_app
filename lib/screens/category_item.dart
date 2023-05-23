import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _loading = false;
  List _items = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
    "Item 7",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drinks"), actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white)),
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
                  onTap: () {},
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
                                  "https://images.unsplash.com/photo-1572490122747-3968b75cc699?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bWlsa3NoYWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Milkshake"),
                                Image.network(
                                  "https://freesvg.org/img/1531813245.png",
                                  width: 35,
                                  height: 35,
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "90 Rs",
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text("Rating"),
                              ],
                            ),
                          ]),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
