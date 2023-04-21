import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Palette.background,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        InkWell(onTap: () {}, child: Text(" click here")),
                      ]),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 10),
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.login_rounded,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "LOGIN",
                                ),
                              )
                            ],
                          )),
                    ))
              ],
            )));
  }
}
