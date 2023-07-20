import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lottie/lottie.dart';
import 'package:nosh_app/components/bottomsheet/qr_code.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/helpers/date.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/order_detail.dart';
import 'package:nosh_app/screens/order_list.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key, required this.status, required this.id});

  final String status;
  final String id;

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  OrderItem? order = null;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..forward()
      ..repeat(
        reverse: true,
      );

    initData();
  }

  void dispose() {
    if (mounted) {
      try {
        animationController.dispose();
      } catch (e) {}
    }
    super.dispose();
  }

  void initData() async {
    OrderItem? temp = await getOrderDetail(widget.id);
    setState(() {
      order = temp;
      _loading = false;
    });
  }

  Widget ImageAnimation(String path) {
    // print("animationController.value, ${animationController.value * 15}");
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return SizedBox(
            width: 230,
            height: 230,
            child: Center(
              child: Image.asset(
                path,
                width: 230 - animationController.value * 15,
                height: 230 - animationController.value * 15,
              ),
            ),
          );
        });
  }

  Widget OrderPlacedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OrderList()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                            id: order?.id,
                          )));
                },
                child: Text(
                  "view status",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAnimation("assets/icons/icon_order_placed.png"),
              SizedBox(
                height: 40,
              ),
              Text(
                "Order Placed",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(order?.placedOn ?? ''),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
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
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
                              child: QrCodeBottomSheet(
                                id: order?.id ?? '',
                              ));
                        });
                  },
                  child: Text(
                    "View QR Code",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget AcceptedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OrderList()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                            id: order?.id,
                          )));
                },
                child: Text(
                  "view status",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAnimation("assets/icons/icon_order_accepted.png"),
              SizedBox(
                height: 40,
              ),
              Text(
                "Order accepted",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(order?.placedOn ?? ''),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
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
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
                              child: QrCodeBottomSheet(
                                id: order?.id ?? '',
                              ));
                        });
                  },
                  child: Text(
                    "View QR Code",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget ReadyView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OrderList()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                            id: order?.id,
                          )));
                },
                child: Text(
                  "view status",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAnimation("assets/icons/icon_order_ready.png"),
              SizedBox(
                height: 40,
              ),
              Text(
                "Order ready",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(order?.placedOn ?? ''),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
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
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
                              child: QrCodeBottomSheet(
                                id: order?.id ?? '',
                              ));
                        });
                  },
                  child: Text(
                    "View QR Code",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget RejectedCanceledView(BuildContext context, String status) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OrderList()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                            id: order?.id,
                          )));
                },
                child: Text(
                  "view status",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAnimation("assets/icons/icon_order_canceled.png"),
              SizedBox(
                height: 40,
              ),
              Text(
                status == "ORDER-REJECTED"
                    ? "Order rejected"
                    : "Order canceled",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(order?.placedOn ?? ''),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
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
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
                              child: QrCodeBottomSheet(
                                id: order?.id ?? '',
                              ));
                        });
                  },
                  child: Text(
                    "View QR Code",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget DeliveredView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OrderList()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetail(
                            id: order?.id,
                          )));
                },
                child: Text(
                  "view status",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAnimation("assets/icons/icon_order_delivered.png"),
              SizedBox(
                height: 40,
              ),
              Text(
                "Order delivered",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(order?.placedOn ?? ''),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return ModalProgressHUD(
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
        child: Scaffold(
            extendBody: true,
            body: Container(
                child: Stack(alignment: Alignment.center, children: <Widget>[
              Image.asset(
                "assets/dash2.jpg",
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width),
                height: (MediaQuery.of(context).size.height),
              ),
              order != null
                  ? (widget.status == "ORDER-PLACED"
                      ? OrderPlacedView(context)
                      : (widget.status == "ORDER-ACCEPTED"
                          ? AcceptedView(context)
                          : widget.status == "ORDER-READY"
                              ? ReadyView(context)
                              : widget.status == "ORDER-REJECTED" ||
                                      widget.status == "ORDER-CANCELED"
                                  ? RejectedCanceledView(context, widget.status)
                                  : DeliveredView(context)))
                  : SizedBox()
              // OrderPlacedView(context)
              // AcceptedView(context)
              // ReadyView(context)
              // DeliveredView(context)
            ]))));
  }
}
