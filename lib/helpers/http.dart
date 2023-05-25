import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/data/cart_item.dart';
import 'package:nosh_app/data/institution.dart';
import 'package:nosh_app/data/order_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/data/user.dart';

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

Future<User?> login(String email, String password) async {
  try {
    final url = Uri.parse(baseURL + "user/login");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      User data = User.fromJson(jsonDecode(response.body));
      return data;
    } else {
      // todo: show alert from backend
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return null;
  }
}

Future<Map<String, dynamic>> signup(
    String userType,
    String name,
    String email,
    String password,
    String mobileNo,
    String institution,
    String canteenName) async {
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
        "canteenName": canteenName
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

Future<List<User>> getAllUsers(String userType) async {
  try {
    final url = Uri.parse(baseURL + "user/users");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"userType": userType}),
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

Future<List<Product>> getAllMenuItems(String userId, bool showAllItems,
    {String? category = null}) async {
  try {
    Map<String, dynamic> data = {"userId": userId};

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

Future<Map<String, dynamic>> addItem(String userId, String itemName,
    String itemImage, String itemAmount, String category, String type) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "name": itemName,
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
    String itemImage,
    String itemAmount,
    String category,
    String type) async {
  try {
    Map<String, dynamic> data = {
      "userId": userId,
      "id": id,
      "name": itemName,
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

Future<Map<String, List<Product>>> getTrendingItems(String userId) async {
  try {
    Map<String, dynamic> params = {"userId": userId};

    final url = Uri.parse(baseURL + "product/trending-items");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      Map<String, List<Product>> trendingProducts = {};
      print("date2 : ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      print("date1 : ${data}");
      data.keys.forEach((key) {
        List<dynamic> item = data[key] as List<dynamic>;
        List<Product> newProducts = [];

        item.forEach((item2) => {newProducts.add(Product.fromJson(item2))});

        trendingProducts[key] = newProducts;
        print("list1 : ${trendingProducts}");
      });

      return trendingProducts;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return {"fastFoods": [], "desserts": [], "drinks": []};
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

Future<List<CartItem>> getCartItems(String userId) async {
  try {
    Map<String, dynamic> data = {"userId": userId};

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

Future<Map<String, dynamic>> placeOrder(String userId, String canteenId,
    String timeslot, String paymentMode, List<CartItem> cartItems) async {
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
      "cartItems": newCartItems
    };

    final url = Uri.parse(baseURL + "order/place-order");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {"status": 200, "message": "Order successfully placed."};
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

Future<List<OrderItem>> getOrders(String userId, String userType) async {
  try {
    Map<String, dynamic> data = {"userId": userId, "userType": userType};

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