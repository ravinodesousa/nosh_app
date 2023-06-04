import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/institution.dart';

class Payment {
  Payment({
    this.id,
    this.startDate,
    this.endDate,
    this.canteenName,
    this.totalAmount,
    this.status,
  });

  String? id;
  String? startDate;
  String? endDate;
  String? totalAmount;
  String? canteenName;
  String? status;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
      id: json["_id"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      totalAmount: json["totalAmount"],
      canteenName: json["canteenId"]["canteenName"] ?? '',
      status: json["status"]);
}
