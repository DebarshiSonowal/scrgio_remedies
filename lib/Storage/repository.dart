import 'package:flutter/material.dart';

import '../Models/products.dart';
import 'local_storage.dart';

class Repository extends ChangeNotifier {
  List<Product> _products = [];

  void addProducts(List<Product> list) {
    _products = list;
    notifyListeners();
  }

  List<Product> get products => _products;

  void updateProduct(int? id, String? image) async{
    _products.firstWhere((element) => element.id == id).product_image_64 =
        image;
    String token = await Storage.instance.token;
    await Storage.instance.clean();
    await Storage.instance.setToken(token);
    await Storage.instance.setProductList(_products);
    notifyListeners();
  }
}
