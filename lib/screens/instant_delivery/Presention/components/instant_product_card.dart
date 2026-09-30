import 'package:flutter/material.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

class InstantProductCard extends StatefulWidget {
  final ProductModel product;
  final String? unit;

  const InstantProductCard({
    super.key,
    required this.product,
    this.unit,
  });

  @override
  State<InstantProductCard> createState() => _InstantProductCardState();
}

class _InstantProductCardState extends State<InstantProductCard> {
  final CartController _cart = CartController.instance;

  int get _quantity => _cart.getQuantity(widget.product);

  String _extractUnit(String title) {
    if (widget.unit != null && widget.unit!.isNotEmpty) {
      return widget.unit!;
    }
    // Extract unit from title if it has brackets like (1 kg), (500 g), (Pack of 6)
    final match = RegExp(r'\((.*?)\)').firstMatch(title);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return "1 unit";
  }

  String _cleanTitle(String title) {
    // Return title without the trailing unit for a cleaner look
    final cleaned = title.replaceAll(RegExp(r'\(.*?\)'), '').trim();
    return cleaned.isNotEmpty ? cleaned : title;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final product = widget.product;
        final unitText = _extractUnit(product.title);
        final displayTitle = _cleanTitle(product.title);
        final hasDiscount = (product.dicountpercent ?? 0) > 0;
        final finalPrice = product.priceAfetDiscount ?? product.price;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, productDetailsScreenRoute);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E28) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFEBEBF0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image Area with Badges
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: AspectRatio(
                      aspectRatio: 1.18,
                      child: Stack(
                        children: [
                          // Product Image Container
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF262634)
                                    : const Color(0xFFF6F6F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: NetworkImageWithLoader(
                                  product.image,
                                  radius: 12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          // Delivery Speed Badge (Top Left)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B5E20),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    color: Color(0xFFFFD54F),
                                    size: 11,
                                  ),
                                  SizedBox(width: 1.5),
                                  Text(
                                    "10 MINS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Discount Tag (Top Right)
                          if (hasDiscount)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: 0.25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "${product.dicountpercent}% OFF",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Product Info & Price
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9, 2, 9, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Unit / Weight Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFEDEDF2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  unitText,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Product Title
                              Text(
                                displayTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                              ),
                            ],
                          ),

                          // Bottom Price & Add Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Pricing Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${finalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                    ),
                                  ),
                                  if (hasDiscount)
                                    Text(
                                      "₹${product.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.black38,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),

                              // Interactive ADD Button / Stepper
                              _quantity == 0
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          _cart.addToCart(product);
                                        });
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      "Added $displayTitle to cart ⚡",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor:
                                                  const Color(0xFF1B5E20),
                                              duration:
                                                  const Duration(seconds: 1),
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(
                                            alpha: isDark ? 0.2 : 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: primaryColor.withValues(
                                              alpha: 0.5,
                                            ),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "ADD",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 11,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            Icon(
                                              Icons.add_rounded,
                                              color: primaryColor,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor
                                                .withValues(alpha: 0.35),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _cart.updateQuantity(
                                                    product, _quantity - 1);
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              child: Icon(
                                                Icons.remove_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "$_quantity",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _cart.updateQuantity(
                                                    product, _quantity + 1);
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ],
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
          ),
        );
      },
    );
  }
}
