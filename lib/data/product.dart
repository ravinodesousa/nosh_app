import 'package:nosh_app/data/institution.dart';

class Product {
  Product(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.category,
      this.type,
      // this.description,
      this.is_active});

  String? id;
  String? name;
  String? image;
  double? price;
  // String? description;
  String? category;
  String? type;
  bool? is_active;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        price: double.parse(json["price"]),
        // description: json["description"],
        category: json["category"],
        type: json["type"],
        is_active: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "price": price,
        // "description": description,
        "category": category,
        "type": type,
        "is_active": is_active,
      };
}
