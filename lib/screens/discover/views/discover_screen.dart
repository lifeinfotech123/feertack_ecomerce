import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';

import '../models/category_data.dart';
import 'components/category_content_view.dart';
import 'components/category_sidebar_item.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Default to Beauty & Health (index 7) to match the reference screenshot initially
  int _selectedCategoryIndex = 7;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = demoDiscoverCategories;
    final selectedCategory = categories[_selectedCategoryIndex.clamp(0, categories.length - 1)];

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
        child: Row(
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
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategorySidebarItem(
                    category: categories[index],
                    isSelected: index == _selectedCategoryIndex,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  );
                },
              ),
            ),

            // Right Pane (Subcategories & Sections)
            Expanded(
              child: Container(
                color: contentBg,
                child: CategoryContentView(
                  key: ValueKey(selectedCategory.id),
                  category: selectedCategory,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
