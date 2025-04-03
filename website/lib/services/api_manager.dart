import 'dart:convert';

import 'api_query.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool success;
  final String error;
  final Map<String, dynamic> body;

  ApiResponse({this.success = true, this.error = "Ok", Map<String, dynamic>? body}) : body = body ?? {"content": null};

  bool empty() {
    return !success;
  }
}

class ApiManager {
  final mainUrl = 'https://127.0.0.1:5000';
  final Map<String, String> defaultHeaders = {'Authorization': 'Bearer token', 'Content-Type': 'application/json'};

  Uri _buildUri(ApiQuery query) {
    return Uri.parse('$mainUrl${query.path}');
  }

  Map<String, String> _mergeHeaders(ApiQuery query) {
    return {...defaultHeaders, ...query.headers};
  }

  Future<ApiResponse> _sendRequest(String method, ApiQuery query) async {
    final uri = _buildUri(query);
    final headers = _mergeHeaders(query);
    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri.replace(queryParameters: query.parameters), headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(query.parameters));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(query.parameters));
          break;
        case 'DELETE':
          response = await http.delete(uri.replace(queryParameters: query.parameters), headers: headers);
          break;
        default:
          return ApiResponse(success: false, error: 'Unsupported HTTP method: $method');
      }
    } catch (e) {
      return ApiResponse(success: false, error: "SendRequestError: $e");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        body: json.decode(response.body) as Map<String, dynamic>,
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
