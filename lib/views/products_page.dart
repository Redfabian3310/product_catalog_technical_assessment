import 'package:flutter/material.dart';
import 'dart:async';

import '../controllers/product_controller.dart';
import 'widgets/product_card.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductController _controller;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();

    _controller = ProductController();
    _controller.loadProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        _controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            _searchDebounce?.cancel();

            _searchDebounce = Timer(const Duration(milliseconds: 500), () {
              _controller.searchProducts(query);
            });
          },
          onSubmitted: (query) {
            _searchDebounce?.cancel();
            _controller.searchProducts(query);
          },
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_controller.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _controller.loadProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_controller.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return RefreshIndicator(
            onRefresh: _controller.refreshProducts,
            child: ListView.builder(
              controller: _scrollController,
              itemCount:
                  _controller.products.length +
                  (_controller.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _controller.products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = _controller.products[index];

                return ProductCard(
                  product: product,
                  onTap: () {
                    _controller.loadProductDetail(product.id);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return ListenableBuilder(
                          listenable: _controller,
                          builder: (context, child) {
                            if (_controller.isDetailLoading) {
                              return const Dialog(
                                child: SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            }

                            if (_controller.detailErrorMessage != null) {
                              return AlertDialog(
                                title: const Text('Something went wrong'),
                                content: Text(_controller.detailErrorMessage!),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.loadProductDetail(product.id);
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              );
                            }

                            if (_controller.selectedProduct != null) {
                              return ProductDetailPage(
                                product: _controller.selectedProduct!,
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
