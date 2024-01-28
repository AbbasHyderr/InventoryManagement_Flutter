import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:octdaily/errorhandling.dart';
import 'package:octdaily/ProductModel.dart';
import 'package:octdaily/utils.dart';

class ProductServices {

  // Method to update a product
  void updateProduct({
    required BuildContext context,
    required String id,
    required String name,
    required String productId,
    required double price,
    required int quantity,
  }) async {
    try {
      // Creating a Product object with updated data
      final Product product = Product(
        name: name,
        price: price,
        quantity: quantity,
        productId: productId,
        id: id,
      );

      // Making a PUT request to update the product
      http.Response res = await http.put(
        Uri.parse('https://localhost:7035/api/Product/$productId?id=$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: product.toJson(),
      );

      // Handling the response and showing a success message
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Updated Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // Handling errors and showing an error message
      showSnackBar(context, e.toString());
    }
  }

  // Method to fetch all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    List<Product> productList = [];
    try {
      // Making a GET request to fetch all products
      http.Response res = await http.get(
        Uri.parse('https://localhost:7035/api/Product'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      // Handling the response and populating the productList
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Handling errors and showing an error message
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  // Method to delete a product
  Future<void> deleteProduct({
    required BuildContext context,
    required String id,
  }) async {
    try {
      // Making a DELETE request to delete the product
      http.Response res = await http.delete(
        Uri.parse('https://localhost:7035/api/Product?id=$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handling the response and showing a success message
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Investment withdrawal successful',
          );
        },
      );
    } catch (e) {
      // Handling errors and showing an error message
      showSnackBar(context, e.toString());
    }
  }

  // Method to add a new product
  Future<void> addProduct({
    required BuildContext context,
    required String name,
    required double price,
    required String productId,
    required String id,
    required int quantity,
  }) async {
    try {
      // Creating a Product object with new product data
      final Product product = Product(
        name: name,
        price: price,
        quantity: quantity,
        productId: productId,
        id: id,
      );

      // Making a POST request to add the new product
      http.Response res = await http.post(
        Uri.parse('https://localhost:7035/api/Product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: product.toJson(),
      );

      // Handling the response and showing a success message
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully! Please refresh the page');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // Handling errors and showing an error message
      showSnackBar(context, e.toString());
    }
  }
}
