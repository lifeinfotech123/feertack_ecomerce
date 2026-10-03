import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user_model.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final Map<String, String> _headers = const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// 1. CUSTOMER LOGIN
  /// Endpoint: api/v4/auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl$loginEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['user'] != null) {
        data['user_model'] = UserModel.fromJson(data['user']);
      }
      return data;
    } catch (e) {
      debugPrint('AuthService login exception: $e');
      return {
        'status': false,
        'message': 'Failed to log in: ${e.toString()}',
      };
    }
  }

  /// 2. REGISTER CUSTOMER
  /// Endpoint: api/v4/auth/register
  Future<Map<String, dynamic>> register({
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('$baseUrl$registerEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'f_name': fName,
          'l_name': lName,
          'email': email,
          'phone': phone,
          'password': password,
          'can_password': confirmPassword,
          'con_password': confirmPassword,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['user'] != null) {
        data['user_model'] = UserModel.fromJson(data['user']);
      }
      return data;
    } catch (e) {
      debugPrint('AuthService register exception: $e');
      return {
        'status': false,
        'message': 'Failed to register: ${e.toString()}',
      };
    }
  }

  /// 3. FORGOT PASSWORD
  /// Endpoint: api/v4/auth/forgot-password
  Future<Map<String, dynamic>> forgotPassword({
    required String identity,
  }) async {
    final uri = Uri.parse('$baseUrl$forgotPasswordEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'identity': identity,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('AuthService forgotPassword exception: $e');
      return {
        'status': false,
        'message': 'Failed to request OTP: ${e.toString()}',
      };
    }
  }

  /// 4. VERIFY OTP
  /// Endpoint: api/v4/auth/verify-otp
  Future<Map<String, dynamic>> verifyOtp({
    required String identity,
    required String otp,
  }) async {
    final uri = Uri.parse('$baseUrl$verifyOtpEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'email': identity,
          'identity': identity,
          'otp': otp,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('AuthService verifyOtp exception: $e');
      return {
        'status': false,
        'message': 'Failed to verify OTP: ${e.toString()}',
      };
    }
  }

  /// 5. RESET PASSWORD
  /// Endpoint: api/v4/auth/reset-password
  Future<Map<String, dynamic>> resetPassword({
    required String identity,
    required String otp,
    required String temporaryToken,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('$baseUrl$resetPasswordEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'identity': identity,
          'otp': otp,
          'temporary_token': temporaryToken,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('AuthService resetPassword exception: $e');
      return {
        'status': false,
        'message': 'Failed to reset password: ${e.toString()}',
      };
    }
  }
}
