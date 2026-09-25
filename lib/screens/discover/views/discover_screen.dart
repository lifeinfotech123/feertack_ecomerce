import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/components/skleton/others/discover_categories_skelton.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/categories_controller.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/home/views/components/sub_category.dart';

import '../models/category_data.dart';
import 'components/category_content_view.dart';
import 'components/category_sidebar_item.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final CategoriesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<CategoriesController>()
        ? Get.find<CategoriesController>()
        : Get.put(CategoriesController());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sidebarBg = isDark ? const Color(0xFF14141C) : const Color(0xFFF7F7F9);
    final contentBg = isDark ? const Color(0xFF1A1A24) : Colors.white;
    final dividerColor = isDark ? Colors.white10 : const Color(0xFFE8E8EE);

    return Scaffold(
      backgroundColor: contentBg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161620) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.8,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        titleSpacing: defaultPadding,
        title: Text(
          "CATEGORIES",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1B1B22),
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        actions: [
          // Search Icon
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white : const Color(0xFF22222A),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
          ),

          // Wishlist Icon (Heart)
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/Wishlist.svg",
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white : const Color(0xFF22222A),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, bookmarkScreenRoute);
            },
          ),

          // Cart Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Bag.svg",
                  height: 22,
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : const Color(0xFF22222A),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, cartScreenRoute);
                },
              ),
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    "12",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const DiscoverCategoriesSkelton();
          }

          final categories = controller.categories;
          final useApi = categories.isNotEmpty;

          return Row(
            children: [
              // Left Sidebar (Categories)
              Container(
                width: 90,
                decoration: BoxDecoration(
                  color: sidebarBg,
                  border: Border(
                    right: BorderSide(
                      color: dividerColor,
                      width: 0.9,
                    ),
                  ),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: useApi ? categories.length : demoDiscoverCategories.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == controller.selectedIndex.value;

                    if (useApi) {
                      return CategorySidebarItem(
                        categoryModel: categories[index],
                        isSelected: isSelected,
                        onTap: () {
                          controller.selectCategory(index);
                        },
                      );
                    } else {
                      return CategorySidebarItem(
                        category: demoDiscoverCategories[index],
                        isSelected: isSelected,
                        onTap: () {
                          controller.selectCategory(index);
                        },
                      );
                    }
                  },
                ),
              ),

              // Right Pane (Subcategories & Sections)
              Expanded(
                child: Container(
                  color: contentBg,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                    child: useApi
                        ? const Sub_category()
                        : CategoryContentView(
                            category: demoDiscoverCategories[
                                controller.selectedIndex.value.clamp(0, demoDiscoverCategories.length - 1)],
                          ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
