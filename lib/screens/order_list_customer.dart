import 'package:flutter/material.dart';
import 'package:nosh_app/components/order_list_item.dart';
import 'package:nosh_app/config/palette.dart';

class OrderListCustomer extends StatefulWidget {
  const OrderListCustomer({super.key});

  @override
  State<OrderListCustomer> createState() => _OrderListCustomerState();
}

class _OrderListCustomerState extends State<OrderListCustomer> {
  final orderList = [
    'Order-1',
    'Order-2',
    'Order-3',
    'Order-4',
    'Order-5',
    'Order-6',
    'Order-7',
    'Order-8',
    'Order-9',
    'Order-10',
    'Order-11',
    'Order-12',
    'Order-13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Orders")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                // return ListTile(
                //   subtitle: Text("Order data"),
                //   title: Text(orderList[index]),
                // );
                return OrderListItem(
                  orderId: orderList[index],
                );
              },
              // separatorBuilder: (context, index) {
              //   return Divider(
              //     thickness: 2,
              //   );
              // },
            )));
  }
}
