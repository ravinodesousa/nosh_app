import 'package:nosh_app/data/institution.dart';

class User {
  User({
    this.id,
    this.username,
    this.canteenName,
    this.institution,
    this.profilePicture,
    this.email,
    this.isEmailConfirmed,
    this.mobileNo,
    this.isMobileNoConfirmed,
    this.password,
    this.tokenBalance,
    this.fcmToken,
    this.userType,
    this.userStatus,
  });

  String? id;
  String? username;
  String? canteenName;
  String? institution;
  String? profilePicture;
  String? email;
  bool? isEmailConfirmed;
  String? mobileNo;
  bool? isMobileNoConfirmed;
  String? password;
  int? tokenBalance;
  String? fcmToken;
  String? userType;
  String? userStatus;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        canteenName: json["canteenName"],
        institution:
            json["institution"] != null ? json["institution"]["name"] : '',
        profilePicture: json["profilePicture"],
        email: json["email"],
        isEmailConfirmed: json["isEmailConfirmed"],
        mobileNo: json["mobileNo"],
        isMobileNoConfirmed: json["isMobileNoConfirmed"],
        password: json["password"],
        tokenBalance: json["tokenBalance"],
        fcmToken: json["fcmToken"],
        userType: json["userType"],
        userStatus: json["userStatus"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "canteenName": canteenName,
        "institution": institution,
        "profilePicture": profilePicture,
        "email": email,
        "isEmailConfirmed": isEmailConfirmed,
        "mobileNo": mobileNo,
        "isMobileNoConfirmed": isMobileNoConfirmed,
        "password": password,
        "tokenBalance": tokenBalance,
        "fcmToken": fcmToken,
        "userType": userType,
        "userStatus": userStatus,
      };
}
