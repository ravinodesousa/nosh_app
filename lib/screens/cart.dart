import 'package:flutter/material.dart';
import 'package:count_stepper/count_stepper.dart';

enum PaymentModes { token, online }

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final orderList = [
    'Item 1',
    'Item 2',
  ];

  PaymentModes selectedPaymentMode = PaymentModes.online;

  Widget CartItem(String item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/img_logo.png',
                width: 80,
                height: 80,
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      item,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Rs 100"),
                    ),
                  ],
                ),
              ),
              CountStepper(iconColor: Theme.of(context).primaryColor),
              Padding(
                padding: EdgeInsets.only(),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cart")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          "Your Cart",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Text(" (3 Items)")
                      ],
                    ),
                  ),
                  ...orderList.expand((item) => [CartItem(item)]),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Summary",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total :",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "Rs 3000",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Mode",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        Column(children: <Widget>[
                          ListTile(
                            title: const Text('Tokens (32 Tokens Available)',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            leading: Radio(
                              value: PaymentModes.token,
                              groupValue: selectedPaymentMode,
                              onChanged: (PaymentModes? value) {
                                setState(() {
                                  selectedPaymentMode = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Online',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            leading: Radio(
                              value: PaymentModes.online,
                              groupValue: selectedPaymentMode,
                              onChanged: (PaymentModes? value) {
                                setState(() {
                                  selectedPaymentMode = value!;
                                });
                              },
                            ),
                          ),
                        ]),
                      ]),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: SizedBox(
                          width: 170,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.payment),
                                  ),
                                  Text("Proceed to Pay")
                                ],
                              ))),
                    ),
                  )
                ],
              ),
            ))));
  }
}
