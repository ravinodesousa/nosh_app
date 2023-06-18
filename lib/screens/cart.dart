import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/order_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nosh_app/data/cart_item.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<CartItem> _cartitems = [];
  User? userDetails = null;

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
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _loading = true;
    });
    final SharedPreferences prefs = await _prefs;

    userDetails = await getUserDetails(prefs.getString("userId") as String);

    List<CartItem> temp =
        await getCartItems(prefs.getString("userId") as String);

    setState(() {
      _cartitems = temp;
      _loading = false;
    });
  }

  void deleteHandler(String id) async {
    setState(() {
      _loading = true;
      _cartitems = [];
    });

    Map<String, dynamic> data = await deleteFromCart(id);

    Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: data["status"] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    initData();
  }

  void quantityBtnHandler(String action, String? id) async {
    setState(() {
      _loading = true;
      _cartitems = [];
    });

    Map<String, dynamic> data = await changeCartQuantity(action, id);

    Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: data["status"] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    initData();
  }

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
        child: _cartitems.length > 0
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 250,
                      child: RefreshIndicator(
                        onRefresh: () {
                          initData();
                          return Future(() => null);
                        },
                        child: ListView.custom(
                            childrenDelegate: SliverChildBuilderDelegate(
                          childCount: _cartitems.length,
                          (context, index) {
                            return Card(
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                _cartitems[index].image ??
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
                                                      "x${_cartitems[index].quantity} - "),
                                                  Text(
                                                    "${_cartitems[index].name}",
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
                                                  Text(
                                                      '${_cartitems[index].price}/-',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  _cartitems[index].type ==
                                                          "Veg"
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              quantityBtnHandler("INCREMENT",
                                                  _cartitems[index].id);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  30))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              "${_cartitems[index].quantity}",
                                              style: TextStyle(fontSize: 19),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              quantityBtnHandler("DECREMENT",
                                                  _cartitems[index].id);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  30))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    deleteHandler(
                                                        _cartitems[index].id ??
                                                            '');
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Time Slot",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
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
                            onChanged: (String? newValue) {
                              setState(() {
                                _timeslotdropdownvalue = newValue!;
                              });
                            },
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
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummary(
                                    cartItems: _cartitems,
                                    timeSlot: _timeslotdropdownvalue,
                                    userDetails: userDetails)));
                          },
                          child: const Text('Order'),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Container(
                    child: Text(
                      "No items found...",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
