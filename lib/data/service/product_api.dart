import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApi {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final data = jsonDecode(response.body);

    final List products = data['products'];

    return products
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<Product> getProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load product');
    }

    final data = jsonDecode(response.body);

    return Product.fromJson(data);
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=$query'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search products');
    }

    final data = jsonDecode(response.body);

    final List products = data['products'];

    return products
        .map((json) => Product.fromJson(json))
        .toList();
  }
}