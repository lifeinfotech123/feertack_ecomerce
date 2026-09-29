import 'package:flutter/material.dart';
import 'package:shop/screens/discover/views/discover_products_screen.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DiscoverProductsScreen(
      categoryTitle: "On Sale & Top Deals",
      categoryImage:
          "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=500&auto=format&fit=crop&q=80",
    );
  }
}
