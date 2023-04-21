import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final itemsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
    'Item 13',
  ];

  Widget ItemCard(String item) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Status : ACTIVE"),
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
                          Icons.edit,
                          color: Colors.blue,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  )
                ],
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Menu")),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Palette.background,
          child: ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              // return ListTile(
              //   subtitle: Text("Rs. 123"),
              //   title: Text(itemsList[index]),
              // );

              return ItemCard(itemsList[index]);
            },
            // separatorBuilder: (context, index) {
            //   return Divider(
            //     thickness: 2,
            //   );
            // },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Palette.brown,
        ));
  }
}
