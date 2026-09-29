import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/Banner/M/banner_m.dart';
import 'package:shop/components/Banner/M/banner_m_style_1.dart';
import 'package:shop/components/Banner/M/banner_m_style_2.dart';
import 'package:shop/components/Banner/M/banner_m_style_3.dart';
import 'package:shop/components/Banner/M/banner_m_style_4.dart';
import 'package:shop/components/skleton/banner/banner_m_skelton.dart';
import 'package:shop/controllers/banner_controller.dart';
import 'package:shop/models/banner_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

import '../../../../constants.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({
    super.key,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;
  late final BannerController _bannerController;

  // Fallback Demo Offers List
  final List<Widget> _demoOffers = [
    BannerMStyle1(
      text: "New items with \nFree shipping",
      image:
          "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle2(
      title: "Black \nfriday",
      subtitle: "Collection",
      discountParcent: 50,
      image:
          "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle3(
      title: "Grab \nyours now",
      discountParcent: 50,
      image:
          "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle4(
      title: "SUMMER \nSALE",
      subtitle: "SPECIAL OFFER",
      discountParcent: 80,
      image:
          "https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = Get.put(BannerController());
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (!mounted) return;
      final count = _getItemCount();
      if (count <= 1) return;

      if (_selectedIndex < count - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _selectedIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  int _getItemCount() {
    if (_bannerController.mainBanners.isNotEmpty) {
      return _bannerController.mainBanners.length;
    }
    return _demoOffers.length;
  }

  Widget _buildApiBanner(BuildContext context, BannerModel banner) {
    return BannerM(
      image: banner.image,
      press: () {
        if (banner.resourceType == 'product' && banner.resource != null) {
          final productModel = ProductModel(
            image: banner.resource!.thumbnail ?? banner.image,
            brandName: banner.title ?? "Featured",
            title: banner.resource!.name ?? "Product",
            price: banner.resource!.price ?? 0,
          );
          Navigator.pushNamed(
            context,
            productDetailsScreenRoute,
            arguments: productModel,
          );
        } else if (banner.resourceSlug != null &&
            banner.resourceSlug!.isNotEmpty) {
          Navigator.pushNamed(
            context,
            brandScreenRoute,
            arguments: banner.resourceSlug,
          );
        } else {
          Navigator.pushNamed(context, onSaleScreenRoute);
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              if (banner.title != null && banner.title!.isNotEmpty) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    banner.title!,
                    style: const TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else if (banner.resource?.name != null) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    banner.resource!.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                banner.buttonText ?? "Shop now",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 64,
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_bannerController.isMainLoading.value) {
        return const BannerMSkelton();
      }

      final hasApiBanners = _bannerController.mainBanners.isNotEmpty;
      final itemCount =
          hasApiBanners ? _bannerController.mainBanners.length : _demoOffers.length;

      return AspectRatio(
        aspectRatio: 2.0,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: itemCount,
              onPageChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (hasApiBanners) {
                  return _buildApiBanner(
                      context, _bannerController.mainBanners[index]);
                }
                return _demoOffers[index];
              },
            ),
            Positioned(
              bottom: defaultPadding * 0.7,
              right: defaultPadding * 1.8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    itemCount,
                    (index) {
                      final isSelected = index == _selectedIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        height: 5,
                        width: isSelected ? 18 : 5,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
