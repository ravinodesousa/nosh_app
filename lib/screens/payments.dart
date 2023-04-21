import 'package:flutter/material.dart';
import 'package:nosh_app/components/payment_list_item.dart';
import 'package:nosh_app/config/palette.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final usersList = [
    'Canteen 1',
    'Canteen 2',
    'Canteen 3',
    'Canteen 4',
    'Canteen 5',
    'Canteen 6',
    'Canteen 7',
    'Canteen 8',
    'Canteen 9',
    'Canteen 10',
    'Canteen 11',
    'Canteen 12',
    'Canteen 13',
  ];
  final List<String> userStatusList = <String>['PAID', 'UNPAID'];

  @override
  Widget build(BuildContext context) {
    String userStatus = userStatusList.first;
    return Scaffold(
      appBar: AppBar(title: Text("Payments")),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Palette.background,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [
                    Text("Payment Status :"),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButton<String>(
                        value: userStatus,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 1,
                          color: Colors.red,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          print(value);
                          setState(() {
                            userStatus = value!;
                          });
                        },
                        items: userStatusList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ])),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 160,
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    // return ListTile(
                    //   subtitle: Text("UNPAID"),
                    //   title: Text(usersList[index]),
                    // );

                    return PaymentListItem(userId: usersList[index]);
                  },
                  // separatorBuilder: (context, index) {
                  //   return Divider(
                  //     thickness: 2,
                  //   );
                  // },
                ),
              )
            ],
          )),
    );
  }
}
