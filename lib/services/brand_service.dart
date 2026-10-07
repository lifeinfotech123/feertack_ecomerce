import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/brand_model.dart';

class BrandService {
  final http.Client _client;

  BrandService({http.Client? client}) : _client = client ?? http.Client();

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

  /// Fetch all brands
  Future<List<BrandModel>> getBrands() async {
    final uri = Uri.parse('$baseUrl$brandsEndpoint');
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List list = data['data'];
          return list.map((item) => BrandModel.fromJson(item)).toList();
        }
      } else {
        debugPrint('BrandService Error: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BrandService Exception: $e');
    }
    return [];
  }

  /// Fetch brand details (brand info, categories, products) by slug
  Future<BrandDetailModel?> getBrandDetails(String slug) async {
    final uri = Uri.parse('$baseUrl$brandsEndpoint/$slug');
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      _logApi(uri: uri, method: 'GET', response: response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BrandDetailModel.fromJson(data['data']);
        }
      } else {
        debugPrint(
            'BrandService getBrandDetails Error: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BrandService getBrandDetails Exception: $e');
    }
    return null;
  }
}
