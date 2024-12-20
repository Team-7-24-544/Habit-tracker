import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:fetch_client/fetch_client.dart';

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
  final mainUrl = 'http://127.0.0.1:8000';
  final client = FetchClient(mode: RequestMode.cors);
  final Map<String, String> defaultHeaders = {
    'Authorization': 'Bearer your_token',
    'Content-Type': 'application/json'
  };

  Uri _buildUri(String path, Map<String, dynamic> parameters) {
    return Uri.parse('$mainUrl$path').replace(queryParameters: parameters);
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {...defaultHeaders, ...?headers};
  }

  Future<ApiResponse> _sendRequest(String method, ApiQuery query) async {
    final uri = _buildUri(query.path, query.parameters);
    final headers = _mergeHeaders(query.headers);

    try {
      final response = http.Request(method, uri)..headers.addAll(headers);
      print(response);
      final streamedResponse = await response.send();
      final responseData = await http.Response.fromStream(streamedResponse);

      if (responseData.statusCode >= 200 && responseData.statusCode < 300) {
        return ApiResponse(
          body: json.decode(responseData.body) as Map<String, dynamic>,
        );
      } else {
        return ApiResponse(
          success: false,
          error:
              'Error: ${responseData.statusCode}, ${responseData.reasonPhrase}',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, error: 'Request failed: $e');
    }
  }

  Future<ApiResponse> get(ApiQuery query) => _sendRequest('GET', query);

  Future<ApiResponse> post(ApiQuery query) => _sendRequest('POST', query);

  Future<ApiResponse> update(ApiQuery query) => _sendRequest('PUT', query);

  Future<ApiResponse> delete(ApiQuery query) => _sendRequest('DELETE', query);
}

void check(ApiManager apiManager) async {
  const String yellow = '\x1B[33m';
  const String reset = '\x1B[0m';
  try {
    ApiQuery query =
        ApiQueryBuilder().path('/check_api').addParameter('id', 544).build();
    ApiResponse res = await apiManager.get(query);
    print('$yellow Api answer is ${!res.empty()} $reset');
  } catch (e) {
    print('$yellow Error $e $reset');
  }
}
