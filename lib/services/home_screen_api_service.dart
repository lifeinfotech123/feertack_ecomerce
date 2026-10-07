import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/brand_model.dart';
import '../models/home_screen_models.dart';

class HomeScreenApiService {
  final http.Client _client;

  HomeScreenApiService({http.Client? client})
      : _client = client ?? http.Client();

  final Map<String, String> _headers = const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

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

  /// Fetch Featured / Popular Products
  Future<List<ApiProductModel>> getFeaturedProducts() async {
    final uri = Uri.parse('$baseUrl$featuredProductsEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => ApiProductModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getFeaturedProducts Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getFeaturedProducts Exception: $e');
    }
    return [];
  }

  /// Fetch Top Brands
  Future<List<BrandModel>> getTopBrands() async {
    final uri = Uri.parse('$baseUrl$topBrandsEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => BrandModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getTopBrands Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getTopBrands Exception: $e');
    }
    return [];
  }

  /// Fetch Flash Deals
  Future<List<FlashDealModel>> getFlashDeals() async {
    final uri = Uri.parse('$baseUrl$flashDealsEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => FlashDealModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getFlashDeals Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getFlashDeals Exception: $e');
    }
    return [];
  }

  /// Fetch Top Sellers
  Future<List<TopSellerModel>> getTopSellers() async {
    final uri = Uri.parse('$baseUrl$topSellersEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => TopSellerModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getTopSellers Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getTopSellers Exception: $e');
    }
    return [];
  }

  /// Fetch Most Popular Products
  Future<List<ApiProductModel>> getMostPopularProducts() async {
    final uri = Uri.parse('$baseUrl$mostPopularProductsEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => ApiProductModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getMostPopularProducts Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getMostPopularProducts Exception: $e');
    }
    return [];
  }

  /// Fetch New Arrival Products
  Future<List<ApiProductModel>> getNewArrivalsProducts() async {
    final uri = Uri.parse('$baseUrl$newArrivalsProductsEndpoint');
    try {
      final response = await _client.get(uri, headers: _headers);
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => ApiProductModel.fromJson(item)).toList();
        }
      } else {
        debugPrint(
            'HomeScreenApiService getNewArrivalsProducts Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('HomeScreenApiService getNewArrivalsProducts Exception: $e');
    }
    return [];
  }
}
