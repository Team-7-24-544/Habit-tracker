import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:fetch_client/fetch_client.dart';

class ApiResponse {
  final bool status;
  final String error;
  final Map<String, dynamic> body;

  ApiResponse(
      {this.status = true, this.error = "Ok", Map<String, dynamic>? body})
      : body = body ?? {"content": null};

  bool empty() {
    return !status;
  }
}

class ApiQuery {
  final String query;
  final Map<String, dynamic> parameters;

  ApiQuery({required this.query, required this.parameters});
}

class ApiManager {
  final mainUrl = '127.0.0.1:8000';
  final client = FetchClient(mode: RequestMode.cors);

  Future<ApiResponse> get(ApiQuery query) async {
    final uri = Uri.http(mainUrl, query.query, query.parameters);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return ApiResponse(
            body: utf8.decode(response.bodyBytes) as Map<String, dynamic>);
      }
      return ApiResponse(
          status: false, error: "Response error: ${response.statusCode}");
    } catch (e) {
      return ApiResponse(status: false, error: "Response error: $e");
    }
  }

  Future<ApiResponse> post(ApiQuery query, Map<String, dynamic> data, {String? token}) async {
    final uri = Uri.http(mainUrl, query.query, query.parameters);
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
      final response = await client.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(status: false, error: "POST Error: $e");
    }
  }

  Future<ApiResponse> put(ApiQuery query, Map<String, dynamic> data, {String? token}) async {
    final uri = Uri.http(mainUrl, query.query, query.parameters);
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
      final response = await client.put(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(status: false, error: "PUT Error: $e");
    }
  }

  Future<ApiResponse> delete(ApiQuery query, {String? token}) async {
    final uri = Uri.http(mainUrl, query.query, query.parameters);
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
      final response = await client.delete(
        uri,
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(status: false, error: "DELETE Error: $e");
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decodedBody = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse(body: decodedBody);
      } catch (e) {
        return ApiResponse(
            status: false, error: "JSON Decode Error: ${e.toString()}");
      }
    } else {
      return ApiResponse(
          status: false,
          error:
              "Response error: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }

}

void check(ApiManager apiManager) async {
  const String yellow = '\x1B[33m';
  const String reset = '\x1B[0m';
  try {
    ApiResponse res = await apiManager.get(ApiQuery(
        query: '/check_api', parameters: {"id": "544", "type": "status"}));
    print('$yellow Api answer is ${!res.empty()} $reset');
  } catch (e) {
    print('$yellow Api answer is Error $e $reset');
  }
}