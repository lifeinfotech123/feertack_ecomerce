import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/auth_controller.dart';
import 'package:shop/models/coupon_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/services/cart_service.dart';

class CartItemModel {
  int? cartId;
  final ProductModel product;
  int quantity;

  CartItemModel({
    this.cartId,
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

  final CartService _cartService = CartService();

  final List<CartItemModel> _items = [];
  CouponModel? _appliedCoupon = demoCoupons.last; // Default to 5% instant promo

  bool isLoading = false;
  String errorMessage = '';

  List<CartItemModel> get items => List.unmodifiable(_items);

  CouponModel? get appliedCoupon => _appliedCoupon;
  bool get hasCoupon => _appliedCoupon != null;

  String _getToken([String? token]) {
    if (token != null && token.isNotEmpty) return token;
    try {
      if (Get.isRegistered<AuthController>()) {
        return Get.find<AuthController>().token.value;
      }
    } catch (_) {}
    return '';
  }

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

  /// 1. Fetch Cart List from API
  Future<void> fetchCartList([String? token]) async {
    final authToken = _getToken(token);
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await _cartService.getCartList(token: authToken);
      if (response['status'] == true && response['data'] != null) {
        final List rawData = response['data'] as List;
        _items.clear();
        for (var item in rawData) {
          final int? cartId = item['cart_id'];
          final int? productId = item['product_id'];
          final String name = item['name'] ?? '';
          final String image = item['thumbnail'] ?? '';
          final String shopInfo = item['shop_info'] ?? '';
          final double unitPrice = (item['unit_price'] as num?)?.toDouble() ?? 0.0;
          final double? discountedPrice = (item['discounted_price'] as num?)?.toDouble();
          final int qty = (item['quantity'] as num?)?.toInt() ?? 1;

          final product = ProductModel(
            id: productId,
            image: image,
            brandName: shopInfo,
            title: name,
            price: unitPrice,
            priceAfetDiscount: discountedPrice,
          );

          _items.add(CartItemModel(
            cartId: cartId,
            product: product,
            quantity: qty,
          ));
        }
      } else {
        errorMessage = response['message']?.toString() ?? 'Failed to fetch cart';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 2. Add to Cart (Local & API)
  Future<bool> addToCart(ProductModel product, {int quantity = 1, String? token, int? productId}) async {
    final authToken = _getToken(token);

    final index =
        _items.indexWhere((item) => item.product.title == product.title);
    CartItemModel itemModel;
    if (index != -1) {
      _items[index].quantity += quantity;
      itemModel = _items[index];
    } else {
      itemModel = CartItemModel(product: product, quantity: quantity);
      _items.add(itemModel);
    }

    final targetProductId = productId ?? product.id ?? 5;

    final requestUrl = '$baseUrl$addToCartEndpoint';
    print('================ ADD TO CART ================');
    print('URL: $requestUrl');
    print('Product: ${product.title}');
    print('Product ID: $targetProductId');
    print('Quantity: $quantity');
    print('Price: ${product.priceAfetDiscount ?? product.price}');
    print('============================================');

    debugPrint('================ ADD TO CART (LOCAL) ================');
    debugPrint('URL: $requestUrl');
    debugPrint('Product: ${product.title}');
    debugPrint('Product ID: $targetProductId');
    debugPrint('Quantity: $quantity');
    debugPrint('Price: ${product.priceAfetDiscount ?? product.price}');
    debugPrint('====================================================');
    notifyListeners();

    try {
      final response = await _cartService.addToCart(
        token: authToken,
        productId: targetProductId,
        quantity: quantity,
      );
      if (response['status'] == true) {
        if (response['cart_id'] != null) {
          itemModel.cartId = response['cart_id'] is int
              ? response['cart_id']
              : int.tryParse(response['cart_id'].toString());
        }
        return true;
      } else {
        errorMessage = response['message']?.toString() ?? 'Failed to add item to cart';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  /// 3. Update Cart Quantity (Local & API)
  Future<bool> updateQuantity(ProductModel product, int newQuantity, {String? token}) async {
    final authToken = _getToken(token);
    final index =
        _items.indexWhere((item) => item.product.title == product.title);

    if (index != -1) {
      if (newQuantity <= 0) {
        return await removeFromCart(product, token: authToken);
      } else {
        _items[index].quantity = newQuantity;
        notifyListeners();

        final item = _items[index];
        final cartId = item.cartId;
        final productId = product.id;

        if (cartId != null && productId != null) {
          try {
            final response = await _cartService.updateCart(
              token: authToken,
              cartId: cartId,
              productId: productId,
              quantity: newQuantity,
            );
            return response['status'] == true;
          } catch (e) {
            errorMessage = e.toString();
            return false;
          }
        }
      }
    }
    return true;
  }

  /// 4. Remove From Cart (Local & API)
  Future<bool> removeFromCart(ProductModel product, {String? token}) async {
    final authToken = _getToken(token);
    final index =
        _items.indexWhere((item) => item.product.title == product.title);

    if (index != -1) {
      final item = _items[index];
      _items.removeAt(index);
      notifyListeners();

      if (item.cartId != null) {
        try {
          final response = await _cartService.removeFromCart(
            token: authToken,
            cartId: item.cartId!,
          );
          return response['status'] == true;
        } catch (e) {
          errorMessage = e.toString();
          return false;
        }
      }
    }
    return true;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
