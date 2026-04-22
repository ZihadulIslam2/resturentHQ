import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class ApiClient {
  static const String baseUrl = AppConfig.apiBaseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, String>> _headers({bool authenticated = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        developer.log('WARNING: No token found for authenticated request');
      }
    }
    return headers;
  }

  Future<dynamic> get(String path, {bool authenticated = false}) async {
    final url = '$baseUrl$path';
    _logRequest('GET', url, authenticated, null);

    final response = await http
        .get(
          Uri.parse(url),
          headers: await _headers(authenticated: authenticated),
        )
        .timeout(
          const Duration(seconds: AppConfig.requestTimeoutSeconds),
          onTimeout: () => throw Exception('Request timeout'),
        );
    return _decode(response, 'GET $path');
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final url = '$baseUrl$path';
    _logRequest('POST', url, authenticated, body);

    final response = await http
        .post(
          Uri.parse(url),
          headers: await _headers(authenticated: authenticated),
          body: jsonEncode(body ?? {}),
        )
        .timeout(
          const Duration(seconds: AppConfig.requestTimeoutSeconds),
          onTimeout: () => throw Exception('Request timeout'),
        );
    return _decode(response, 'POST $path');
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final url = '$baseUrl$path';
    _logRequest('PUT', url, authenticated, body);

    final response = await http
        .put(
          Uri.parse(url),
          headers: await _headers(authenticated: authenticated),
          body: jsonEncode(body ?? {}),
        )
        .timeout(
          const Duration(seconds: AppConfig.requestTimeoutSeconds),
          onTimeout: () => throw Exception('Request timeout'),
        );
    return _decode(response, 'PUT $path');
  }

  Future<dynamic> delete(String path, {bool authenticated = false}) async {
    final url = '$baseUrl$path';
    _logRequest('DELETE', url, authenticated, null);

    final response = await http
        .delete(
          Uri.parse(url),
          headers: await _headers(authenticated: authenticated),
        )
        .timeout(
          const Duration(seconds: AppConfig.requestTimeoutSeconds),
          onTimeout: () => throw Exception('Request timeout'),
        );
    return _decode(response, 'DELETE $path');
  }

  void _logRequest(String method, String url, bool authenticated,
      Map<String, dynamic>? body) {
    if (!AppConfig.enableApiLogging) return;

    developer.log(
      '$method $url\nAuthenticated: $authenticated${body != null ? '\nBody: ${jsonEncode(body)}' : ''}',
      name: 'ApiClient',
    );
  }

  dynamic _decode(http.Response response, String endpoint) {
    final body = response.body.isEmpty ? '{}' : response.body;

    if (AppConfig.enableApiLogging) {
      developer.log(
        'Status: ${response.statusCode}\nBody: $body',
        name: 'ApiClient Response - $endpoint',
      );
    }

    late dynamic data;
    try {
      data = jsonDecode(body);
    } catch (e) {
      developer.log('Failed to parse JSON response: $e',
          name: 'ApiClient Error');
      throw Exception('Invalid response format from server');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final errorMessage =
        data is Map ? (data['message'] ?? 'Request failed') : 'Request failed';
    developer.log('API Error: $errorMessage', name: 'ApiClient Error');
    throw Exception(errorMessage);
  }
}
