import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/add_to_cart_and_wishlist.dart';
import 'package:shop/models/wishlist_model.dart';
import 'package:shop/route/route_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/add_to_cart_and_wishlist.dart';
import 'package:shop/models/wishlist_model.dart';
import 'package:shop/route/route_constants.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late final AddToCartAndWishlist _wishlistController;

  @override
  void initState() {
    super.initState();
    _wishlistController = Get.isRegistered<AddToCartAndWishlist>()
        ? Get.find<AddToCartAndWishlist>()
        : Get.put(AddToCartAndWishlist());

    _wishlistController.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? darkGreyColor : whiteColor;
    final bodyBg = isDark ? const Color(0xFF121218) : const Color(0xFFF6F6F9);

    return Scaffold(
      backgroundColor: bodyBg,
      appBar: AppBar(
        backgroundColor: bodyBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Obx(() {
          final count = _wishlistController.wishlistList.length;
          return Row(
            children: [
              Text(
                "MY WISHLIST",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$count Items",
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
      body: Obx(() {
        if (_wishlistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_wishlistController.wishlistList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 1.5),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_outline,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  Text(
                    "Your Wishlist is Empty!",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore products and save your favorite items here.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: greyColor,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(defaultBorderRadious),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white),
                    label: const Text(
                      "Explore Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _wishlistController.fetchWishlist(),
          child: ListView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: _wishlistController.wishlistList.length,
            itemBuilder: (context, index) {
              final WishlistItemModel item =
              _wishlistController.wishlistList[index];
              return _buildWishlistItemCard(context, item, cardBg, isDark);
            },
          ),
        );
      }),
    );
  }

  Widget _buildWishlistItemCard(
      BuildContext context,
      WishlistItemModel item,
      Color cardBg,
      bool isDark,
      ) {
    final hasDiscount =
        item.discountedPrice != null && item.discountedPrice! < item.unitPrice;
    final displayPrice = hasDiscount ? item.discountedPrice! : item.unitPrice;

    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        side: BorderSide(
          color: isDark ? Colors.white12 : const Color(0xFFECECF0),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            productDetailsScreenRoute,
            arguments: item.toProductModel(),
          );
        },
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Image
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF262634)
                          : const Color(0xFFF6F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      (item.thumbnail != null && item.thumbnail!.isNotEmpty)
                          ? NetworkImageWithLoader(
                        item.thumbnail!,
                        radius: 10,
                        fit: BoxFit.cover,
                      )
                          : const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  if (item.discountPercent != null && item.discountPercent! > 0)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: errorColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "-${item.discountPercent!.round()}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Product Info & Actions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.brand != null &&
                                  item.brand!.name.isNotEmpty) ...[
                                Text(
                                  item.brand!.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Delete button from wishlist
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: errorColor,
                          ),
                          onPressed: () async {
                            final success = await _wishlistController
                                .removeFromWishlist(item.productId);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? _wishlistController.successMessage.value
                                      : _wishlistController.errorMessage.value,
                                ),
                                backgroundColor:
                                success ? Colors.green : Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price & Stock
                    Row(
                      children: [
                        Text(
                          "\$${displayPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            "\$${item.unitPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: greyColor,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (item.currentStock != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (item.currentStock! > 0)
                                  ? successColor.withValues(alpha: 0.1)
                                  : errorColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (item.currentStock! > 0)
                                  ? "In Stock"
                                  : "Out of Stock",
                              style: TextStyle(
                                color: (item.currentStock! > 0)
                                    ? successColor
                                    : errorColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),



                    const SizedBox(height: 10),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final success = await _wishlistController.addToCart(
                            item.productId,
                            wishlistModel: item,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? _wishlistController.successMessage.value
                                    : _wishlistController.errorMessage.value,
                              ),
                              backgroundColor:
                              success ? Colors.green : Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


