import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/address_model.dart';

class AddressService {
  final http.Client _client;

  AddressService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _getHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// 1. ADDRESS LIST
  /// Endpoint: api/v4/customer/address/list (GET)
  Future<Map<String, dynamic>> getAddressList({required String token}) async {
    final uri = Uri.parse('$baseUrl$addressListEndpoint');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final List list = data['data'];
        data['addresses'] = list.map((item) => AddressModel.fromJson(item)).toList();
      } else {
        data['addresses'] = <AddressModel>[];
      }
      return data;
    } catch (e) {
      debugPrint('AddressService getAddressList exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch addresses: ${e.toString()}',
        'addresses': <AddressModel>[],
      };
    }
  }

  /// 2. ADD ADDRESS
  /// Endpoint: api/v4/customer/address/add (POST)
  Future<Map<String, dynamic>> addAddress({
    required String token,
    required String contactPersonName,
    required String addressType,
    required String address,
    required String city,
    required String zip,
    required String country,
    required String phone,
  }) async {
    final uri = Uri.parse('$baseUrl$addAddressEndpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'contact_person_name': contactPersonName,
          'address_type': addressType,
          'address': address,
          'city': city,
          'zip': zip,
          'country': country,
          'phone': phone,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['address_model'] = AddressModel.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('AddressService addAddress exception: $e');
      return {
        'status': false,
        'message': 'Failed to add address: ${e.toString()}',
      };
    }
  }

  /// 3. GET ADDRESS DETAILS BY ID
  /// Endpoint: api/v4/customer/address/{id} (GET)
  Future<Map<String, dynamic>> getAddressById({
    required String token,
    required int id,
  }) async {
    final uri = Uri.parse('$baseUrl$addressDetailsEndpoint$id');
    try {
      final response = await _client.get(
        uri,
        headers: _getHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['address_model'] = AddressModel.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('AddressService getAddressById exception: $e');
      return {
        'status': false,
        'message': 'Failed to fetch address: ${e.toString()}',
      };
    }
  }

  /// 4. UPDATE ADDRESS
  /// Endpoint: api/v4/customer/address/update (PUT)
  Future<Map<String, dynamic>> updateAddress({
    required String token,
    required int id,
    required String contactPersonName,
    required String addressType,
    required String address,
    required String city,
    required String zip,
    required String country,
    required String phone,
  }) async {
    final uri = Uri.parse('$baseUrl$updateAddressEndpoint');
    try {
      final response = await _client.put(
        uri,
        headers: _getHeaders(token),
        body: jsonEncode({
          'id': id,
          'contact_person_name': contactPersonName,
          'address_type': addressType,
          'address': address,
          'city': city,
          'zip': zip,
          'country': country,
          'phone': phone,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        data['address_model'] = AddressModel.fromJson(data['data']);
      }
      return data;
    } catch (e) {
      debugPrint('AddressService updateAddress exception: $e');
      return {
        'status': false,
        'message': 'Failed to update address: ${e.toString()}',
      };
    }
  }

  /// 5. DELETE ADDRESS
  /// Endpoint: api/v4/customer/address/{id} (DELETE)
  Future<Map<String, dynamic>> deleteAddress({
    required String token,
    required int id,
  }) async {
    final uri = Uri.parse('$baseUrl$addressDetailsEndpoint$id');
    try {
      final response = await _client.delete(
        uri,
        headers: _getHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('AddressService deleteAddress exception: $e');
      return {
        'status': false,
        'message': 'Failed to delete address: ${e.toString()}',
      };
    }
  }
}
