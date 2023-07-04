import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/bottomsheet/qr_code.dart';
import 'package:nosh_app/components/bottomsheet/rate_order.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/helpers/date.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var orderStatuses = [
    "ALL",
    "PENDING",
    "ACCEPTED",
    "READY",
    "DELIVERED",
    "REJECTED",
    "CANCELED"
  ];
  String? _selectedOrderStatus = "ALL";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    final SharedPreferences prefs = await _prefs;

    List<OrderItem> temp = await getOrders(prefs.getString("userId") as String,
        prefs.getString("userType") as String, _selectedOrderStatus as String);

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

  void callNumHandler(OrderItem order, String userType) async {
    if (userType == "CANTEEN") {
      final Uri phoneUrl = Uri(
        scheme: 'tel',
        path: order.canteenContactNo,
      );

      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        throw "Can't call that number.";
      }
    } else {
      final Uri phoneUrl = Uri(
        scheme: 'tel',
        path: order.userContactNo,
      );

      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        throw "Can't call that number.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
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
        child: RefreshIndicator(
          onRefresh: () {
            initData();
            return Future(() => null);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: _selectedOrderStatus,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of orderStatuses
                  items: orderStatuses.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    // print("_selectedOrderStatus ${newValue}");
                    setState(() {
                      _selectedOrderStatus = newValue!;
                    });
                    initData();
                  },
                ),
              ),
              !_loading && _orders.length > 0
                  ? Expanded(
                      flex: 1,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Order No : ${_orders[index].orderId ?? ''}'),
                                        Row(
                                          children: [
                                            Text("Status : "),
                                            Chip(
                                                backgroundColor: _orders[index]
                                                            .orderStatus ==
                                                        "PENDING"
                                                    ? Colors.blue
                                                    : _orders[index].orderStatus ==
                                                                "ACCEPTED" ||
                                                            _orders[index]
                                                                    .orderStatus ==
                                                                "READY"
                                                        ? Colors.green
                                                        : _orders[index].orderStatus ==
                                                                    "REJECTED" ||
                                                                _orders[index]
                                                                        .orderStatus ==
                                                                    "CANCELED"
                                                            ? Colors.red
                                                            : Colors.grey,
                                                labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                                label: Text(
                                                    '${_orders[index].orderStatus ?? ''}')),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                    Text(
                                        'Placed on: ${formatDateTime(_orders[index].placedOn ?? '')}'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Selected Timeslot: ${_orders[index].timeSlot ?? ''}'),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        'ITEMS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    ..._orders[index].products!.map((product) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                                  Text(
                                                      "x${product.quantity} - "),
                                                  Text(
                                                    "${product.name}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (_orders[index].orderStatus ==
                                                  "PENDING") ...[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderStatusChangeHandler(
                                                        _orders[index].id ?? '',
                                                        "ACCEPTED");
                                                  },
                                                  child: Text("ACCEPT"),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderStatusChangeHandler(
                                                        _orders[index].id ?? '',
                                                        "REJECTED");
                                                  },
                                                  child: Text("REJECT"),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                )
                                              ],
                                              if (_orders[index].orderStatus ==
                                                  "ACCEPTED")
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderStatusChangeHandler(
                                                        _orders[index].id ?? '',
                                                        "READY");
                                                  },
                                                  child: Text("READY"),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                              if (_orders[index].orderStatus ==
                                                  "READY")
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderStatusChangeHandler(
                                                        _orders[index].id ?? '',
                                                        "DELIVERED");
                                                  },
                                                  child: Text("DELIVERED"),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  callNumHandler(
                                                      _orders[index], "USER");
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        fontSize: 12),
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12))),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Call Customer")
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (_orders[index].orderStatus !=
                                                  "DELIVERED")
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery
                                                                          .of(
                                                                              ctx)
                                                                      .viewInsets
                                                                      .bottom),
                                                              child:
                                                                  QrCodeBottomSheet(
                                                                id: _orders[index]
                                                                        .id ??
                                                                    '',
                                                              ));
                                                        });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.qr_code),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Show QR",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                              if (_orders[index].orderStatus ==
                                                      "DELIVERED" &&
                                                  _orders[index].isRated ==
                                                      false)
                                                ElevatedButton(
                                                  onPressed: () {
                                                    bottomsheetrating(context,
                                                        _orders[index]);
                                                  },
                                                  child: Text("Rate Order"),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  callNumHandler(_orders[index],
                                                      "CANTEEN");
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        fontSize: 12),
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12))),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Call Canteen")
                                                  ],
                                                ),
                                              ),
                                              if (_orders[index].orderStatus ==
                                                  "PENDING")
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderStatusChangeHandler(
                                                        _orders[index].id ?? '',
                                                        "CANCELED");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.cancel,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Cancel Order")
                                                    ],
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      textStyle: TextStyle(
                                                          fontSize: 12),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                ),
                                            ],
                                          )
                                  ]),
                            ),
                          );
                        },
                      )),
                    )
                  : !_loading && _orders.isEmpty
                      ? Center(
                          child: Text(
                          "No Orders Found...",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ))
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
