import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/controllers/home_screen_api_controller.dart';
import 'package:shop/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final HomeScreenApiController apiController = Get.put(HomeScreenApiController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        // Section Header Row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFF8F00),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Top Sellers",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, onSaleScreenRoute);
                },
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: primaryColor,
                        size: 11,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        Obx(() {
          if (apiController.isTopSellersLoading.value) {
            return const ProductsSkelton();
          }

          final sellers = apiController.topSellers;

          if (sellers.isNotEmpty) {
            return SizedBox(
              height: 130,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                itemCount: sellers.length,
                itemBuilder: (context, index) {
                  final seller = sellers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, onSaleScreenRoute);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? darkGreyColor : lightGreyColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white12 : blackColor10,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: primaryColor, width: 1.5),
                              ),
                              child: ClipOval(
                                child: seller.logo != null && seller.logo!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: seller.logo!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const Icon(
                                          Icons.storefront_rounded,
                                          color: primaryColor,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.storefront_rounded,
                                        color: primaryColor,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              seller.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : blackColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${seller.productsCount ?? 0} Products",
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white54 : blackColor60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // Fallback to demo items
          return SizedBox(
            height: 242,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: demoBestSellersProducts.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: index == demoBestSellersProducts.length - 1
                      ? defaultPadding
                      : 0,
                ),
                child: ProductCard(
                  image: demoBestSellersProducts[index].image,
                  brandName: demoBestSellersProducts[index].brandName,
                  title: demoBestSellersProducts[index].title,
                  price: demoBestSellersProducts[index].price,
                  priceAfetDiscount:
                      demoBestSellersProducts[index].priceAfetDiscount,
                  dicountpercent: demoBestSellersProducts[index].dicountpercent,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      productDetailsScreenRoute,
                      arguments: demoBestSellersProducts[index],
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
