import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';

class CategoryModel {
  final String name;
  final String? svgSrc, route;

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
  });
}

List<CategoryModel> demoCategories = [
  CategoryModel(name: "All Categories"),
  CategoryModel(
      name: "On Sale",
      svgSrc: "assets/icons/Sale.svg",
      route: onSaleScreenRoute),
  CategoryModel(name: "Woman’s", svgSrc: "assets/icons/Woman.svg"),
  CategoryModel(name: "Man's", svgSrc: "assets/icons/Man.svg"),
  CategoryModel(
      name: "Kids", svgSrc: "assets/icons/Child.svg", route: kidsScreenRoute),
  CategoryModel(name: "Accessories", svgSrc: "assets/icons/Accessories.svg"),
];

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          demoCategories.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? defaultPadding : defaultPadding / 2,
              right: index == demoCategories.length - 1 ? defaultPadding : 0,
            ),
            child: CategoryBtn(
              category: demoCategories[index].name,
              svgSrc: demoCategories[index].svgSrc,
              isActive: index == _selectedIndex,
              press: () {
                setState(() {
                  _selectedIndex = index;
                });
                if (demoCategories[index].route != null) {
                  Navigator.pushNamed(context, demoCategories[index].route!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF5A35E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive
              ? null
              : (isDark ? const Color(0xFF222030) : const Color(0xFFF3F3F7)),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (isDark ? Colors.white12 : const Color(0xFFE5E5EB)),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B61FF).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgSrc != null) ...[
              SvgPicture.asset(
                svgSrc!,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(
                  isActive
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF42424E)),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (isDark ? Colors.white70 : const Color(0xFF33333E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
