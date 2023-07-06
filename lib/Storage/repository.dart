
import 'package:flutter/material.dart';

import '../Models/products.dart';

class Repository extends ChangeNotifier{
  List<Product> _products=[];

  void addProducts(List<Product> list){
    _products = list;
    notifyListeners();
  }

  List<Product> get products => _products;
}