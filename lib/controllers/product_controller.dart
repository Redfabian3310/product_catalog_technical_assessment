import 'package:flutter/foundation.dart';

import '../data/models/product.dart';
import '../data/service/product_api.dart';

class ProductController extends ChangeNotifier {
  final ProductApi _api = ProductApi();

  List<Product> products = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _api.getProducts();
    } catch (e) {
      errorMessage = 'Unable to load products. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}