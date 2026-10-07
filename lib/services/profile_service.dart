import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user_model.dart';

class ProfileService {
  final http.Client _client;

  ProfileService({http.Client? client}) : _client = client ?? http.Client();

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

  /// Fetch Customer Profile
  /// Endpoint: api/v4/auth/profile
  Future<Map<String, dynamic>> getProfile({required String token}) async {
    final uri = Uri.parse('$baseUrl$profileEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'token': token,
        }),
      );
      _logApi(uri: uri, method: 'POST', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['user_model'] = UserModel.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('ProfileService getProfile exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch profile: ${e.toString()}',
      };
    }
  }

  /// Update Customer Profile
  /// Endpoint: api/v4/customer/update-profile
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String fName,
    String? lName,
    required String phone,
  }) async {
    final uri = Uri.parse('$baseUrl$updateProfileEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'f_name': fName,
          'l_name': lName ?? '',
          'phone': phone,
          'token': token,
        }),
      );
      _logApi(uri: uri, method: 'POST', response: response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['user_model'] = UserModel.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('ProfileService updateProfile exception: $e');
      return {
        'status': false,
        'message': 'Failed to update profile: ${e.toString()}',
      };
    }
  }
}
