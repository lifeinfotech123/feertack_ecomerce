import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

class DiscoverProductsScreen extends StatefulWidget {
  final String categoryTitle;
  final String? categoryImage;

  const DiscoverProductsScreen({
    super.key,
    required this.categoryTitle,
    this.categoryImage,
  });

  @override
  State<DiscoverProductsScreen> createState() => _DiscoverProductsScreenState();
}

class _DiscoverProductsScreenState extends State<DiscoverProductsScreen> {
  final CartController _cart = CartController.instance;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";
  int _selectedFilterIndex = 0;

  final List<String> _filterPills = [
    "All Items",
    "Top Rated 4.5★+",
    "Under \$50",
    "Big Offers (20%+)",
  ];

  late final List<ProductModel> _allProducts;

  @override
  void initState() {
    super.initState();
    _allProducts = _generateProductsForCategory(widget.categoryTitle);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _generateProductsForCategory(String category) {
    final title = category.trim();

    // High quality sample curated products based on subcategory
    return [
      ProductModel(
        image: widget.categoryImage ??
            "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500&auto=format&fit=crop&q=80",
        title: "$title Premium Edition",
        brandName: "LIPSY LONDON",
        price: 64.99,
        priceAfetDiscount: 48.99,
        dicountpercent: 25,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&auto=format&fit=crop&q=80",
        title: "$title Signature Classic",
        brandName: "ZARA",
        price: 89.00,
        priceAfetDiscount: 62.30,
        dicountpercent: 30,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80",
        title: "$title Sport Comfort Wear",
        brandName: "NIKE",
        price: 110.00,
        priceAfetDiscount: 77.00,
        dicountpercent: 30,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=80",
        title: "$title Minimalist Luxe Edition",
        brandName: "URBAN STYLE",
        price: 45.00,
        priceAfetDiscount: 36.00,
        dicountpercent: 20,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500&auto=format&fit=crop&q=80",
        title: "$title Everyday Casuals",
        brandName: "H&M",
        price: 34.99,
        priceAfetDiscount: 27.99,
        dicountpercent: 20,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=500&auto=format&fit=crop&q=80",
        title: "$title Vintage Heritage Fit",
        brandName: "LEVI'S",
        price: 79.50,
        priceAfetDiscount: 55.65,
        dicountpercent: 30,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&auto=format&fit=crop&q=80",
        title: "$title Streetwear Pro",
        brandName: "PUMA",
        price: 59.99,
        priceAfetDiscount: 41.99,
        dicountpercent: 30,
      ),
      ProductModel(
        image:
            "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=500&auto=format&fit=crop&q=80",
        title: "$title Exclusive Collection",
        brandName: "MANGO",
        price: 95.00,
        priceAfetDiscount: 76.00,
        dicountpercent: 20,
      ),
    ];
  }

  List<ProductModel> get _filteredProducts {
    List<ProductModel> list = _allProducts;

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    if (_selectedFilterIndex == 1) {
      // Top rated (simulate top rated products)
      list = list.where((p) => (p.priceAfetDiscount ?? p.price) > 40).toList();
    } else if (_selectedFilterIndex == 2) {
      // Under $50
      list = list.where((p) => (p.priceAfetDiscount ?? p.price) <= 50).toList();
    } else if (_selectedFilterIndex == 3) {
      // Big discounts (25%+)
      list = list.where((p) => (p.dicountpercent ?? 0) >= 25).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? darkGreyColor : whiteColor;
    final bodyBg = isDark ? const Color(0xFF121218) : const Color(0xFFF6F6F9);
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: bodyBg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161620) : Colors.white,
        elevation: 0.8,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          // Cart Icon with dynamic badge
          AnimatedBuilder(
            animation: _cart,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Bag.svg",
                      height: 22,
                      width: 22,
                      colorFilter: ColorFilter.mode(
                        isDark ? Colors.white : const Color(0xFF22222A),
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, cartScreenRoute);
                    },
                  ),
                  if (_cart.totalItemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          "${_cart.totalItemCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar & Filter Header
            Container(
              color: isDark ? const Color(0xFF1A1A24) : Colors.white,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                children: [
                  // Search Box
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search in ${widget.categoryTitle}...",
                      hintStyle:
                          TextStyle(fontSize: 12.5, color: greyColor.withValues(alpha: 0.8)),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF262634)
                          : const Color(0xFFF4F4F8),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Filter Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(_filterPills.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_filterPills[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                              }
                            },
                            selectedColor: primaryColor,
                            backgroundColor: isDark
                                ? const Color(0xFF262634)
                                : const Color(0xFFF4F4F8),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : blackColor60),
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.transparent,
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

            // 2. Product Count Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing ${products.length} Products",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : blackColor60,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.swap_vert_rounded, size: 16, color: primaryColor),
                      SizedBox(width: 4),
                      Text(
                        "Popular",
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Products Grid View
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 56, color: greyColor.withValues(alpha: 0.6)),
                          const SizedBox(height: 12),
                          const Text(
                            "No products found",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Try searching with different keywords.",
                            style: TextStyle(fontSize: 12, color: greyColor),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(defaultPadding),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final hasDiscount =
                            (product.dicountpercent ?? 0) > 0;
                        final finalPrice =
                            product.priceAfetDiscount ?? product.price;

                        return Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : const Color(0xFFEAEAEA),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: product,
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image + Discount Tag
                                Expanded(
                                  flex: 6,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(13),
                                          ),
                                          child: NetworkImageWithLoader(
                                            product.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      if (hasDiscount)
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: errorColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "${product.dicountpercent}% OFF",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.favorite_border_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Product Info & Add to Cart
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.brandName.toUpperCase(),
                                              style: const TextStyle(
                                                color: primaryColor,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            // Ratings row
                                            const Row(
                                              children: [
                                                Icon(Icons.star_rounded,
                                                    size: 14,
                                                    color: Color(0xFFFFB800)),
                                                SizedBox(width: 2),
                                                Text(
                                                  "4.8",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " (85+)",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: greyColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Price & Add to cart button row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "\$${finalPrice.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w900,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                if (hasDiscount)
                                                  Text(
                                                    "\$${product.price.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: greyColor,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            // Quick Add to cart button
                                            ElevatedButton(
                                              onPressed: () {
                                                _cart.addToCart(product);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "${product.title} added to cart!"),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    action: SnackBarAction(
                                                      label: "VIEW CART",
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          cartScreenRoute,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: const Text(
                                                "+ ADD",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
