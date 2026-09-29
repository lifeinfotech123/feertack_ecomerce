import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/controllers/home_screen_api_controller.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenApiController apiController = Get.put(HomeScreenApiController());

    return Obx(() {
      final hasDeals = apiController.flashDeals.isNotEmpty;
      final deal = hasDeals ? apiController.flashDeals.first : null;
      final seconds = deal?.countdown?.remainingSeconds ?? 28800;

      final text = deal?.title != null && deal!.title!.isNotEmpty
          ? "${deal.title}\nFlash Sale"
          : "Super Flash Sale \n50% Off";

      final image = (deal?.banner != null && deal!.banner!.isNotEmpty)
          ? deal.banner!
          : "https://i.imgur.com/pRgcbpS.png";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerMWithCounter(
            key: ValueKey(deal?.id ?? 0),
            duration: Duration(seconds: seconds > 0 ? seconds : 28800),
            text: text,
            image: image,
            press: () {
              Navigator.pushNamed(context, onSaleScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
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
                        color: const Color(0xFFFF5252).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFFFF5252),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Flash Sale",
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
          if (apiController.isFlashDealsLoading.value)
            const ProductsSkelton()
          else if (apiController.featuredProducts.isNotEmpty)
            SizedBox(
              height: 242,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: apiController.featuredProducts.length,
                itemBuilder: (context, index) {
                  final item = apiController.featuredProducts[index];
                  final productModel = item.toProductModel();
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == apiController.featuredProducts.length - 1
                          ? defaultPadding
                          : 0,
                    ),
                    child: ProductCard(
                      image: productModel.image,
                      brandName: productModel.brandName,
                      title: productModel.title,
                      price: productModel.price,
                      priceAfetDiscount: productModel.priceAfetDiscount,
                      dicountpercent: productModel.dicountpercent,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: productModel,
                        );
                      },
                    ),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 242,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: demoFlashSaleProducts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == demoFlashSaleProducts.length - 1
                        ? defaultPadding
                        : 0,
                  ),
                  child: ProductCard(
                    image: demoFlashSaleProducts[index].image,
                    brandName: demoFlashSaleProducts[index].brandName,
                    title: demoFlashSaleProducts[index].title,
                    price: demoFlashSaleProducts[index].price,
                    priceAfetDiscount:
                        demoFlashSaleProducts[index].priceAfetDiscount,
                    dicountpercent: demoFlashSaleProducts[index].dicountpercent,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                        arguments: demoFlashSaleProducts[index],
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
