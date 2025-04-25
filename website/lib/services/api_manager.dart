import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_query.dart';

class ApiResponse {
  final bool success;
  final int statusCode;
  final String? error;
  final Map<String, dynamic> body;

  ApiResponse(
      {this.success = true,
      this.error,
      Map<String, dynamic>? body,
      this.statusCode = 200})
      : body = body ?? {"content": null};

  bool empty() {
    return !success;
  }
}

class ApiManager {
  final mainUrl = 'https://127.0.0.1:5000';
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json'
  };

  Uri _buildUri(ApiQuery query, String method) {
    if (method == 'GET' || method == 'DELETE') {
      return Uri.parse('$mainUrl${query.path}')
          .replace(queryParameters: query.parameters);
    }
    return Uri.parse('$mainUrl${query.path}');
  }

  Map<String, String> _mergeHeaders(ApiQuery query) {
    if (!query.headers.containsKey('authorization')) {
      defaultHeaders['authorization'] = 'Bearer - 1';
    }
    return {...defaultHeaders, ...query.headers};
  }

  Future<ApiResponse> _sendRequest(String method, ApiQuery query) async {
    final Duration timeoutDuration = Duration(seconds: 5);
    final uri = _buildUri(query, method);
    final headers = _mergeHeaders(query);
    http.Response response;
    try {
      if (method.toUpperCase() == 'GET') {
        response =
            await http.get(uri, headers: headers).timeout(timeoutDuration);
      } else if (method.toUpperCase() == 'POST') {
        response = await http
            .post(uri, headers: headers, body: jsonEncode(query.parameters))
            .timeout(timeoutDuration);
      } else if (method.toUpperCase() == 'PUT') {
        response = await http
            .put(uri, headers: headers, body: jsonEncode(query.parameters))
            .timeout(timeoutDuration);
      } else if (method.toUpperCase() == 'DELETE') {
        response =
            await http.delete(uri, headers: headers).timeout(timeoutDuration);
      } else {
        return ApiResponse(
            statusCode: 405,
            success: false,
            error: 'Упс... Что-то пошло не так :(',
            body: {"message": 'Unsupported HTTP method: $method'});
      }
    } on TimeoutException {
      return ApiResponse(
        statusCode: 408, // HTTP 408 Request Timeout
        success: false,
        error: 'Превышено время ожидания ответа от сервера',
        body: {"message": 'Request timed out after $timeoutDuration'},
      );
    } on SocketException {
      return ApiResponse(
        statusCode: 503, // HTTP 503 Service Unavailable
        success: false,
        error: 'Сервер недоступен',
        body: {"message": 'No internet connection or server is down'},
      );
    } catch (e) {
      return ApiResponse(
          statusCode: 400,
          success: false,
          error: 'Упс... Что-то пошло не так :(',
          body: {"message": '$e'});
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        body: json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          body: json.decode(response.body));
    }
  }

  Future<ApiResponse> get(ApiQuery query) => _sendRequest('GET', query);

  Future<ApiResponse> post(ApiQuery query) => _sendRequest('POST', query);

  Future<ApiResponse> update(ApiQuery query) => _sendRequest('PUT', query);

  Future<ApiResponse> delete(ApiQuery query) => _sendRequest('DELETE', query);
}
