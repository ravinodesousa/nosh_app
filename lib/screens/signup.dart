import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final List<String> userTypeList = <String>['User', 'Canteen'];

  @override
  Widget build(BuildContext context) {
    String userType = userTypeList.first;
    return Scaffold(
        body: Container(
            color: Palette.background,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 15),
                  child: Image.asset(
                    'assets/images/img_avatar.png',
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text("Type"),
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
                          items: userTypeList
                              .map<DropdownMenuItem<String>>((String value) {
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
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name',
                              hintText: 'Enter First Name',
                            ),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last Name',
                            hintText: 'Enter Last Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No',
                      hintText: 'Enter Mobile No',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      hintText: 'Enter Password Again',
                    ),
                  ),
                ),

                // Address Start
                if (userType == userTypeList.last)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pincode',
                                    hintText: 'Enter Pincode',
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'City',
                                  hintText: 'Enter City',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'State',
                                  hintText: 'Enter State',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 1,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'H.no / Building Name',
                                    hintText: 'Enter H.no / Building Name',
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Locality/Area/Street',
                            hintText: 'Enter Locality/Area/Street',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Landmark (optional)',
                            hintText: 'Enter Landmark',
                          ),
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        InkWell(onTap: () {}, child: Text(" click here")),
                      ]),
                ),

                // Address End
                Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 10),
                    child: SizedBox(
                      width: 130,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.save,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "REGISTER",
                                ),
                              )
                            ],
                          )),
                    ))
              ],
            ))));
  }
}
