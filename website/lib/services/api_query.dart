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

  ApiQueryBuilder path(QueryPaths path) {
    _path = path.value;
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

enum QueryPaths {
  checkApi("/check_api"),
  login("/login"),
  register("/register"),
  getEmotions("/emotions/get_all"),
  setEmotion("/emotions/set"),
  createHabit("/habits/create"),
  getTemplateHabits("/habits/get_templates"),
  getSelectedTemplate("/get_selected_template"),
  getLastAchievements("/achievements/get_last"),
  getProfile("/user/profile"),
  updateProfile("/user/profile/update");

  final String value;

  const QueryPaths(this.value);
}
