import 'package:flutter/foundation.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/institution.dart';

class Product {
  Product(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.category,
      this.type,
      this.rating,
      this.description,
      this.is_active,
      this.is_special_item});

  String? id;
  String? name;
  String? image;
  int? price;
  num? rating;
  String? description;
  CategoryItem? category;
  String? type;
  bool? is_active;
  bool? is_special_item;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        image: json["image"] == '' ? null : json["image"],
        price: json["price"],
        description: json["description"],
        category: CategoryItem.fromJson(json["category"]),
        type: json["type"],
        is_active: json["is_active"],
        is_special_item: json["is_special_item"],
        rating: json["rating"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "price": price,
        "description": description,
        "category": category,
        "type": type,
        "is_active": is_active,
        "is_special_item": is_special_item
      };
}
