import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class CartService {
  final http.Client _client;

  CartService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _getHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// 1. ADD TO CART
  /// URL: http://127.0.0.1:8000/api/v4/customer/cart/add
  /// Method: POST
  Future<Map<String, dynamic>> addToCart({
    required String token,
    required int productId,
    int quantity = 1,
  }) async {
    final uri = Uri.parse('$baseUrl$addToCartEndpoint');
    final Map<String, dynamic> bodyParams = {
      'product_id': productId,
      if (quantity > 1) 'quantity': quantity,
    };
    final String requestBody = jsonEncode(bodyParams);

    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: requestBody,
      );

      final String logMessage = '''
                                                    ADD TO CART 
url:$uri 
Method: POST
Parameter: 
Product_id:  $productId
Token : $token
Response:
${response.body}
''';
      print(logMessage);
      debugPrint(logMessage);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      final errorMsg = 'CartService addToCart exception: $e';
      print(errorMsg);
      debugPrint(errorMsg);
      return {
        'status': false,
        'message': 'Failed to add product to cart: ${e.toString()}',
      };
    }
  }

  /// 2. UPDATE CART
  /// URL: http://127.0.0.1:8000/api/v4/customer/cart/update
  /// Method: POST
  Future<Map<String, dynamic>> updateCart({
    required String token,
    required int cartId,
    required int productId,
    required int quantity,
  }) async {
    final uri = Uri.parse('$baseUrl$updateCartEndpoint');
    final Map<String, dynamic> bodyParams = {
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
    };
    final String requestBody = jsonEncode(bodyParams);

    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: requestBody,
      );

      final String logMessage = '''
                                           UPDATE CART
url:$uri  
Method: POST
Parameter: 
Cart_id: $cartId
Product_id: $productId
Quantity: $quantity
Token : $token
Response:
${response.body}
''';
      print(logMessage);
      debugPrint(logMessage);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      final errorMsg = 'CartService updateCart exception: $e';
      print(errorMsg);
      debugPrint(errorMsg);
      return {
        'status': false,
        'message': 'Failed to update cart: ${e.toString()}',
      };
    }
  }

  /// 3. CART LIST
  /// URL: http://127.0.0.1:8000/api/v4/customer/cart
  /// Method: GET
  Future<Map<String, dynamic>> getCartList({
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl$cartListEndpoint');

    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );

      final String logMessage = '''
                                        CART LIST
url:$uri  
Method: GET
Parameter: 
Token : $token
Response:
${response.body}
''';
      print(logMessage);
      debugPrint(logMessage);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      final errorMsg = 'CartService getCartList exception: $e';
      print(errorMsg);
      debugPrint(errorMsg);
      return {
        'status': false,
        'message': 'Failed to fetch cart: ${e.toString()}',
      };
    }
  }

  /// 4. REMOVE ITEM FROM CART
  /// Url: http://127.0.0.1:8000/api/v4/customer/cart/remove/{cart_id}
  /// Method: DELETE
  Future<Map<String, dynamic>> removeFromCart({
    required String token,
    required int cartId,
  }) async {
    final uri = Uri.parse('$baseUrl$removeCartItemEndpoint$cartId');

    try {
      final response = await _client.delete(
        uri,
        headers: _getHeaders(token),
      );

      final String logMessage = '''
                                               REMOVE ITEM FORM CART 
 Url:$uri  
Method: DELETE
Parameter: 
cart_id:  $cartId
Token : $token
Response:
${response.body}
''';
      print(logMessage);
      debugPrint(logMessage);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      final errorMsg = 'CartService removeFromCart exception: $e';
      print(errorMsg);
      debugPrint(errorMsg);
      return {
        'status': false,
        'message': 'Failed to remove item from cart: ${e.toString()}',
      };
    }
  }
}
