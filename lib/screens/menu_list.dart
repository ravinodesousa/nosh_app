import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:count_stepper/count_stepper.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final canteenList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
    'Item 13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Canteen 1 menu")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: GridView.count(
                childAspectRatio: (1 /
                    1.8), // this line is the one determines the width-height ratio

                crossAxisCount: 2,
                children: List.generate(canteenList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: Center(
                        child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/img_logo.png',
                                      // width: 100,
                                      height: 90,
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 5),
                                      child: Text(
                                        canteenList[index],
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 15),
                                      child: Text(
                                        "Rs 100",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CountStepper(
                                              iconColor: Theme.of(context)
                                                  .primaryColor)
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Palette.brown,
                                        ),
                                        Icon(
                                          Icons.favorite_border_outlined,
                                          color: Palette.brown,
                                        )
                                      ],
                                    )
                                  ]),
                            ))),
                  );
                }))));
  }
}
