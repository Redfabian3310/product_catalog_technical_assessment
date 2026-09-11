import 'package:flutter/foundation.dart';

import '../data/models/product.dart';
import '../data/service/product_api.dart';

class ProductController extends ChangeNotifier {
  final ProductApi _api = ProductApi();

  List<Product> products = [];

  int _skip = 0;
  final int _limit = 20;

  bool isLoadingMore = false;
  bool hasMore = true;

  bool isLoading = false;
  String? errorMessage;

  Product? selectedProduct;

  bool isDetailLoading = false;
  String? detailErrorMessage;

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

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) {
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await _api.getProducts(
        limit: _limit,
        skip: _skip + _limit,
      );

      if (newProducts.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(newProducts);
        _skip += _limit;

        if (newProducts.length < _limit) {
          hasMore = false;
        }
      }
    } catch (e) {
      // Keep the existing products if loading the next page fails.
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadProductDetail(int id) async {
    isDetailLoading = true;
    detailErrorMessage = null;
    notifyListeners();

    try {
      selectedProduct = await _api.getProductDetail(id);
    } catch (e) {
      detailErrorMessage = 'Unable to load product details. Please try again.';
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }
}