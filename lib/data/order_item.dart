import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/institution.dart';

class OrderItem {
  OrderItem(
      {this.id,
      this.orderId,
      this.products,
      this.canteenName,
      this.userName,
      this.orderStatus,
      this.paymentMode,
      this.timeSlot,
      this.placedOn});

  String? id;
  String? orderId;
  List<CartItem>? products;
  String? canteenName;
  String? userName;
  String? orderStatus;
  String? paymentMode;
  String? timeSlot;
  String? placedOn;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
      id: json["_id"],
      orderId: json["orderId"],
      canteenName: json["canteenId"]["canteenName"] ?? '',
      userName: json["userId"]["canteenName"] ?? '',
      orderStatus: json["orderStatus"],
      paymentMode: json["paymentMode"],
      timeSlot: json["timeSlot"],
      placedOn: json["createdAt"],
      products: (json["products"] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList());
}
