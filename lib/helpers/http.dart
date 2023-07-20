import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/institution.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/data/token_history.dart';
import 'package:nosh_app/data/user.dart';
import 'package:nosh_app/data/payment.dart';
import 'package:nosh_app/screens/payments.dart';

final Map<String, String> headers = {
  'Content-Type': 'application/json; charset=UTF-8'
};

Future<List<Institution>> getAllInstitutions() async {
  try {
    final url = Uri.parse(baseURL + "user/get-institutions");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Institution> list = [];
      List data = jsonDecode(response.body);
      data.forEach((item) => {list.add(Institution.fromJson(item))});
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<Map<String, dynamic>> login(
    String? fcmToken, String email, String password) async {
  try {
    final url = Uri.parse(baseURL + "user/login");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
          {"email": email, "password": password, "fcmToken": fcmToken}),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      User data = User.fromJson(jsonDecode(response.body));
      // return data;
      return {"successful": true, "data": data};
    } else {
      // todo: show alert from backend
      dynamic data = jsonDecode(response.body);
      print(data);
      return {
        "successful": false,
        "message": data["message"] ?? "Request failed. Please try again."
      };
    }
  } catch (err) {
    print(err);
    return {
      "successful": false,
      "message": "Request failed. Please try again."
    };
  }
}

Future<Map<String, dynamic>> signup(
    String userType,
    String name,
    String email,
    String password,
    String mobileNo,
    String institution,
    String canteenName,
    String upi) async {
  try {
    final url = Uri.parse(baseURL + "user/signup");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "userType": userType,
        "username": name,
        "email": email,
        "password": password,
        "mobileNo": mobileNo,
        "institution": institution,
        "canteenName": canteenName,
        "upi": upi
      }),
    );

    if (response.statusCode == 200) {
      // User data = User.fromJson(jsonDecode(response.body));
      return {"successful": true, "message": "User successfully registered"};
    } else {
      dynamic data = jsonDecode(response.body);
      print(data);
      return {
        "successful": false,
        "message": data["message"] ?? "Request failed. Please try again."
      };
    }
  } catch (err) {
    print(err);
    return {
      "successful": false,
      "message": "Request failed. Please try again."
    };
  }
}

Future<Map<String, dynamic>> updateProfile(
    String userId,
    String? profilePic,
    String? canteenImage,
    String? name,
    String? email,
    String? mobileNo,
    String? institution,
    String? canteenName,
    bool changePassword,
    String? password,
    String? upi) async {
  try {
    final url = Uri.parse(baseURL + "user/update-profile");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "userId": userId,
        "profilePic": profilePic,
        "username": name,
        "email": email,
        "mobileNo": mobileNo,
        "institution": institution,
        "canteenName": canteenName,
        "changePassword": changePassword,
        "password": password,
        "canteenImage": canteenImage,
        "upi": upi
      }),
    );

    if (response.statusCode == 200) {
      // User data = User.fromJson(jsonDecode(response.body));
      return {
        "successful": true,
        "message":
            "Profile successfully updated. You will be redirected to login screen."
      };
    } else {
      dynamic data = jsonDecode(response.body);
      print(data);
      return {
        "successful": false,
        "message": data["message"] ?? "Request failed. Please try again."
      };
    }
  } catch (err) {
    print(err);
    return {
      "successful": false,
      "message": "Request failed. Please try again."
    };
  }
}

Future<String?> getCarouselImage(String userId) async {
  try {
    final url = Uri.parse(baseURL + "user/canteen-image");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      print("response.body: ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["image"] == "" ? null : data["image"];
    } else {
      return null;
    }
  } catch (err) {
    print("err : ${err}");
    return null;
  }
}

Future<Map<String, dynamic>> uploadCanteenCoverImage(
    String userId, String canteenImage) async {
  try {
    final url = Uri.parse(baseURL + "user/update-canteen-image");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "userId": userId,
        "canteenImage": canteenImage,
      }),
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print("data : ${data}");
      return {"successful": true, "message": "Image successfully updated"};
    } else {
      dynamic data = jsonDecode(response.body);
      print("data1 : ${data}");
      return {
        "successful": false,
        "message": data["message"] ?? "Request failed. Please try again."
      };
    }
  } catch (err) {
    print("err : ${err}");
    return {
      "successful": false,
      "message": "Request failed. Please try again."
    };
  }
}

Future<Map<String, dynamic>?> sendOTP(String mobileNo, String type) async {
  try {
    final url = Uri.parse(baseURL + "user/send-otp");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"mobileNo": mobileNo, "type": type}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data12322 : ${data}");
      return {"status": 200, "message": data["message"]};
    } else {
      // todo: show alert from backend
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data error : ${data}");
      return {"status": 500, "message": data["message"] ?? "Request failed"};
    }
  } catch (err) {
    print(err);
    return {"status": 500, "message": "Failed to send OTP"};
  }
}

Future<Map<String, dynamic>?> verifyOTP(
    String mobileNo, String otp, String type) async {
  try {
    final url = Uri.parse(baseURL + "user/verify-otp");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"mobileNo": mobileNo, "otp": otp, "type": type}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data12322 : ${data}");
      return {"status": 200, "message": data["message"]};
    } else {
      // todo: show alert from backend
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data error : ${data}");
      return {"status": 500, "message": data["message"] ?? "Request failed"};
    }
  } catch (err) {
    print(err);
    return {"status": 500, "message": "Failed to verify OTP"};
  }
}

Future<Map<String, dynamic>?> resetUserPassword(
    String mobileNo, String password) async {
  try {
    final url = Uri.parse(baseURL + "user/reset-password");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "mobileNo": mobileNo,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data12322 : ${data}");
      return {"status": 200, "message": data["message"]};
    } else {
      // todo: show alert from backend
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data error : ${data}");
      return {"status": 500, "message": data["message"] ?? "Request failed"};
    }
  } catch (err) {
    print(err);
    return {"status": 500, "message": "Failed to verify OTP"};
  }
}

Future<List<User>> getAllUsers(String userType,
    {bool fetchInactiveUsers = false}) async {
  try {
    final url = Uri.parse(baseURL + "user/users");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
          {"userType": userType, "fetchInactiveUsers": fetchInactiveUsers}),
    );

    if (response.statusCode == 200) {
      List<User> list = [];
      print("response ${response.body}");
      List data = jsonDecode(response.body);
      print("data ${data}");
      data.forEach((item) => {list.add(User.fromJson(item))});
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<List<dynamic>> getCanteenListWithSpecialMenu() async {
  try {
    final url = Uri.parse(baseURL + "user/canteen-list-with-special-menu");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      print("response ${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      print("data ${data}");

      return data;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<Map<String, dynamic>> updateUserStatus(
  String id,
  String status,
) async {
  try {
    Map<String, dynamic> data = {
      "id": id,
      "status": status,
    };

    final url = Uri.parse(baseURL + "user/update-status");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<List<Product>> getAllMenuItems(String userId, bool showAllItems,
    {String? category = null, String? status = "ALL"}) async {
  try {
    Map<String, dynamic> data = {"userId": userId, "status": status};

    if (!showAllItems) {
      data["is_active"] = true;
    }

    if (category != null) {
      data["category"] = category;
    }

    final url = Uri.parse(baseURL + "product/items");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<Product> list = [];
      List data = jsonDecode(response.body);
      print("date1 : ${data}");
      data.forEach((item) => {list.add(Product.fromJson(item))});
      print("list1 : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<List<Product>> getSearchedItems(
    String canteenId, String searchedItem) async {
  try {
    Map<String, dynamic> data = {
      "canteenId": canteenId,
      "searchedItem": searchedItem
    };

    final url = Uri.parse(baseURL + "product/search");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<Product> list = [];
      List data = jsonDecode(response.body);
      print("date1 : ${data}");
      data.forEach((item) => {list.add(Product.fromJson(item))});
      print("list1 : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<Map<String, dynamic>> addItem(
    String userId,
    String itemName,
    String itemDesc,
    String itemImage,
    String itemAmount,
    String? category,
    String type) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "name": itemName,
      "description": itemDesc,
      "price": itemAmount,
      "category": category,
      "type": type,
      "image": itemImage
    };

    final url = Uri.parse(baseURL + "product/add-item");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> updateItem(
    String userId,
    String id,
    String itemName,
    String itemDesc,
    String itemImage,
    String itemAmount,
    String? category,
    String type) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "id": id,
      "name": itemName,
      "description": itemDesc,
      "price": itemAmount,
      "category": category,
      "type": type,
      "image": itemImage
    };

    final url = Uri.parse(baseURL + "product/update-item");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> updateItemStatus(
  String id,
  bool status,
) async {
  try {
    Map<String, dynamic> data = {
      "id": id,
      "status": status,
    };

    final url = Uri.parse(baseURL + "product/update-item-status");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> updateSpecialMenu(String id) async {
  try {
    Map<String, dynamic> data = {
      "id": id,
    };

    final url = Uri.parse(baseURL + "product/update-special-menu");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> getTrendingItems(String userId) async {
  try {
    Map<String, dynamic> params = {"userId": userId};

    final url = Uri.parse(baseURL + "product/trending-items");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> trendingProducts = {};
      // print("date2 : ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      print("date1 : ${data}");
      // data.keys.forEach((key) {
      //   List<dynamic> item = data[key] as List<dynamic>;
      //   List<Product> newProducts = [];

      //   item.forEach((item2) => {newProducts.add(Product.fromJson(item2))});

      //   trendingProducts[key] = newProducts;
      //   print("list1 : ${trendingProducts}");
      // });
      trendingProducts["categories"] = data["filteredCategories"];
      trendingProducts["data"] = data["data"];
      trendingProducts["trendingFoods"] = data["trendingFoods"];

      return trendingProducts;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return {"categories": [], "data": [], "trendingFoods": []};
  }
}

Future<Map<String, dynamic>> addToCart(
  String userId,
  String id,
  int qty,
) async {
  try {
    Map<String, dynamic> data = {"userId": userId, "id": id, "quantity": qty};

    final url = Uri.parse(baseURL + "user/add-to-cart");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {"status": 200, "message": "Item Successfully Added to cart"};
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 200, "message": "Failed to add Item to cart"};
  }
}

Future<List<CartItem>> getCartItems(String userId, String canteenId) async {
  try {
    Map<String, dynamic> data = {"userId": userId, "canteenId": canteenId};

    final url = Uri.parse(baseURL + "user/cart-items");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<CartItem> list = [];
      List data = jsonDecode(response.body);
      print("date1 : ${data}");
      data.forEach((item) => {list.add(CartItem.fromJson(item))});
      print("list1 : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return [];
  }
}

Future<Map<String, dynamic>> deleteFromCart(String id) async {
  try {
    Map<String, dynamic> data = {"id": id};

    final url = Uri.parse(baseURL + "user/delete-from-cart");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {"status": 200, "message": "Item Successfully removed from cart"};
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 200, "message": "Failed to remove Item from cart"};
  }
}

Future<Map<String, dynamic>> changeCartQuantity(
    String action, String? id) async {
  try {
    Map<String, dynamic> data = {"id": id, "action": action};

    final url = Uri.parse(baseURL + "user/change-cart-quantity");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {"status": 200, "message": "Item quantity successfully changed"};
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 200, "message": "Failed to change Item quantity"};
  }
}

Future<Map<String, dynamic>> placeOrder(
    String userId,
    String canteenId,
    String timeslot,
    String paymentMode,
    List<CartItem> cartItems,
    String? txnId,
    num totalAmount) async {
  try {
    List<Map<String, dynamic>> newCartItems = [];

    cartItems.forEach((item) => {
          newCartItems.add({
            "id": item.id,
            "productId": item.productId,
            "quantity": item.quantity
          })
        });

    Map<String, dynamic> data = {
      "userId": userId,
      "canteenId": canteenId,
      "timeslot": timeslot,
      "paymentMode": paymentMode,
      "cartItems": newCartItems,
      "txnId": txnId,
      "totalAmount": totalAmount
    };

    final url = Uri.parse(baseURL + "order/place-order");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      return {
        "status": 200,
        "message": "Order successfully placed.",
        "id": data["id"]
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {
      "status": 500,
      "message": "Failed to place order. Please try again."
    };
  }
}

Future<List<OrderItem>> getOrders(
    String userId, String userType, String orderStatus) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "userType": userType,
      "orderStatus": orderStatus
    };

    final url = Uri.parse(baseURL + "order/my-orders");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<OrderItem> list = [];
      // print(response.body);
      List data = jsonDecode(response.body);
      // print("date1 : ${data}");
      data.forEach((item) => {list.add(OrderItem.fromJson(item))});
      print("list1 : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return [];
  }
}

Future<OrderItem?> getOrderDetail(String orderId) async {
  try {
    Map<String, dynamic> data = {
      "orderId": orderId,
    };

    final url = Uri.parse(baseURL + "order/order-details");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));

      OrderItem data = OrderItem.fromJson(jsonDecode(response.body));

      print(data);
      return data;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return null;
  }
}

Future<Map<String, dynamic>> updateOrderStatus(
  String id,
  String status,
) async {
  try {
    Map<String, dynamic> data = {
      "id": id,
      "status": status,
    };

    final url = Uri.parse(baseURL + "order/update-order-status");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> getTokenHistory(String userId) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
    };

    final url = Uri.parse(baseURL + "user/token-history");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = {};
      List<TokenHistory> list = [];
      // print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      print("date1 : ${data}");

      data["token_history"]
          .forEach((item) => {list.add(TokenHistory.fromJson(item))});
      print("list1 : ${list}");
      res["balance"] = data["balance"];
      res["token_history"] = list;

      return res;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err454545 : ${err}");
    return {"balance": 0, "token_history": []};
  }
}

Future<Map<String, dynamic>> addTokenToAccoount(
    String userId, String txnId, String amount) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "txnId": txnId,
      "amount": amount,
    };

    final url = Uri.parse(baseURL + "user/add-tokens");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<User?> getUserDetails(String userId) async {
  try {
    final url = Uri.parse(baseURL + "user/user-details");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200) {
      User userDetails = User();
      print("response ${response.body}");
      userDetails = User.fromJson(jsonDecode(response.body));
      print("data ${userDetails}");

      return userDetails;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return null;
  }
}

Future<List<dynamic>> getNotifications(
  String userId,
) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
    };

    final url = Uri.parse(baseURL + "notification/");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // print(response.body);
      List<dynamic> list = jsonDecode(response.body);
      print("list : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return [];
  }
}

Future<Map<String, dynamic>> getDashboardData(
    String userId, String userType, String? startDate, String? endDate) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "userType": userType,
      "startDate": startDate,
      "endDate": endDate
    };

    final url = Uri.parse(baseURL + "user/dashboard");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data : ${data}");
      return data;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {};
  }
}

Future<Map<String, dynamic>> getCommission(
  String? date,
) async {
  try {
    Map<String, dynamic> data = {
      "date": date,
    };

    final url = Uri.parse(baseURL + "order/commission");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Map<String, dynamic> list = jsonDecode(response.body);
      print("list : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {};
  }
}

Future<Map<String, dynamic>?> getPayments(
    String? date, String? userType) async {
  try {
    Map<String, dynamic> data = {"date": date, "userType": userType};

    final url = Uri.parse(baseURL + "order/payments");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<Payment> list = [];
      // print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      print("date1 : ${data}");
      data["payments"].forEach((item) => {list.add(Payment.fromJson(item))});
      // print("list1 : ${list}");
      return {"payments": list, "admin": data["admin"]};
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return null;
  }
}

Future<Map<String, dynamic>> updatePaymentStatus(String id) async {
  try {
    Map<String, dynamic> data = {"id": id};

    final url = Uri.parse(baseURL + "order/update-payment-status");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> rateOrder(
    String userId, String orderId, List<Map<String, dynamic>> ratings) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "orderId": orderId,
      "ratings": ratings,
    };

    final url = Uri.parse(baseURL + "order/rate-order");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<List<CategoryItem>> getCategories(bool showAll) async {
  try {
    Map<String, dynamic> data = {
      "showAll": showAll,
    };

    final url = Uri.parse(baseURL + "category/");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<CategoryItem> list = [];
      // print(response.body);
      List data = jsonDecode(response.body);
      // print("date1 : ${data}");
      data.forEach((item) => {list.add(CategoryItem.fromJson(item))});
      print("list1 : ${list}");
      return list;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return [];
  }
}

Future<Map<String, dynamic>> addCategory(String name, String image) async {
  try {
    Map<String, dynamic> data = {"name": name, "image": image};

    final url = Uri.parse(baseURL + "category/add-category");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> updateCategory(
    String id, String name, String image) async {
  try {
    Map<String, dynamic> data = {"id": id, "name": name, "image": image};

    final url = Uri.parse(baseURL + "category/update");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}

Future<Map<String, dynamic>> updateCategoryStatus(String id) async {
  try {
    Map<String, dynamic> data = {
      "id": id,
    };

    final url = Uri.parse(baseURL + "category/update-status");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {
        "status": 200,
      };
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print("err : ${err}");
    return {"status": 500};
  }
}
