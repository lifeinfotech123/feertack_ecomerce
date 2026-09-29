import 'package:flutter/material.dart';
import 'package:shop/models/coupon_model.dart';
import 'package:shop/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get unitPrice => product.priceAfetDiscount ?? product.price;
  double get totalPrice => unitPrice * quantity;
}

class CartController extends ChangeNotifier {
  // Singleton instance for global access across the app
  static final CartController instance = CartController._internal();
  CartController._internal();

  final List<CartItemModel> _items = [];
  CouponModel? _appliedCoupon = demoCoupons.last; // Default to 5% instant promo

  List<CartItemModel> get items => List.unmodifiable(_items);

  CouponModel? get appliedCoupon => _appliedCoupon;
  bool get hasCoupon => _appliedCoupon != null;

  int get totalItemCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  double get subtotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    if (_appliedCoupon != null &&
        _appliedCoupon!.isFreeDelivery &&
        subtotal >= _appliedCoupon!.minOrderValue) {
      return 0.0;
    }
    return subtotal > 25.0 ? 0.0 : 1.99;
  }

  double get discountAmount {
    if (_items.isEmpty || _appliedCoupon == null) return 0.0;
    return _appliedCoupon!.calculateDiscount(subtotal);
  }

  double get grandTotal =>
      (subtotal + deliveryFee - discountAmount).clamp(0.0, double.infinity);

  /// Total money saved by user (discounts + free delivery waiver if applicable)
  double get totalSavings {
    double saved = discountAmount;
    if (subtotal <= 25.0 &&
        _appliedCoupon != null &&
        _appliedCoupon!.isFreeDelivery) {
      saved += 1.99;
    }
    return saved;
  }

  /// Applies a coupon if eligible. Returns an error string if ineligible, null on success.
  String? applyCoupon(CouponModel coupon) {
    if (subtotal < coupon.minOrderValue) {
      final needed = coupon.minOrderValue - subtotal;
      return "Add \$${needed.toStringAsFixed(2)} more to use ${coupon.code}";
    }
    _appliedCoupon = coupon;
    notifyListeners();
    return null;
  }

  /// Applies a coupon by text code. Returns error message or null if successfully applied.
  String? applyCouponByCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return "Please enter a promo code";
    }

    final matched = demoCoupons.firstWhere(
      (c) => c.code.toUpperCase() == cleanCode,
      orElse: () => const CouponModel(
        id: "",
        code: "",
        title: "",
        description: "",
        discountType: CouponType.flat,
        discountValue: 0,
        expiryDate: "",
      ),
    );

    if (matched.code.isEmpty) {
      return "Invalid promo code. Please check and try again.";
    }

    return applyCoupon(matched);
  }

  /// Removes the currently applied coupon
  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  int getQuantity(ProductModel product) {
    final index =
        _items.indexWhere((item) => item.product.title == product.title);
    if (index != -1) {
      return _items[index].quantity;
    }
    return 0;
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final index =
        _items.indexWhere((item) => item.product.title == product.title);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(ProductModel product, int newQuantity) {
    final index =
        _items.indexWhere((item) => item.product.title == product.title);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(ProductModel product) {
    _items.removeWhere((item) => item.product.title == product.title);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
