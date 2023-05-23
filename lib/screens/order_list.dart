import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool _loading = false;
  List _orders = [
    "Order 1",
    "Order 2",
    "Order 3",
    "Order 4",
    "Order 5",
    "Order 6",
    "Order 7",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
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
        child: ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
          childCount: _orders.length,
          (context, index) {
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
                                "https://hips.hearstapps.com/hmg-prod/images/delish-220524-chocolate-milkshake-001-ab-web-1654180529.jpg?crop=0.647xw:0.972xh;0.177xw,0.0123xh&resize=1200:*",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text("x1 - Milkshake"),
                              Text("Amount: 90/-")
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("ACCEPT"),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 12),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("READY"),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 12),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("DELIVERED"),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 12),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          )
                        ],
                      ),
                    ]),
              ),
            );
          },
        )),
      ),
    );
  }
}
