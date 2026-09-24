import 'package:flutter/material.dart';
import 'package:shop/components/Banner/S/banner_s_style_1.dart';
import 'package:shop/components/Banner/S/banner_s_style_5.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/home/views/components/home_app_bar_header_widget.dart';

import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_brands.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HomeAppBarHeaderWidget(),
          const SliverPadding(
            padding: EdgeInsets.only(top: defaultPadding * 0.75),
            sliver: SliverToBoxAdapter(child: OffersCarouselAndCategories()),
          ),
          const SliverToBoxAdapter(child: PopularProducts()),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
            sliver: SliverToBoxAdapter(child: PopularBrands()),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
            sliver: SliverToBoxAdapter(child: FlashSale()),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                BannerSStyle1(
                  title: "New \narrival",
                  subtitle: "SPECIAL OFFER",
                  discountParcent: 50,
                  press: () {
                    Navigator.pushNamed(context, onSaleScreenRoute);
                  },
                ),
                const SizedBox(height: defaultPadding / 4),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: BestSellers()),
          const SliverToBoxAdapter(child: MostPopular()),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding * 1.5),
                const SizedBox(height: defaultPadding / 4),
                BannerSStyle5(
                  title: "Black \nfriday",
                  subtitle: "50% Off",
                  bottomText: "Collection".toUpperCase(),
                  press: () {
                    Navigator.pushNamed(context, onSaleScreenRoute);
                  },
                ),
                const SizedBox(height: defaultPadding * 1.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
