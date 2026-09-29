import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/models/coupon_model.dart';
import 'package:shop/screens/coupon/views/components/coupon_card.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final TextEditingController _codeController = TextEditingController();
  final CartController _cart = CartController.instance;
  String? _customCodeError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyCustomCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _customCodeError = "Please enter a coupon code";
      });
      return;
    }

    final error = _cart.applyCouponByCode(code);
    if (error != null) {
      setState(() {
        _customCodeError = error;
      });
    } else {
      setState(() {
        _customCodeError = null;
      });
      _codeController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Coupon ${code.toUpperCase()} applied successfully!",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _applyCoupon(CouponModel coupon) {
    final error = _cart.applyCoupon(coupon);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: warningColor,
          behavior: SnackBarBehavior.floating,
          content: Text(
            error,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Coupon ${coupon.code} applied! You saved \$${_cart.discountAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? darkGreyColor : whiteColor;
    final bodyBg = isDark ? const Color(0xFF121218) : const Color(0xFFF6F6F9);

    return Scaffold(
      backgroundColor: bodyBg,
      appBar: AppBar(
        backgroundColor: bodyBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Apply Coupon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: AnimatedBuilder(
        animation: _cart,
        builder: (context, _) {
          final currentSubtotal = _cart.subtotal;
          final appliedCoupon = _cart.appliedCoupon;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Enter Promo Code Input Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Coupon.svg",
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Have a Promo Code?",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _codeController,
                              textCapitalization: TextCapitalization.characters,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                hintText: "ENTER CODE (e.g. WELCOME50)",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white38 : greyColor,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF262634)
                                    : const Color(0xFFF6F6F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: _customCodeError,
                              ),
                              onChanged: (_) {
                                if (_customCodeError != null) {
                                  setState(() {
                                    _customCodeError = null;
                                  });
                                }
                              },
                              onSubmitted: (_) => _applyCustomCode(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _applyCustomCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "APPLY",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: defaultPadding),

                // 2. Active Savings Banner if coupon applied
                if (appliedCoupon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      border: Border.all(
                        color: successColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.celebration_rounded,
                          color: successColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Applied: ${appliedCoupon.code}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: successColor,
                                ),
                              ),
                              Text(
                                appliedCoupon.isFreeDelivery
                                    ? "Free delivery unlocked on this order!"
                                    : "You are saving \$${_cart.discountAmount.toStringAsFixed(2)} with this coupon!",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.white70 : blackColor60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _cart.removeCoupon();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Remove",
                            style: TextStyle(
                              color: errorColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],

                // 3. Available Coupons Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available Coupons (${demoCoupons.length})",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Cart: \$${currentSubtotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. List of Coupon Cards
                ...demoCoupons.map((coupon) {
                  final isApplied = appliedCoupon?.code == coupon.code;
                  return CouponCard(
                    coupon: coupon,
                    currentSubtotal: currentSubtotal,
                    isApplied: isApplied,
                    onApply: () => _applyCoupon(coupon),
                    onRemove: () => _cart.removeCoupon(),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
