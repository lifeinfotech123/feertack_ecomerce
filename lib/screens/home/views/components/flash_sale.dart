import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
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
                    arguments: index.isEven,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
