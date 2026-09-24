enum CouponType { percentage, flat, freeDelivery }

class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType discountType;
  final double discountValue;
  final double minOrderValue;
  final double? maxDiscountAmount;
  final String expiryDate;
  final String terms;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue = 0.0,
    this.maxDiscountAmount,
    required this.expiryDate,
    this.terms = "Applicable once per user. Cannot be clubbed with other offers.",
  });

  bool get isFreeDelivery => discountType == CouponType.freeDelivery;

  /// Returns discount amount applicable on the subtotal.
  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderValue || subtotal <= 0) return 0.0;

    switch (discountType) {
      case CouponType.percentage:
        double discount = subtotal * (discountValue / 100.0);
        if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
          discount = maxDiscountAmount!;
        }
        return discount.clamp(0.0, subtotal);

      case CouponType.flat:
        return discountValue > subtotal ? subtotal : discountValue;

      case CouponType.freeDelivery:
        return 0.0; // Delivery fee is waived separately in cart
    }
  }

  bool isEligible(double subtotal) => subtotal >= minOrderValue;

  double neededToUnlock(double subtotal) {
    if (subtotal >= minOrderValue) return 0.0;
    return minOrderValue - subtotal;
  }
}

/// Pre-configured promotional coupons ready to use
final List<CouponModel> demoCoupons = [
  const CouponModel(
    id: "coupon_1",
    code: "WELCOME50",
    title: "50% OFF First Order",
    description: "Get 50% discount up to \$10 on your purchase.",
    discountType: CouponType.percentage,
    discountValue: 50.0,
    minOrderValue: 20.0,
    maxDiscountAmount: 10.0,
    expiryDate: "Valid till 30 Nov",
    terms: "Valid on orders above \$20. Maximum savings \$10.",
  ),
  const CouponModel(
    id: "coupon_2",
    code: "SAVE20",
    title: "20% OFF Everything",
    description: "Enjoy 20% off on all fresh items and apparel.",
    discountType: CouponType.percentage,
    discountValue: 20.0,
    minOrderValue: 25.0,
    maxDiscountAmount: 15.0,
    expiryDate: "Valid till 15 Dec",
    terms: "Valid on orders above \$25. Maximum discount \$15.",
  ),
  const CouponModel(
    id: "coupon_3",
    code: "FLAT10",
    title: "Flat \$10 OFF",
    description: "Instant \$10 discount on orders above \$40.",
    discountType: CouponType.flat,
    discountValue: 10.0,
    minOrderValue: 40.0,
    expiryDate: "Valid till 31 Dec",
    terms: "Minimum cart value \$40 required. Instant deduction.",
  ),
  const CouponModel(
    id: "coupon_4",
    code: "FREESHIP",
    title: "Free Express Delivery",
    description: "Zero delivery fee on express 10-15 mins delivery.",
    discountType: CouponType.freeDelivery,
    discountValue: 0.0,
    minOrderValue: 10.0,
    expiryDate: "Valid till 31 Oct",
    terms: "Waives off the express delivery charge for order above \$10.",
  ),
  const CouponModel(
    id: "coupon_5",
    code: "INSTANT5",
    title: "5% Instant Promo",
    description: "Save 5% on your entire cart with no minimum spend.",
    discountType: CouponType.percentage,
    discountValue: 5.0,
    minOrderValue: 0.0,
    expiryDate: "Valid indefinitely",
    terms: "No minimum purchase requirement. Unlimited use.",
  ),
];
