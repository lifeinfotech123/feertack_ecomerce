import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';

class OrderController extends GetxController implements GetxService {
  final OrderService _orderService = OrderService();

  // Checkout summary state
  final Rxn<CheckoutSummaryData> checkoutSummary = Rxn<CheckoutSummaryData>();
  final RxBool isSummaryLoading = false.obs;

  // Place order state
  final RxBool isPlacingOrder = false.obs;
  final Rxn<PlaceOrderResultModel> lastPlacedOrder =
      Rxn<PlaceOrderResultModel>();

  // Orders list state
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;
  final RxBool isOrdersLoading = false.obs;

  // Order details state
  final Rxn<OrderDetailData> selectedOrderDetail = Rxn<OrderDetailData>();
  final RxBool isDetailLoading = false.obs;

  // Cancelling order state
  final RxBool isCancellingOrder = false.obs;

  // Global messages
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  String _getToken([String? token]) {
    if (token != null && token.isNotEmpty) return token;
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().token.value;
    }
    return '';
  }

  /// 1. Fetch Checkout Summary
  Future<bool> fetchCheckoutSummary([String? token]) async {
    final authToken = _getToken(token);
    try {
      isSummaryLoading.value = true;
      errorMessage.value = '';

      final response = await _orderService.getCheckoutSummary(token: authToken);

      if (response['status'] == true && response['checkout_summary'] != null) {
        checkoutSummary.value =
            response['checkout_summary'] as CheckoutSummaryData;
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ??
            'Failed to load checkout summary';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSummaryLoading.value = false;
    }
  }

  /// 2. Place Order
  Future<bool> placeOrder({
    required int addressId,
    String? token,
  }) async {
    final authToken = _getToken(token);
    try {
      isPlacingOrder.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _orderService.placeOrder(
        token: authToken,
        addressId: addressId,
      );

      if (response['status'] == true &&
          response['place_order_result'] != null) {
        lastPlacedOrder.value =
            response['place_order_result'] as PlaceOrderResultModel;
        successMessage.value =
            response['message']?.toString() ?? 'Order placed successfully!';
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to place order';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isPlacingOrder.value = false;
    }
  }

  /// 3. Fetch Orders List
  Future<void> fetchOrdersList([String? token]) async {
    final authToken = _getToken(token);
    try {
      isOrdersLoading.value = true;
      errorMessage.value = '';

      final response = await _orderService.getOrderList(token: authToken);

      if (response['status'] == true && response['orders'] != null) {
        ordersList.assignAll(response['orders'] as List<OrderModel>);
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch orders';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isOrdersLoading.value = false;
    }
  }

  /// 4. Fetch Order Details
  Future<bool> fetchOrderDetails(int orderId, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isDetailLoading.value = true;
      errorMessage.value = '';

      final response = await _orderService.getOrderDetails(
        token: authToken,
        orderId: orderId,
      );

      if (response['status'] == true && response['order_detail'] != null) {
        selectedOrderDetail.value = response['order_detail'] as OrderDetailData;
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch order details';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// 5. Cancel Order
  Future<bool> cancelOrder(int orderId, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isCancellingOrder.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _orderService.cancelOrder(
        token: authToken,
        orderId: orderId,
      );

      if (response['status'] == true) {
        successMessage.value =
            response['message']?.toString() ?? 'Order cancelled successfully.';
        await fetchOrdersList(authToken);
        if (selectedOrderDetail.value?.id == orderId) {
          await fetchOrderDetails(orderId, authToken);
        }
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to cancel order';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isCancellingOrder.value = false;
    }
  }
}
