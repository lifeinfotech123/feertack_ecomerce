import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';

class ThanksForOrderScreen extends StatelessWidget {
  const ThanksForOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? darkGreyColor : whiteColor;
    final bodyBg = isDark ? const Color(0xFF121218) : const Color(0xFFF6F6F9);

    final args = (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>?) ??
        {};

    final String paymentMethod = args["paymentMethod"] ?? "UPI Payment";
    final double amount = (args["amount"] as num?)?.toDouble() ?? 0.0;
    final double savings = (args["savings"] as num?)?.toDouble() ?? 0.0;
    final int itemsCount = (args["itemsCount"] as int?) ?? 1;

    final randomOrderId =
        "ORD-${10000 + Random().nextInt(90000)}";

    return Scaffold(
      backgroundColor: bodyBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding * 1.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Celebration Badge
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),

                Text(
                  "Order Placed! 🎉",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Your order has been confirmed and is being prepared.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : blackColor60,
                  ),
                ),

                const SizedBox(height: defaultPadding * 1.5),

                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Order ID Row
                      _buildReceiptRow("Order ID", "#$randomOrderId",
                          isDark: isDark),
                      const Divider(height: 20),

                      // Delivery Estimate
                      _buildReceiptRow(
                        "Estimated Delivery",
                        "⚡ 10 - 15 Mins",
                        isHighlight: true,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      // Items Purchased
                      _buildReceiptRow(
                        "Items Purchased",
                        "$itemsCount Items",
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      // Payment Method
                      _buildReceiptRow(
                        "Payment Method",
                        paymentMethod,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),

                      // Total Paid
                      _buildReceiptRow(
                        "Total Paid",
                        "\$${amount.toStringAsFixed(2)}",
                        isDark: isDark,
                        isBold: true,
                      ),

                      if (savings > 0) ...[
                        const Divider(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: successColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.savings_rounded,
                                  color: successColor, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "Total Savings: \$${savings.toStringAsFixed(2)}! 🥳",
                                style: const TextStyle(
                                  color: successColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: defaultPadding * 2),

                // Track Order Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ordersScreenRoute,
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadious),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "TRACK ORDER STATUS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Continue Shopping Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(
                      color: primaryColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadious),
                    ),
                  ),
                  child: const Text(
                    "CONTINUE SHOPPING",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isHighlight = false,
    bool isBold = false,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? Colors.white60 : greyColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            color: isHighlight
                ? const Color(0xFF2962FF)
                : (isBold
                    ? primaryColor
                    : (isDark ? Colors.white : blackColor)),
          ),
        ),
      ],
    );
  }
}
