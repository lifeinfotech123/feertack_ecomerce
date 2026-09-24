import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop/components/Banner/M/banner_m_style_1.dart';
import 'package:shop/components/Banner/M/banner_m_style_2.dart';
import 'package:shop/components/Banner/M/banner_m_style_3.dart';
import 'package:shop/components/Banner/M/banner_m_style_4.dart';

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

  // Offers List
  List offers = [
    BannerMStyle1(
      text: "New items with \nFree shipping",
      image: "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle2(
      title: "Black \nfriday",
      subtitle: "Collection",
      discountParcent: 50,
      image: "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle3(
      title: "Grab \nyours now",
      discountParcent: 50,
      image: "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
    BannerMStyle4(
      title: "SUMMER \nSALE",
      subtitle: "SPECIAL OFFER",
      discountParcent: 80,
      image: "https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=80",
      press: () {},
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_selectedIndex < offers.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) => offers[index],
          ),
          Positioned(
            bottom: defaultPadding * 0.7,
            right: defaultPadding * 1.8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  offers.length,
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
  }
}
