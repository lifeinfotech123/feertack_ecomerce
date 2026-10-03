import 'brand_model.dart';
import 'product_model.dart';

class WishlistItemModel {
  final int wishlistId;
  final int productId;
  final String name;
  final String? slug;
  final String? thumbnail;
  final double unitPrice;
  final double? discount;
  final double? discountPercent;
  final double? discountedPrice;
  final int? currentStock;
  final double? rating;
  final BrandModel? brand;
  final String? createdAt;

  WishlistItemModel({
    required this.wishlistId,
    required this.productId,
    required this.name,
    this.slug,
    this.thumbnail,
    required this.unitPrice,
    this.discount,
    this.discountPercent,
    this.discountedPrice,
    this.currentStock,
    this.rating,
    this.brand,
    this.createdAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      wishlistId: json['wishlist_id'] is int
          ? json['wishlist_id']
          : int.tryParse(json['wishlist_id']?.toString() ?? '') ?? 0,
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      currentStock: json['current_stock'] is int
          ? json['current_stock']
          : int.tryParse(json['current_stock']?.toString() ?? ''),
      rating: (json['rating'] as num?)?.toDouble(),
      brand: json['brand'] is Map<String, dynamic>
          ? BrandModel.fromJson(json['brand'])
          : null,
      createdAt: json['created_at']?.toString(),
    );
  }

  ProductModel toProductModel() {
    final bool hasDiscount =
        (discountedPrice != null && discountedPrice! < unitPrice) ||
            (discount != null && discount! > 0) ||
            (discountPercent != null && discountPercent! > 0);

    return ProductModel(
      image: (thumbnail != null && thumbnail!.isNotEmpty) ? thumbnail! : '',
      brandName: brand?.name ?? '',
      title: name,
      price: unitPrice,
      priceAfetDiscount: hasDiscount ? discountedPrice : null,
      dicountpercent: discountPercent?.round(),
    );
  }
}
