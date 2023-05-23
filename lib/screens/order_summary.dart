import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool _loading = false;
  List _orderitems = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
    "Item 7",
  ];

  String _paymentdropdownvalue = 'Online';
  var _payments = [
    "Online",
    "Token",
    "Cash On Delivery",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
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
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 70,
                  ),
                  Column(
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("9876543210")
                        ],
                      )
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
                  Text(
                    "Order Slot",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "09:00 AM - 10:00 AM",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Palette.brown),
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
                  Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: DropdownButton(
                      isExpanded: true,
                      // Initial Value
                      value: _paymentdropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: _payments.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order Details",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.custom(
                      childrenDelegate: SliverChildBuilderDelegate(
                childCount: _orderitems.length,
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
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    "1",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  );
                },
              ))),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Place Order'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
