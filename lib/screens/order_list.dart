import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<OrderItem> _orders = [];
  String userType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    List<OrderItem> temp = await getOrders(prefs.getString("userId") as String,
        prefs.getString("userType") as String);

    setState(() {
      _loading = false;
      _orders = temp;
      userType = prefs.getString("userType") as String;
    });
  }

  void orderStatusChangeHandler(String orderId, String status) async {
    setState(() {
      _loading = true;
      _orders = [];
    });

    Map<String, dynamic> result = await updateOrderStatus(orderId, status);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Order Status Updated successfully"
          : "Failed to Update Order Status. Please try again."),
    ));

    initData();
  }

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
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order No : ${_orders[index].orderId ?? ''}'),
                          Text('Status: ${_orders[index].orderStatus ?? ''}'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          userType == "USER"
                              ? Text(
                                  'Canteen Name : ${_orders[index].canteenName ?? ''}')
                              : Text(
                                  'User Name : ${_orders[index].userName ?? ''}'),
                          Text(
                              'Payment Mode: ${_orders[index].paymentMode ?? ''}'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Placed on: ${_orders[index].placedOn ?? ''}'),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'ITEMS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      ..._orders[index].products!.map((product) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  product.image ??
                                      "https://hips.hearstapps.com/hmg-prod/images/delish-220524-chocolate-milkshake-001-ab-web-1654180529.jpg?crop=0.647xw:0.972xh;0.177xw,0.0123xh&resize=1200:*",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("x${product.quantity} - "),
                                    Text(
                                      "${product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Amount: "),
                                    Text('${product.price}/-',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    product.type == "Veg"
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
                          ]),
                        );
                      }),
                      // userType == "CANTEEN"
                      //     ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_orders[index].orderStatus == "PENDING")
                            ElevatedButton(
                              onPressed: () {
                                orderStatusChangeHandler(
                                    _orders[index].id ?? '', "ACCEPTED");
                              },
                              child: Text("ACCEPT"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12),
                                  padding: EdgeInsets.all(10),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          if (_orders[index].orderStatus == "ACCEPTED")
                            ElevatedButton(
                              onPressed: () {
                                orderStatusChangeHandler(
                                    _orders[index].id ?? '', "READY");
                              },
                              child: Text("READY"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12),
                                  padding: EdgeInsets.all(10),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          if (_orders[index].orderStatus == "READY")
                            ElevatedButton(
                              onPressed: () {
                                orderStatusChangeHandler(
                                    _orders[index].id ?? '', "DELIVERED");
                              },
                              child: Text("DELIVERED"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12),
                                  padding: EdgeInsets.all(10),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            )
                        ],
                      )
                      // : SizedBox()
                    ]),
              ),
            );
          },
        )),
      ),
    );
  }
}
