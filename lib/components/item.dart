import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nosh_app/screens/item_detail.dart';

class Item extends StatelessWidget {
  String name, image, price, description, type, inv;
  CategoryItem category;
  num rating, ratingcount, reviewcount, rate1, rate2, rate3, rate4, rate5;
  int index;
  Product item;
  Item(
      {required this.index,
      required this.name,
      required this.image,
      required this.price,
      required this.rating,
      required this.description,
      required this.category,
      required this.type,
      required this.inv,
      required this.rate1,
      required this.rate2,
      required this.rate3,
      required this.rate4,
      required this.rate5,
      required this.ratingcount,
      required this.reviewcount,
      required this.item});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetail(
                      // image: image,
                      // name: name,
                      // description: description,
                      // amount: price,
                      // category: category,
                      // review: rating,
                      // type: type,
                      // inv: inv,
                      // rate1: rate1,
                      // rate2: rate2,
                      // rate3: rate3,
                      // rate4: rate4,
                      // rate5: rate5,
                      // ratingcount: ratingcount,
                      // reviewcount: reviewcount,
                      itemDetails: item,
                    )));
      },
      child: Container(
        width: width * 0.4,
        margin: EdgeInsets.only(left: 16.0),
        decoration: boxDecoration(showShadow: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  topLeft: Radius.circular(4.0)),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: "${name}_${index}",
                    child: CachedNetworkImage(
                        imageUrl: image,
                        height: width * 0.3,
                        width: width * 0.4,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(8.0),
                    // child: Icon(Icons.favorite_border,
                    //     color: Colors.white, size: 18),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text1(name,
                      fontFamily: 'Medium', maxLine: 2, isCentered: false),
                  SizedBox(
                    height: 3,
                  ),
                  text1("\u{20B9}" + price.toString(),
                      fontFamily: 'Medium', maxLine: 1, isCentered: false),
                  // Row(
                  //   children: <Widget>[
                  //     RatingBar(
                  //       initialRating: rating.toDouble(),
                  //       minRating: 1,
                  //       itemSize: 16,
                  //       direction: Axis.horizontal,
                  //       itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  //       itemBuilder: (context, _) => Icon(
                  //         Icons.star,
                  //         color: Colors.amber,
                  //       ),
                  //       onRatingUpdate: (rating) {},
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      text1(
                        type.toString().toUpperCase(),
                        textColor: Color(0xFF949292),
                        fontSize: 14.0,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      type == "Veg"
                          ? Image.asset(
                              "assets/icons/veg.png",
                              fit: BoxFit.cover,
                              width: 25,
                              height: 25,
                            )
                          : Image.asset(
                              "assets/icons/non_veg.png",
                              fit: BoxFit.cover,
                              width: 25,
                              height: 25,
                            )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
