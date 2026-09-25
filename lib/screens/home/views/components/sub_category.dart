// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../../controllers/categories_controller.dart';

typedef SubCategory = Sub_category;

class Sub_category extends StatefulWidget {
  final String? categorySlug;

  const Sub_category({
    super.key,
    this.categorySlug,
  });

  @override
  State<Sub_category> createState() => _Sub_categoryState();
}

class _Sub_categoryState extends State<Sub_category> {
  late final CategoriesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<CategoriesController>()
        ? Get.find<CategoriesController>()
        : Get.put(CategoriesController());

    if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
      controller.fetchCategoryDetails(widget.categorySlug!);
    }
  }

  @override
  void didUpdateWidget(covariant Sub_category oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categorySlug != null &&
        widget.categorySlug != oldWidget.categorySlug) {
      controller.fetchCategoryDetails(widget.categorySlug!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isSubCategoryLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final categoryDetails = controller.selectedCategoryDetails.value;
      final subCategories = categoryDetails?.subCategories ?? [];

      if (subCategories.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: Text(
              "No subcategories available",
              style: TextStyle(
                color: isDark ? Colors.white60 : blackColor60,
                fontSize: 14,
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        itemBuilder: (context, index) {
          final subCat = subCategories[index];
          final subSubCats = subCat.subCategories ?? [];

          return Container(
            margin: const EdgeInsets.only(bottom: defaultPadding / 2),
            decoration: BoxDecoration(
              color: isDark ? darkGreyColor : lightGreyColor,
              borderRadius: BorderRadius.circular(defaultBorderRadious),
              border: Border.all(
                color: isDark ? Colors.white12 : blackColor10,
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: subCat.icon != null && subCat.icon!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: subCat.icon!,
                          height: 28,
                          width: 28,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.category,
                            size: 24,
                            color: isDark ? Colors.white70 : blackColor80,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.category,
                        size: 24,
                        color: isDark ? Colors.white70 : blackColor80,
                      ),
                title: Text(
                  subCat.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : blackColor,
                  ),
                ),
                childrenPadding: const EdgeInsets.all(defaultPadding / 2),
                children: [
                  if (subSubCats.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: subSubCats.map((subSub) {
                        return InkWell(
                          onTap: () {
                            // Sub-sub-category selected
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? primaryColor.withValues(alpha: 0.2)
                                  : primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              subSub.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "No items",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : blackColor40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
