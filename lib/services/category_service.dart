import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/category_model.dart';

class CategoryService {
  final http.Client _client;

  CategoryService({http.Client? client}) : _client = client ?? http.Client();

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

  /// Fetch all categories
  Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse('$baseUrl$categoriesEndpoint');
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
          return list.map((item) => CategoryModel.fromJson(item)).toList();
        }
      } else {
        debugPrint('CategoryService Error: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('CategoryService Exception: $e');
    }
    return [];
  }

  /// Fetch single category details including subcategories & sub-sub-categories by slug
  Future<CategoryModel?> getCategoryDetails(String slug) async {
    final uri = Uri.parse('$baseUrl$categoriesEndpoint/$slug');
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
          return CategoryModel.fromJson(data['data']);
        }
      } else {
        debugPrint(
            'CategoryService getCategoryDetails Error: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('CategoryService getCategoryDetails Exception: $e');
    }
    return null;
  }
}
