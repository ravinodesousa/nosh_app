import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nosh_app/config/constants.dart';
import 'package:nosh_app/data/institution.dart';
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
      body: jsonEncode({email, password}),
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

Future<User?> signup(String email, String password) async {
  try {
    final url = Uri.parse(baseURL + "user/signup");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({email, password}),
    );

    if (response.statusCode == 200) {
      User data = User.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Request failed');
    }
  } catch (err) {
    print(err);
    return null;
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

Future<List<Product>> getAllMenuItems(String userId, bool showAllItems) async {
  try {
    Map<String, dynamic> data = {userId: userId};

    if (!showAllItems) {
      data["is_active"] = true;
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
