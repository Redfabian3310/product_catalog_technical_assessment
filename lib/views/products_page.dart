import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';
import 'widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductController _controller;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Product Catalog'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
            return const Center(
              child: Text('No products found'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: _controller.products.length +
                (_controller.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _controller.products.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final product = _controller.products[index];

              return ProductCard(
                product: product,
                onTap: () {
                  // Product detail will be added next.
                },
              );
            },
          );
        },
      ),
    );
  }
}