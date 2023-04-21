import 'package:flutter/material.dart';

class OrderListItem extends StatefulWidget {
  const OrderListItem({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool showMoreInfo = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          widget.orderId,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Rs 100"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("Status : PENDING"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(),
                      //   child: IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.check,
                      //         color: Colors.green,
                      //       )),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(),
                      //   child: IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.cancel,
                      //         color: Colors.red,
                      //       )),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                showMoreInfo = !showMoreInfo;
                              });
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            )),
                      ),
                    ],
                  ),
                ]),
            if (showMoreInfo)
              Container(
                child: Column(children: [
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text(
                          "Item Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Quantity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
                    ),
                  ),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text("Item 1"), Text("3"), Text("50")],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text("Item 2"), Text("4"), Text("50")],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text("Item 3"), Text("1"), Text("50")],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ))
                ]),
              )
          ],
        ),
      ),
    );
  }
}
