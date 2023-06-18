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
      this.placedOn,
      this.isRated,
      this.canteenContactNo,
      this.userContactNo});

  String? id;
  String? orderId;
  List<CartItem>? products;
  String? canteenName;
  String? userName;
  String? orderStatus;
  String? paymentMode;
  String? timeSlot;
  String? placedOn;
  String? canteenContactNo;
  String? userContactNo;
  bool? isRated;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
      id: json["_id"],
      orderId: json["orderId"],
      canteenName: json["canteenId"]["canteenName"] ?? '',
      userName: json["userId"]["username"] ?? '',
      orderStatus: json["orderStatus"],
      paymentMode: json["paymentMode"],
      isRated: json["isRated"] ?? false,
      timeSlot: json["timeSlot"],
      placedOn: json["createdAt"],
      canteenContactNo: json["canteenId"]["mobileNo"] ?? '',
      userContactNo: json["userId"]["mobileNo"] ?? '',
      products: (json["products"] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList());
}
