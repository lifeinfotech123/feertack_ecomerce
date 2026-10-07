import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/banner_model.dart';

class BannerService {
  final http.Client _client;

  BannerService({http.Client? client}) : _client = client ?? http.Client();

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

  /// Fetch banners by banner_type (e.g., 'main-banner', 'footer-banner')
  Future<List<BannerModel>> getBanners(
      {String bannerType = 'main-banner'}) async {
    final uri = Uri.parse('$baseUrl$bannersEndpoint/$bannerType');
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
          return list.map((item) => BannerModel.fromJson(item)).toList();
        }
      } else {
        debugPrint('BannerService Error: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BannerService Exception: $e');
    }
    return [];
  }
}
