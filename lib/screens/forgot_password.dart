import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/img_logo.png',
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.height / 2.3,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Remembered your password?"),
                        InkWell(onTap: () {}, child: Text(" click here")),
                        Text(" to login"),
                      ]),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 10),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.password,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "RESET PASSWORD",
                                ),
                              )
                            ],
                          )),
                    ))
              ],
            )));
  }
}
