import 'package:nosh_app/data/institution.dart';

class TokenHistory {
  TokenHistory(
      {this.id, this.balance_included, this.payment_date, this.payment_amount});

  String? id;
  int? balance_included;
  String? payment_date;
  String? payment_amount;

  factory TokenHistory.fromJson(Map<String, dynamic> json) => TokenHistory(
      id: json["_id"],
      balance_included: json["balance_included"],
      payment_date: json["paymentDetails"]["date"],
      payment_amount: json["paymentDetails"]["amount"]);
}
