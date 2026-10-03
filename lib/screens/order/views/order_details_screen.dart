import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/models/order_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderController _orderController;

  @override
  void initState() {
    super.initState();
    _orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    _orderController.fetchOrderDetails(widget.orderId);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return successColor;
      case 'pending':
      case 'processing':
        return warningColor;
      case 'cancelled':
      case 'failed':
        return errorColor;
      default:
        return primaryColor;
    }
  }

  void _confirmCancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
        title: const Text(
          "Cancel Order?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          "Are you sure you want to cancel Order #${widget.orderId}?",
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Order"),
          ),
          Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _orderController.isCancellingOrder.value
                  ? null
                  : () async {
                      Navigator.pop(context);
                      final success =
                          await _orderController.cancelOrder(widget.orderId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? _orderController.successMessage.value
                                : _orderController.errorMessage.value,
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    },
              child: _orderController.isCancellingOrder.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Yes, Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          }),
        ],
      ),
    );
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
        title: Text(
          "Order #${widget.orderId}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (_orderController.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final OrderDetailData? details =
            _orderController.selectedOrderDetail.value;

        if (details == null) {
          return Center(
            child: Text(
              _orderController.errorMessage.value.isNotEmpty
                  ? _orderController.errorMessage.value
                  : "Order details not found",
              style: const TextStyle(color: greyColor),
            ),
          );
        }

        final statusColor = _getStatusColor(details.orderStatus);
        final canCancel = details.orderStatus.toLowerCase() == 'pending';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Order Status Header Card
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFECECF0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Status: ${details.orderStatus.toUpperCase()}",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (details.createdAt != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              "Placed on: ${details.createdAt}",
                              style: const TextStyle(
                                color: greyColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: defaultPadding),

              // 2. Shipping Address Card
              if (details.shippingAddress != null) ...[
                Text(
                  "Shipping Address",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFECECF0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        details.shippingAddress!.contactPersonName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${details.shippingAddress!.address}, ${details.shippingAddress!.city}, ${details.shippingAddress!.state} - ${details.shippingAddress!.zip}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: greyColor,
                        ),
                      ),
                      if (details.shippingAddress!.phone!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Phone: ${details.shippingAddress!.phone}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],

              // 3. Order Items Section
              Text(
                "Order Items (${details.items.length})",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: details.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = details.items[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      border: Border.all(
                        color:
                            isDark ? Colors.white12 : const Color(0xFFECECF0),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: isDark
                                ? const Color(0xFF262634)
                                : const Color(0xFFF6F6F9),
                            child: (item.thumbnail != null &&
                                    item.thumbnail!.isNotEmpty)
                                ? NetworkImageWithLoader(
                                    item.thumbnail!,
                                    radius: 8,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              if (item.variant != null &&
                                  item.variant!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  "Variant: ${item.variant}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                "Qty: ${item.qty} × \$${item.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: defaultPadding),

              // 4. Payment & Bill Summary Card
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFECECF0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRow(
                        "Payment Method",
                        details.paymentMethod
                            .replaceAll('_', ' ')
                            .toUpperCase()),
                    const SizedBox(height: 6),
                    _buildRow(
                        "Payment Status", details.paymentStatus.toUpperCase()),
                    const Divider(height: 20),
                    _buildRow("Order Amount", details.formattedOrderAmount),
                    if (details.discountAmount > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        "Discount",
                        "-\$${details.discountAmount.toStringAsFixed(2)}",
                        isGreen: true,
                      ),
                    ],
                    if (details.shippingCost > 0) ...[
                      const SizedBox(height: 6),
                      _buildRow(
                        "Shipping Cost",
                        "\$${details.shippingCost.toStringAsFixed(2)}",
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: defaultPadding * 1.5),

              // 5. Cancel Button if Order is Pending
              if (canCancel)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                    ),
                    onPressed: _confirmCancelOrder,
                    icon:
                        const Icon(Icons.cancel_outlined, color: Colors.white),
                    label: const Text(
                      "Cancel Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: defaultPadding),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: greyColor),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isGreen ? successColor : null,
          ),
        ),
      ],
    );
  }
}
