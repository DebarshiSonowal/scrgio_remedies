import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/products.dart';

class Storage {
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  Future<void> initializeStorage() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    await sharedpreferences.setString("token", token);
    await sharedpreferences.setBool("isLoggedIn", true);
  }

  Future<void> setProductList(List<Product> products) async {
    List<String> encodedList =
        products.map((item) => jsonEncode(item.toJson())).toList();
    await sharedpreferences.setStringList("products", encodedList);
  }

  Future<List<Product>> getListFromProductsRoutineSharedPreferences() async {
    List<String>? encodedList = sharedpreferences.getStringList('products');
    if (encodedList == null) {
      return [];
    }
    List<Product> list =
        encodedList.map((item) => Product.fromJson(jsonDecode(item))).toList();
    return list;
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get token => sharedpreferences.getString("token") ?? "";

  // void logout() {}
  Future<void> clean() async {
    await sharedpreferences.clear();
  }
}
