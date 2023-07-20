import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/institution.dart';

class Payment {
  Payment(
      {this.id,
      this.startDate,
      this.endDate,
      this.canteenName,
      this.upi,
      this.canteenMobileNo,
      this.totalAmount,
      this.status,
      this.type});

  String? id;
  String? startDate;
  String? endDate;
  String? totalAmount;
  String? canteenName;
  String? canteenMobileNo;
  String? status;
  String? type;
  String? upi;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["_id"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        totalAmount: "${json["totalAmount"]}",
        canteenName: json["canteenId"]["canteenName"] ?? '',
        canteenMobileNo: json["canteenId"]["mobileNo"] ?? '',
        status: json["status"],
        type: json["type"],
        upi: json["canteenId"]["upi"] ?? '',
      );
}
