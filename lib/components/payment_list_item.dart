import 'package:flutter/material.dart';

class PaymentListItem extends StatefulWidget {
  const PaymentListItem({super.key, required this.userId});

  final String userId;

  @override
  State<PaymentListItem> createState() => _PaymentListItemState();
}

class _PaymentListItemState extends State<PaymentListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userId,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "Total: Rs 10,600",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "1st April 2023 - 16th April 2023",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "Status : PENDING",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.check,
                              color: Colors.green,
                            )),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(),
                      //   child: IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.cancel,
                      //         color: Colors.red,
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
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
