import 'address_model.dart';

class SummaryModel {
  final double subtotal;
  final double totalDiscount;
  final double totalTax;
  final double shippingCost;
  final double grandTotal;

  SummaryModel({
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTax,
    required this.shippingCost,
    required this.grandTotal,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      totalDiscount: (json['total_discount'] as num?)?.toDouble() ?? 0.0,
      totalTax: (json['total_tax'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CheckoutItemModel {
  final int cartId;
  final int productId;
  final String name;
  final String? thumbnail;
  final double unitPrice;
  final double discount;
  final double discountedPrice;
  final int quantity;
  final double itemTotal;

  CheckoutItemModel({
    required this.cartId,
    required this.productId,
    required this.name,
    this.thumbnail,
    required this.unitPrice,
    required this.discount,
    required this.discountedPrice,
    required this.quantity,
    required this.itemTotal,
  });

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemModel(
      cartId: json['cart_id'] is int
          ? json['cart_id']
          : int.tryParse(json['cart_id']?.toString() ?? '') ?? 0,
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discounted_price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      itemTotal: (json['item_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PaymentMethodModel {
  final String key;
  final String name;
  final bool enabled;
  final double? currentWalletBalance;

  PaymentMethodModel({
    required this.key,
    required this.name,
    required this.enabled,
    this.currentWalletBalance,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      key: json['key']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      enabled: json['enabled'] as bool? ?? false,
      currentWalletBalance:
          (json['current_wallet_balance'] as num?)?.toDouble(),
    );
  }
}

class CheckoutSummaryData {
  final SummaryModel summary;
  final List<CheckoutItemModel> items;
  final List<AddressModel> savedAddresses;
  final List<PaymentMethodModel> availablePaymentMethods;

  CheckoutSummaryData({
    required this.summary,
    required this.items,
    required this.savedAddresses,
    required this.availablePaymentMethods,
  });

  factory CheckoutSummaryData.fromJson(Map<String, dynamic> json) {
    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final itemsList = json['items'] as List? ?? [];
    final addressesList = json['saved_addresses'] as List? ?? [];
    final methodsList = json['available_payment_methods'] as List? ?? [];

    return CheckoutSummaryData(
      summary: SummaryModel.fromJson(summaryJson),
      items: itemsList
          .map((e) => CheckoutItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      savedAddresses: addressesList
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      availablePaymentMethods: methodsList
          .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderModel {
  final int id;
  final String? orderType;
  final double orderAmount;
  final String formattedOrderAmount;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMethod;
  final int itemsCount;
  final String? createdAt;

  OrderModel({
    required this.id,
    this.orderType,
    required this.orderAmount,
    required this.formattedOrderAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.itemsCount,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderType: json['order_type']?.toString(),
      orderAmount: (json['order_amount'] as num?)?.toDouble() ?? 0.0,
      formattedOrderAmount: json['formatted_order_amount']?.toString() ??
          "\$${json['order_amount']?.toString() ?? '0'}",
      orderStatus: json['order_status']?.toString() ?? 'pending',
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_on_delivery',
      itemsCount: json['items_count'] is int
          ? json['items_count']
          : int.tryParse(json['items_count']?.toString() ?? '') ?? 1,
      createdAt: json['created_at']?.toString(),
    );
  }
}

class OrderItemDetailModel {
  final int id;
  final int productId;
  final String productName;
  final String? thumbnail;
  final double price;
  final double discount;
  final double tax;
  final int qty;
  final String? variant;
  final Map<String, dynamic>? variation;
  final String deliveryStatus;
  final String paymentStatus;

  OrderItemDetailModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.thumbnail,
    required this.price,
    required this.discount,
    required this.tax,
    required this.qty,
    this.variant,
    this.variation,
    required this.deliveryStatus,
    required this.paymentStatus,
  });

  factory OrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderItemDetailModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id']?.toString() ?? '') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      qty: json['qty'] is int
          ? json['qty']
          : int.tryParse(json['qty']?.toString() ?? '') ?? 1,
      variant: json['variant']?.toString(),
      variation: json['variation'] is Map<String, dynamic>
          ? json['variation'] as Map<String, dynamic>
          : null,
      deliveryStatus: json['delivery_status']?.toString() ?? 'pending',
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
    );
  }
}

class OrderDetailData {
  final int id;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMethod;
  final double orderAmount;
  final double discountAmount;
  final double couponDiscount;
  final double shippingCost;
  final String formattedOrderAmount;
  final AddressModel? shippingAddress;
  final List<OrderItemDetailModel> items;
  final String? createdAt;

  OrderDetailData({
    required this.id,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderAmount,
    required this.discountAmount,
    required this.couponDiscount,
    required this.shippingCost,
    required this.formattedOrderAmount,
    this.shippingAddress,
    required this.items,
    this.createdAt,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return OrderDetailData(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderStatus: json['order_status']?.toString() ?? 'pending',
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_on_delivery',
      orderAmount: (json['order_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      formattedOrderAmount: json['formatted_order_amount']?.toString() ??
          "\$${json['order_amount']?.toString() ?? '0'}",
      shippingAddress: json['shipping_address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['shipping_address'])
          : null,
      items: itemsList
          .map((e) => OrderItemDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class PlaceOrderResultModel {
  final bool status;
  final String message;
  final int orderId;
  final List<int> orderIds;
  final String? orderGroupId;
  final double orderAmount;
  final String formattedAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;

  PlaceOrderResultModel({
    required this.status,
    required this.message,
    required this.orderId,
    required this.orderIds,
    this.orderGroupId,
    required this.orderAmount,
    required this.formattedAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
  });

  factory PlaceOrderResultModel.fromJson(Map<String, dynamic> json) {
    final idsList = json['order_ids'] as List? ?? [];
    return PlaceOrderResultModel(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      orderId: json['order_id'] is int
          ? json['order_id']
          : int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
      orderIds: idsList
          .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .toList(),
      orderGroupId: json['order_group_id']?.toString(),
      orderAmount: (json['order_amount'] as num?)?.toDouble() ?? 0.0,
      formattedAmount: json['formatted_amount']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_on_delivery',
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      orderStatus: json['order_status']?.toString() ?? 'pending',
    );
  }
}
