class ApiQuery {
  final String path;
  final Map<String, dynamic> parameters;
  final Map<String, String> headers;

  ApiQuery({
    required this.path,
    this.parameters = const {},
    this.headers = const {},
  });
}

class ApiQueryBuilder {
  String _path = '';
  final Map<String, dynamic> _parameters = {};
  final Map<String, String> _headers = {};

  ApiQueryBuilder path(String path) {
    _path = path;
    return this;
  }

  ApiQueryBuilder addParameter(String key, dynamic value) {
    _parameters[key] = value;
    return this;
  }

  ApiQueryBuilder addParameters(Map<String, dynamic> params) {
    _parameters.addAll(params);
    return this;
  }

  ApiQueryBuilder addHeader(String key, String value) {
    _headers[key] = value;
    return this;
  }

  ApiQueryBuilder addHeaders(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  ApiQuery build() {
    return ApiQuery(
      path: _path,
      parameters: _parameters,
      headers: _headers,
    );
  }
}
