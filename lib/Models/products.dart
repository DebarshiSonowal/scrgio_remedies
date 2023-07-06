import 'dart:convert';
import 'dart:typed_data';

class Product {
  String? product_name, product_short_name,product_image,product_image_64;
  int? id;

  Product(
      this.product_name, this.product_short_name, this.product_image, this.id);

  Product.fromJson(json) {
    id = json["id"] ?? 0;
    product_name = json["product_name"];
    product_short_name = json["product_short_name"];
    product_image = json["product_image"];
    product_image_64 = json["product_image_64"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': product_name,
      'product_short_name': product_short_name,
      'product_image': product_image,
      'product_image_64': product_image_64,
    };
  }
}

class ProductResponse {
  bool? error;
  String? message;
  List<Product> products = [];

  ProductResponse.fromJson(json) {
    error = json["error"] ?? false;
    message = json["message"] ?? "Something went wrong";
    products = json['data']["getAllProduct"] == null
        ? []
        : (json['data']["getAllProduct"] as List)
            .map((e) => Product.fromJson(e))
            .toList();
  }

  ProductResponse.withError(msg) {
    error = true;
    message = msg;
  }
}
