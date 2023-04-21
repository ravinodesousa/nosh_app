import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class CanteenList extends StatefulWidget {
  const CanteenList({super.key});

  @override
  State<CanteenList> createState() => _CanteenListState();
}

class _CanteenListState extends State<CanteenList> {
  final canteenList = [
    'Canteen 1',
    'Canteen 2',
    'Canteen 3',
    'Canteen 4',
    'Canteen 5',
    'Canteen 6',
    'Canteen 7',
    'Canteen 8',
    'Canteen 9',
    'Canteen 10',
    'Canteen 11',
    'Canteen 12',
    'Canteen 13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("All Canteens")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: GridView.count(
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
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                            Icons.favorite_border_outlined),
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                    Image.asset(
                                      'assets/images/img_logo.png',
                                      // width: 100,
                                      height: 50,
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        canteenList[index],
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text("View menu"))
                                  ]),
                            ))),
                  );
                }))));
  }
}
