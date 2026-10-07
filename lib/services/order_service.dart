import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/order_model.dart';

class OrderService {
  final http.Client _client;

  OrderService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _getHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  void _logApi(
      {required Uri uri,
      required String method,
      required http.Response response}) {
    debugPrint('================ API REQUEST ================');
    debugPrint('Method: $method');
    debugPrint('URL: $uri');
    debugPrint('Response Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    debugPrint('=============================================');
  }

  /// 1. GET CHECKOUT SUMMARY
  /// Endpoint: api/v4/customer/orders/place (GET)
  Future<Map<String, dynamic>> getCheckoutSummary(
      {required String token}) async {
    final uri = Uri.parse('$baseUrl$checkoutSummaryEndpoint');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );
      _logApi(uri: uri, method: 'GET', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        data['checkout_summary'] = CheckoutSummaryData.fromJson(data);
      }
      return data;
    } catch (e) {
      debugPrint('OrderService getCheckoutSummary exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch checkout summary: ${e.toString()}',
      };
    }
  }

  /// 2. PLACE ORDER
  /// Endpoint: api/v4/customer/orders/place (POST)
  Future<Map<String, dynamic>> placeOrder({
    required String token,
    required int addressId,
  }) async {
    final uri = Uri.parse('$baseUrl$placeOrderEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'address_id': addressId,
        }),
      );
      _logApi(uri: uri, method: 'POST', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        data['place_order_result'] = PlaceOrderResultModel.fromJson(data);
      }
      return data;
    } catch (e) {
      debugPrint('OrderService placeOrder exception: $e');
      return {
        'status': false,
        'message': 'Failed to place order: ${e.toString()}',
      };
    }
  }

  /// 3. GET ORDER LIST
  /// Endpoint: api/v4/customer/orders (GET)
  Future<Map<String, dynamic>> getOrderList({required String token}) async {
    final uri = Uri.parse('$baseUrl$orderListEndpoint');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );
      _logApi(uri: uri, method: 'GET', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final List list = data['data'];
        data['orders'] = list.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        data['orders'] = <OrderModel>[];
      }
      return data;
    } catch (e) {
      debugPrint('OrderService getOrderList exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch orders: ${e.toString()}',
        'orders': <OrderModel>[],
      };
    }
  }

  /// 4. GET ORDER DETAILS
  /// Endpoint: api/v4/customer/orders/{id} (GET)
  Future<Map<String, dynamic>> getOrderDetails({
    required String token,
    required int orderId,
  }) async {
    final uri = Uri.parse('$baseUrl$orderDetailsEndpoint$orderId');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );
      _logApi(uri: uri, method: 'GET', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['order_detail'] = OrderDetailData.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('OrderService getOrderDetails exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch order details: ${e.toString()}',
      };
    }
  }

  /// 5. CANCEL ORDER
  /// Endpoint: api/v4/customer/order/cancel (POST)
  Future<Map<String, dynamic>> cancelOrder({
    required String token,
    required int orderId,
  }) async {
    final uri = Uri.parse('$baseUrl$orderCancelEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'order_id': orderId,
        }),
      );
      _logApi(uri: uri, method: 'POST', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('OrderService cancelOrder exception: $e');
      return {
        'status': false,
        'message': 'Failed to cancel order: ${e.toString()}',
      };
    }
  }
}
