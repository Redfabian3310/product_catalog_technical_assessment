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

  @override
  void initState() {
    super.initState();

    _controller = ProductController();
    _controller.loadProducts();
  }

  @override
  void dispose() {
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
            itemCount: _controller.products.length,
            itemBuilder: (context, index) {
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