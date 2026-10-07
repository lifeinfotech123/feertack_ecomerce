import '../constants.dart';
import 'brand_model.dart';
import 'product_model.dart';

class ApiProductModel {
  final int id;
  final String name;
  final String? slug;
  final String? thumbnail;
  final double unitPrice;
  final double? discount;
  final String? discountType;
  final double? discountPercent;
  final double? discountedPrice;
  final String? formattedOriginalPrice;
  final String? formattedDiscountedPrice;
  final double? rating;
  final int? reviewsCount;
  final int? currentStock;
  final BrandModel? brand;
  final bool? isInstantDelivery;
  final String? badge;

  ApiProductModel({
    required this.id,
    required this.name,
    this.slug,
    this.thumbnail,
    required this.unitPrice,
    this.discount,
    this.discountType,
    this.discountPercent,
    this.discountedPrice,
    this.formattedOriginalPrice,
    this.formattedDiscountedPrice,
    this.rating,
    this.reviewsCount,
    this.currentStock,
    this.brand,
    this.isInstantDelivery,
    this.badge,
  });

  factory ApiProductModel.fromJson(Map<String, dynamic> json) {
    return ApiProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      unitPrice: (json['unit_price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      discountType: json['discount_type']?.toString(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      formattedOriginalPrice: json['formatted_original_price']?.toString(),
      formattedDiscountedPrice: json['formatted_discounted_price']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] is int
          ? json['reviews_count']
          : int.tryParse(json['reviews_count']?.toString() ?? ''),
      currentStock: json['current_stock'] is int
          ? json['current_stock']
          : int.tryParse(json['current_stock']?.toString() ?? ''),
      brand: json['brand'] is Map<String, dynamic>
          ? BrandModel.fromJson(json['brand'])
          : null,
      isInstantDelivery: json['is_instant_delivery'] as bool?,
      badge: json['badge']?.toString(),
    );
  }

  ProductModel toProductModel() {
    final bool hasDiscount =
        (discountedPrice != null && discountedPrice! < unitPrice) ||
            (discount != null && discount! > 0) ||
            (discountPercent != null && discountPercent! > 0);

    return ProductModel(
      id: id,
      image: (thumbnail != null && thumbnail!.isNotEmpty)
          ? thumbnail!
          : productDemoImg1,
      brandName: brand?.name ?? '',
      title: name,
      price: unitPrice,
      priceAfetDiscount: hasDiscount ? discountedPrice : null,
      dicountpercent: discountPercent?.round() ??
          (discountType == 'percent' ? discount?.round() : null),
    );
  }
}

class FlashDealCountdown {
  final String? targetTime;
  final int remainingSeconds;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isExpired;

  FlashDealCountdown({
    this.targetTime,
    this.remainingSeconds = 0,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.isExpired = false,
  });

  factory FlashDealCountdown.fromJson(Map<String, dynamic> json) {
    return FlashDealCountdown(
      targetTime: json['target_time']?.toString(),
      remainingSeconds: (json['remaining_seconds'] as num?)?.toInt() ?? 0,
      days: (json['days'] as num?)?.toInt() ?? 0,
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
      isExpired: json['is_expired'] as bool? ?? false,
    );
  }
}

class FlashDealModel {
  final int id;
  final String? title;
  final String? slug;
  final String? banner;
  final String? startDate;
  final String? endDate;
  final FlashDealCountdown? countdown;
  final int? productsCount;

  FlashDealModel({
    required this.id,
    this.title,
    this.slug,
    this.banner,
    this.startDate,
    this.endDate,
    this.countdown,
    this.productsCount,
  });

  factory FlashDealModel.fromJson(Map<String, dynamic> json) {
    return FlashDealModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString(),
      slug: json['slug']?.toString(),
      banner: json['banner']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      countdown: json['countdown'] is Map<String, dynamic>
          ? FlashDealCountdown.fromJson(json['countdown'])
          : null,
      productsCount: json['products_count'] is int
          ? json['products_count']
          : int.tryParse(json['products_count']?.toString() ?? ''),
    );
  }
}

class TopSellerModel {
  final int id;
  final int? sellerId;
  final String name;
  final String? slug;
  final String? banner;
  final String? logo;
  final double? rating;
  final String? ratingFormatted;
  final int? reviewsCount;
  final int? productsCount;
  final int? ordersCount;
  final bool? isInhouse;

  TopSellerModel({
    required this.id,
    this.sellerId,
    required this.name,
    this.slug,
    this.banner,
    this.logo,
    this.rating,
    this.ratingFormatted,
    this.reviewsCount,
    this.productsCount,
    this.ordersCount,
    this.isInhouse,
  });

  factory TopSellerModel.fromJson(Map<String, dynamic> json) {
    return TopSellerModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      sellerId: json['seller_id'] is int
          ? json['seller_id']
          : int.tryParse(json['seller_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      banner: json['banner']?.toString(),
      logo: json['logo']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      ratingFormatted: json['rating_formatted']?.toString(),
      reviewsCount: json['reviews_count'] is int
          ? json['reviews_count']
          : int.tryParse(json['reviews_count']?.toString() ?? ''),
      productsCount: json['products_count'] is int
          ? json['products_count']
          : int.tryParse(json['products_count']?.toString() ?? ''),
      ordersCount: json['orders_count'] is int
          ? json['orders_count']
          : int.tryParse(json['orders_count']?.toString() ?? ''),
      isInhouse: json['is_inhouse'] as bool?,
    );
  }
}
