import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_query.dart';

class ApiResponse {
  final bool success;
  final String error;
  final Map<String, dynamic> body;

  ApiResponse(
      {this.success = true, this.error = "Ok", Map<String, dynamic>? body})
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
    final uri = _buildUri(query, method);
    final headers = _mergeHeaders(query);
    http.Response response;
    try {
      if (method.toUpperCase() == 'GET') {
        response = await http.get(uri, headers: headers);
      } else if (method.toUpperCase() == 'POST') {
        response = await http.post(uri,
            headers: headers, body: jsonEncode(query.parameters));
      } else if (method.toUpperCase() == 'PUT') {
        response = await http.put(uri,
            headers: headers, body: jsonEncode(query.parameters));
      } else if (method.toUpperCase() == 'DELETE') {
        response = await http.delete(uri, headers: headers);
      } else {
        return ApiResponse(
            success: false, error: 'Unsupported HTTP method: $method');
      }
    } catch (e) {
      return ApiResponse(success: false, error: "SendRequestError: $e");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        body: json.decode(response.body) as Map<String, dynamic>,
      );
    } else if (response.statusCode == 403) {
      return ApiResponse(
        success: false,
        error: 'Error: ${response.statusCode}, Token is invalid',
      );
    } else {
      return ApiResponse(
        success: false,
        error: 'Error: ${response.statusCode}, ${response.reasonPhrase}',
      );
    }
  }

  Future<ApiResponse> get(ApiQuery query) => _sendRequest('GET', query);

  Future<ApiResponse> post(ApiQuery query) => _sendRequest('POST', query);

  Future<ApiResponse> update(ApiQuery query) => _sendRequest('PUT', query);

  Future<ApiResponse> delete(ApiQuery query) => _sendRequest('DELETE', query);
}
