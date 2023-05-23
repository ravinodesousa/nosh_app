import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lottie/lottie.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool _loading = false;
  String order_status = "CONFIRMED"; // CONFIRMED, INPROGRESS, READY

  Widget ConfirmedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "view status",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 300,
              ),
              Text(
                "Order Confirmed",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "12th April 2023, 10:25 AM",
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
                  onPressed: () {},
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

  Widget InprogressReadyView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Lottie.asset(
            order_status == "INPROGRESS"
                ? 'assets/icons/icon_cooking.zip'
                : 'assets/icons/icon_food_ready.zip',
            alignment: Alignment.center,
            // width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            fit: BoxFit.fill,
          ),
          Text(
            order_status == "INPROGRESS"
                ? "Your order is being prepared..."
                : "Your order is ready",
            style: TextStyle(color: Colors.white, fontSize: 19),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   shadowColor: Colors.black,
            // ),
            body: Container(
                child: Stack(alignment: Alignment.center, children: <Widget>[
              Image.asset(
                "assets/dash2.jpg",
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width),
                height: (MediaQuery.of(context).size.height),
              ),
              // ConfirmedView(context)
              InprogressReadyView(context)
            ]))));
  }
}
