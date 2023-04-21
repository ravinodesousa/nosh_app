import 'package:flutter/material.dart';
import 'package:nosh_app/components/user_list_item.dart';
import 'package:nosh_app/config/palette.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final usersList = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
    'User 6',
    'User 7',
    'User 8',
    'User 9',
    'User 10',
    'User 11',
    'User 12',
    'User 13',
  ];
  final List<String> userTypeList = <String>['User', 'Canteen'];
  final List<String> userStatusList = <String>['ACTIVE', 'INACTIVE', 'PENDING'];

  @override
  Widget build(BuildContext context) {
    String userType = userTypeList.first;
    String userStatus = userStatusList.first;
    return Scaffold(
      appBar: AppBar(title: Text("User/Canteen List")),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Palette.background,
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text("User Type :"),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: DropdownButton<String>(
                              value: userType,
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
                                  userType = value!;
                                });
                              },
                              items: userTypeList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ])),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text("User Status :"),
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
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ])),
                  ]),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 160,
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    // return ListTile(
                    //   subtitle: Text("ACTIVE"),
                    //   title: Text(usersList[index]),
                    // );

                    return UserListItem(userId: usersList[index]);
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
