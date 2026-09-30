import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/components/top_brands_slider.dart';
import 'package:shop/controllers/cart_controller.dart';
import '../components/instant_product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import '../../data/instant_delivery_data.dart';
import 'category_products_screen.dart';

class InstantProduct extends StatefulWidget {
  const InstantProduct({super.key});

  @override
  State<InstantProduct> createState() => _HomePageState();
}

class _HomePageState extends State<InstantProduct> {
  // Active selected category index for the quick-switch row on HomePage
  int _selectedCategoryFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeCategory = instantDeliveryCategories[_selectedCategoryFilterIndex];
    final displayProducts = activeCategory.products;

    return Scaffold(
      backgroundColor: isDark ? blackColor : const Color(0xFFF7F7FA),
      bottomNavigationBar: ListenableBuilder(
        listenable: CartController.instance,
        builder: (context, child) {
          final cart = CartController.instance;
          if (cart.totalItemCount == 0) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, cartScreenRoute);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${cart.totalItemCount} ITEM${cart.totalItemCount > 1 ? 'S' : ''}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "₹${cart.subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "View Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Express Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Delivery Speed & Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2962FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.bolt_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
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
                                Text(
                                  "Instant Delivery",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/Location.svg",
                                  height: 14,
                                  colorFilter: const ColorFilter.mode(
                                    primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Deliver to Home - New York, USA",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                             ?.withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, notificationsScreenRoute);
                          },
                          icon: SvgPicture.asset(
                            "assets/icons/Notification.svg",
                            height: 22,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).iconTheme.color!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: defaultPadding),

                    // Search Bar
                    InkWell(
                      onTap: () {
                        // Open Vegetables category or search screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              category: instantDeliveryCategories[0],
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? darkGreyColor : whiteColor,
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadious),
                          border: Border.all(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/Search.svg",
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withValues(alpha: 0.4),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 2),
                            Expanded(
                              child: Text(
                                "Search 'vegetables, milk, fruits, snacks'...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withValues(alpha: 0.4),
                                      fontSize: 13,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: defaultPadding),

                    // Express 10-Min Electric Blue Gradient Banner
                    InkWell(
                      onTap: () {
                        // Open Vegetables category directly
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              category: instantDeliveryCategories[0],
                            ),
                          ),
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadious * 1.2),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadious * 1.2),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1565C0),
                              Color(0xFF2962FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2962FF)
                                  .withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "⚡ 10-MIN EXPRESS GROCERY",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Fresh Vegetables & Fruits at 50% Off",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Shop Now",
                                style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: defaultPadding * 1.2),

                    // Express Categories Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Instant Categories",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          "Tap to view products",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding / 1.5),

                    // Categories Grid (Clicking any category opens its dedicated CategoryProductsScreen!)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: instantDeliveryCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.74,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final cat = instantDeliveryCategories[index];
                        final isSelected = index == _selectedCategoryFilterIndex;
                        return InkWell(
                          onTap: () {
                            // Opens the dedicated screen for that specific category with all its products!
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  category: cat,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF20202C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark
                                        ? Colors.white12
                                        : const Color(0xFFECECF2)),
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.25 : 0.03,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: NetworkImageWithLoader(
                                      cat.image,
                                      radius: 10,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: defaultPadding),

                    // Top Featured Brands Slider
                    const TopBrandsSlider(),

                    const SizedBox(height: defaultPadding),

                    // Quick Category Filter Switcher Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          instantDeliveryCategories.length,
                          (index) {
                            final cat = instantDeliveryCategories[index];
                            final isSelected =
                                _selectedCategoryFilterIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryFilterIndex = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : (isDark
                                            ? darkGreyColor
                                            : whiteColor),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : (isDark
                                              ? Colors.white12
                                              : const Color(0xFFE8E8EE)),
                                    ),
                                  ),
                                  child: Text(
                                    "${cat.iconEmoji} ${cat.name}",
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
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: defaultPadding),

                    // Instant Products Grid Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${activeCategory.iconEmoji} ${activeCategory.name} (Delivering in 10 Mins ⚡)",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  category: activeCategory,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding / 1.5),
                  ],
                ),
              ),
            ),

            // Products Grid (Displays products corresponding to selected category)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final product = displayProducts[index];
                    return InstantProductCard(
                      product: product,
                    );
                  },
                  childCount: displayProducts.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding * 2),
            ),
          ],
        ),
      ),
    );
  }
}

typedef InstantDeliveryScreen = InstantProduct;
