import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scrgio_remedies/Models/products.dart';

import '../Models/generic_response.dart';
import '../Models/indivisual_image.dart';
import '../Storage/local_storage.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  final String baseUrl = "https://dashboard.sergioremedies.com";

  final String path = "api/v1/user";

  Dio? dio;

  Future<GenericResponse> login(
    String email,
    String password,
    double x,
    double y,
  ) async {
    var data = {
      'username': email,
      // 'mobile': email,
      'password': password,
      'x': x,
      'y': y,
    };
    BaseOptions option = BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer ${Storage.instance.token}'
          // 'APP-KEY': ConstanceData.app_key
        });
    var url = "$baseUrl/$path/login";
    // var url = "http://asamis.assam.gov.in/api/login";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: jsonEncode(data),
      );
      debugPrint("login response: ${response?.data} ${response?.headers}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("login error response: ${response?.data}");
        return GenericResponse.withError(response?.data['error']
            ? response?.data['message']['success']
            : response?.data['message']['error']);
      }
    } on DioError catch (e) {
      debugPrint("login  error: ${e.error} ${e.response?.data}");
      return GenericResponse.withError(
          e.response?.data['message'] ?? "Something went wrong");
    }
  }

  Future<ProductResponse> products() async {
    BaseOptions option = BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Storage.instance.token}'
          // 'APP-KEY': ConstanceData.app_key
        });
    var url = "$baseUrl/$path/getAllProduct";
    // var url = "http://asamis.assam.gov.in/api/login";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint(
          "ProductResponse response: ${response?.data} ${response?.headers}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProductResponse.fromJson(response?.data);
      } else {
        debugPrint("ProductResponse error response: ${response?.data}");
        return ProductResponse.withError(response?.data['error']
            ? response?.data['message']['success']
            : response?.data['message']['error']);
      }
    } on DioError catch (e) {
      debugPrint("ProductResponse  error: ${e.error} ${e.response?.data}");
      return ProductResponse.withError(
          e.response?.data['message'] ?? "Something went wrong");
    }
  }

  Future<IndividualImageResponse> individualProduct(id) async {
    BaseOptions option = BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Storage.instance.token}'
          // 'APP-KEY': ConstanceData.app_key
        });
    var url = "$baseUrl/$path/getProductImage/$id";
    // var url = "http://asamis.assam.gov.in/api/login";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint(
          "IndividualImageResponse response: ${response?.data} ${response?.headers}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return IndividualImageResponse.fromJson(response?.data);
      } else {
        debugPrint("IndividualImageResponse error response: ${response?.data}");
        return IndividualImageResponse.withError(response?.data['error']
            ? response?.data['message']['success']
            : response?.data['message']['error']);
      }
    } on DioError catch (e) {
      debugPrint(
          "IndividualImageResponse  error: ${e.error} ${e.response?.data}");
      return IndividualImageResponse.withError(
          e.response?.data['message'] ?? "Something went wrong");
    }
  }
}
