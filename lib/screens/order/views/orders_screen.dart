import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/models/order_model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrderController _orderController;

  @override
  void initState() {
    super.initState();
    _orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    _orderController.fetchOrdersList();
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
        title: Obx(() {
          final count = _orderController.ordersList.length;
          return Row(
            children: [
              Text(
                "MY ORDERS",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$count",
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
      body: Obx(() {
        if (_orderController.isOrdersLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_orderController.ordersList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 1.5),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  Text(
                    "No Orders Found",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You haven't placed any orders yet.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: greyColor,
                        ),
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white),
                    label: const Text(
                      "Start Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _orderController.fetchOrdersList(),
          child: ListView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: _orderController.ordersList.length,
            itemBuilder: (context, index) {
              final OrderModel order = _orderController.ordersList[index];
              final statusColor = _getStatusColor(order.orderStatus);

              return Card(
                margin: const EdgeInsets.only(bottom: defaultPadding),
                elevation: 0,
                color: cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  side: BorderSide(
                    color: isDark ? Colors.white12 : const Color(0xFFECECF0),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => OrderDetailsScreen(orderId: order.id));
                  },
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Order ID & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order #${order.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.orderStatus.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (order.createdAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.createdAt!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: greyColor,
                            ),
                          ),
                        ],

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1),
                        ),

                        // Body: Items & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${order.itemsCount} ${order.itemsCount == 1 ? 'Item' : 'Items'}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: greyColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Payment: ${order.paymentMethod.replaceAll('_', ' ').toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              order.formattedOrderAmount,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Action link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "View Details",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
