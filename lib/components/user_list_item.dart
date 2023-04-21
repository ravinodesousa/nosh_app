import 'package:flutter/material.dart';

class UserListItem extends StatefulWidget {
  const UserListItem({super.key, required this.userId});

  final String userId;
  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          widget.userId,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("Status : PENDING"),
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
                      Padding(
                        padding: EdgeInsets.only(),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
