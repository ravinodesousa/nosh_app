import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/bottomsheet/rate_order.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/date.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key, required this.id});
  final String? id;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  String? userType = '';
  OrderItem? orderDetail = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    final SharedPreferences prefs = await _prefs;

    OrderItem? temp = await getOrderDetail(widget.id as String);
    setState(() {
      userType = prefs.getString("userType") as String;
      orderDetail = temp;
      _loading = false;
    });
  }

  void orderStatusChangeHandler(
      String orderId, String status, BuildContext context) async {
    setState(() {
      _loading = true;
    });

    Map<String, dynamic> result = await updateOrderStatus(orderId, status);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Order Status Updated successfully"
          : "Failed to Update Order Status. Please try again."),
    ));

    initData();
  }

  bottomsheetrating(BuildContext context, OrderItem orderItem) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (ctx) {
          return Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: RateOrderBottomSheet(
                orderItem: orderItem,
                initCallback: () => {initData()},
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(orderDetail?.orderId ?? '' as String),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => OrderList()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
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
          padding: const EdgeInsets.all(20.0),
          child: orderDetail != null
              ? Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order No : ${orderDetail?.orderId ?? ''}'),
                          Row(
                            children: [
                              Text("Status : "),
                              Chip(
                                  backgroundColor:
                                      orderDetail?.orderStatus == "PENDING"
                                          ? Colors.blue
                                          : orderDetail?.orderStatus ==
                                                      "ACCEPTED" ||
                                                  orderDetail?.orderStatus ==
                                                      "READY"
                                              ? Colors.green
                                              : Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  label: Text(
                                      '${orderDetail?.orderStatus ?? ''}')),
                            ],
                          )
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
                                  'Canteen Name : ${orderDetail?.canteenName ?? ''}')
                              : Text(
                                  'User Name : ${orderDetail?.userName ?? ''}'),
                          Text(
                              'Payment Mode: ${orderDetail?.paymentMode ?? ''}'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Placed on :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${formatDateTime(orderDetail?.placedOn ?? '')}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Selected time slot :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${orderDetail?.timeSlot ?? ''}',
                          ),
                        ],
                      ),
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
                      SizedBox(
                        height: 20,
                      ),
                      ...orderDetail!.products!.map((product) {
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
                                    Text("Price: "),
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
                      SizedBox(
                        height: 20,
                      ),
                      userType == "CANTEEN"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (orderDetail?.orderStatus == "PENDING")
                                  ElevatedButton(
                                    onPressed: () {
                                      orderStatusChangeHandler(
                                          orderDetail?.id ?? '',
                                          "ACCEPTED",
                                          context);
                                    },
                                    child: Text("ACCEPT"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 12),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  ),
                                if (orderDetail?.orderStatus == "ACCEPTED")
                                  ElevatedButton(
                                    onPressed: () {
                                      orderStatusChangeHandler(
                                          orderDetail?.id ?? '',
                                          "READY",
                                          context);
                                    },
                                    child: Text("READY"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 12),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  ),
                                if (orderDetail?.orderStatus == "READY")
                                  ElevatedButton(
                                    onPressed: () {
                                      orderStatusChangeHandler(
                                          orderDetail?.id ?? '',
                                          "DELIVERED",
                                          context);
                                    },
                                    child: Text("DELIVERED"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 12),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (orderDetail?.orderStatus == "DELIVERED" &&
                                    orderDetail?.isRated == false)
                                  ElevatedButton(
                                    onPressed: () {
                                      bottomsheetrating(
                                          context, orderDetail as OrderItem);
                                    },
                                    child: Text("Rate Order"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 12),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  )
                              ],
                            )
                    ],
                  ),
                )
              : !_loading
                  ? Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Error occured....",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  initData();
                                },
                                icon: Icon(Icons.refresh),
                                label: Text("Refresh"))
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
        ),
      ),
    );
  }
}
