import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class TokenHistory extends StatefulWidget {
  const TokenHistory({super.key});

  @override
  State<TokenHistory> createState() => _TokenHistoryState();
}

class _TokenHistoryState extends State<TokenHistory> {
  final tokenHistory = [
    '1000 Tokens',
    '1001 Tokens',
    '1002 Tokens',
    '1003 Tokens',
    '1004 Tokens',
    '1005 Tokens',
    '1006 Tokens',
    '1007 Tokens',
    '1008 Tokens',
    '1009 Tokens',
    '1010 Tokens',
    '1011 Tokens',
    '1012 Tokens',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Token History")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Palette.background,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Text("Total Balance : 23,000",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 160,
                  child: ListView.separated(
                    itemCount: tokenHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text("On 16th April 2023"),
                        title: Text(tokenHistory[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 2,
                      );
                    },
                  ),
                )
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Palette.brown,
        ));
  }
}
