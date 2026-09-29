class CategoryModel {
  final int? id;
  final String name;
  final String? slug;
  final String? icon;
  final String? svgSrc;
  final String? route;
  final int? priority;
  final int? position;
  final int? parentId;
  final int? productsCount;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    this.id,
    String? name,
    String? title,
    this.slug,
    String? icon,
    String? image,
    this.svgSrc,
    this.route,
    this.priority,
    this.position,
    this.parentId,
    this.productsCount,
    this.subCategories,
  })  : name = name ?? title ?? '',
        icon = icon ?? image;

  String get title => name;
  String? get image => icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final subCatsJson = json['sub_categories'] ?? json['sub_sub_categories'];
    List<CategoryModel>? subs;
    if (subCatsJson != null && subCatsJson is List) {
      subs = subCatsJson
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      icon: json['icon']?.toString() ?? json['image']?.toString(),
      svgSrc: json['svgSrc']?.toString(),
      route: json['route']?.toString(),
      priority: json['priority'] is int
          ? json['priority']
          : int.tryParse(json['priority']?.toString() ?? ''),
      position: json['position'] is int
          ? json['position']
          : int.tryParse(json['position']?.toString() ?? ''),
      parentId: json['parent_id'] is int
          ? json['parent_id']
          : int.tryParse(json['parent_id']?.toString() ?? ''),
      productsCount: json['products_count'] is int
          ? json['products_count']
          : int.tryParse(json['products_count']?.toString() ?? ''),
      subCategories: subs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'svgSrc': svgSrc,
      'route': route,
      'priority': priority,
      'position': position,
      'parent_id': parentId,
      'products_count': productsCount,
      'sub_categories': subCategories?.map((x) => x.toJson()).toList(),
    };
  }
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Woman’s", image: "https://i.imgur.com/5M89G2P.png"),
  CategoryModel(title: "Man’s", image: "https://i.imgur.com/UM3GdWg.png"),
  CategoryModel(title: "Kid’s", image: "https://i.imgur.com/Lp0D6k5.png"),
  CategoryModel(title: "Accessories", image: "https://i.imgur.com/3mSE5sN.png"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "On sale",
    svgSrc: "assets/icons/Sale.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
      CategoryModel(title: "Dresses"),
      CategoryModel(title: "Jeans"),
    ],
  ),
  CategoryModel(
    title: "Man’s & Woman’s",
    svgSrc: "assets/icons/Man&Woman.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
    ],
  ),
  CategoryModel(
    title: "Kids",
    svgSrc: "assets/icons/Child.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
    ],
  ),
  CategoryModel(
    title: "Accessories",
    svgSrc: "assets/icons/Accessories.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
    ],
  ),
];
