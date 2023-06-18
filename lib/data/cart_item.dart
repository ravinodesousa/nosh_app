import 'package:nosh_app/data/institution.dart';

class CartItem {
  CartItem(
      {this.id,
      this.productId,
      this.name,
      this.image,
      this.price,
      this.type,
      this.quantity,
      this.rating});

  String? id;
  String? productId;
  String? name;
  String? image;
  int? price;
  int? quantity;
  double? rating;
  String? type;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      id: json["_id"],
      productId: json["product"]["_id"],
      name: json["product"]["name"],
      image: json["product"]["image"] == '' ? null : json["product"]["image"],
      price: json["product"]["price"],
      type: json["product"]["type"],
      quantity: json["quantity"],
      rating: 0);
}
