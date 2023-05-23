import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _loading = false;
  List _cartitems = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
    "Item 7",
  ];
  String _timeslotdropdownvalue = '09:00 AM - 10:00 AM';
  var _timeslots = [
    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "12:00 PM - 01:00 PM",
    "01:00 PM - 02:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
    "04:00 PM - 05:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 250,
              child: ListView.custom(
                  childrenDelegate: SliverChildBuilderDelegate(
                childCount: _cartitems.length,
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
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ]),
                    ),
                  );
                },
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  "Time Slot",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: DropdownButton(
                    isExpanded: true,
                    // Initial Value
                    value: _timeslotdropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: _timeslots.map((String items) {
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Order'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
