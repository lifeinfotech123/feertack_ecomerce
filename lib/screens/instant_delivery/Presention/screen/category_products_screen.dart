import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/instant_product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';
import '../../data/instant_delivery_data.dart';

class CategoryProductsScreen extends StatefulWidget {
  final InstantCategoryModel category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _searchQuery = "";
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = const ["All Items", "Top Offers", "Fastest"];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    List<ProductModel> list = widget.category.products;

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    if (_selectedFilterIndex == 1) {
      // Top Offers (has discount)
      list = list.where((p) => (p.dicountpercent ?? 0) > 0).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: isDark ? blackColor : const Color(0xFFF7F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text(
              "${widget.category.iconEmoji} ${widget.category.name}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, cartScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Bag.svg",
              height: 22,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: defaultPadding / 2),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section (Search & Filter Pills)
            Container(
              color: isDark ? darkGreyColor : whiteColor,
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 1.5,
              ),
              child: Column(
                children: [
                  // Express Delivery & Banner row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded,
                                color: Colors.white, size: 13),
                            SizedBox(width: 2),
                            Text(
                              "10 MINS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.category.bannerText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 1.5),

                  // In-Category Search Box
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? blackColor : const Color(0xFFF1F1F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Search.svg",
                          height: 16,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .iconTheme
                                .color!
                                .withValues(alpha: 0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: "Search in ${widget.category.name}...",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.4),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                            child: const Icon(Icons.close, size: 16),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: defaultPadding / 1.5),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilterIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark
                                        ? blackColor
                                        : const Color(0xFFF1F1F5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _filters[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                  fontSize: 11.5,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Products Grid / Empty State
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 60,
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Text(
                            "No products found",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Try searching with a different term",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(defaultPadding),
                      physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return InstantProductCard(
                          product: product,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
