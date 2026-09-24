import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({super.key});

  @override
  Widget build(BuildContext context) {
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
                    "Best Sellers",
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
