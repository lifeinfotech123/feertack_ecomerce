import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/wishlist_model.dart';

class WishlistService {
  final http.Client _client;

  WishlistService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _getHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// 1. GET WISHLIST
  /// Endpoint: api/v4/customer/wishlist (GET)
  Future<Map<String, dynamic>> getWishlist({required String token}) async {
    final uri = Uri.parse('$baseUrl$wishlistEndpoint');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final List list = data['data'];
        data['wishlist'] =
            list.map((item) => WishlistItemModel.fromJson(item)).toList();
      } else {
        data['wishlist'] = <WishlistItemModel>[];
      }
      return data;
    } catch (e) {
      debugPrint('WishlistService getWishlist exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch wishlist: ${e.toString()}',
        'wishlist': <WishlistItemModel>[],
      };
    }
  }

  /// 2. ADD TO WISHLIST
  /// Endpoint: api/v4/customer/wishlist/add (POST)
  Future<Map<String, dynamic>> addToWishlist({
    required String token,
    required int productId,
  }) async {
    final uri = Uri.parse('$baseUrl$wishlistAddEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'product_id': productId,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('WishlistService addToWishlist exception: $e');
      return {
        'status': false,
        'message': 'Failed to add to wishlist: ${e.toString()}',
      };
    }
  }

  /// 3. REMOVE FROM WISHLIST
  /// Endpoint: api/v4/customer/wishlist/remove/{id} (DELETE)
  Future<Map<String, dynamic>> removeFromWishlist({
    required String token,
    required int productId,
  }) async {
    final uri = Uri.parse('$baseUrl$wishlistRemoveEndpoint$productId');
    try {
      final response = await _client.delete(
        uri,
        headers: _getHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('WishlistService removeFromWishlist exception: $e');
      return {
        'status': false,
        'message': 'Failed to remove from wishlist: ${e.toString()}',
      };
    }
  }

  /// 4. ADD TO CART API
  /// Endpoint: api/v4/customer/cart/add (POST)
  Future<Map<String, dynamic>> addToCart({
    required String token,
    required int productId,
  }) async {
    final uri = Uri.parse('$baseUrl$addToCartEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'product_id': productId,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('WishlistService addToCart exception: $e');
      return {
        'status': false,
        'message': 'Failed to add product to cart: ${e.toString()}',
      };
    }
  }
}
