import 'package:website/models/MetaInfo.dart';

import '../models/MetaKeys.dart';

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
    var userId = (MetaInfo.instance.get(MetaKeys.userId) ?? -1);
    var token = MetaInfo.instance.get(MetaKeys.token) ?? -1;
    if (userId > 0) _parameters['user_id'] = userId.toString();
    if (token != -1) _headers['Authorization'] = "Bearer $token";
    return ApiQuery(
      path: _path,
      parameters: _parameters,
      headers: _headers,
    );
  }
}

enum QueryPaths {
  userLogin("/user/login"),
  userRegister("/user/register"),
  userUpdate("/user/update"),
  getEmotions("/emotions/get_all_emoji"),
  setEmotion("/emotions/set_emoji"),
  getLastAchievements("/achievements/get_last"),
  createHabit("/habits/create"),
  getTemplateHabits("/habits/get_templates"),
  getSelectedTemplate("/get_selected_template"),
  getTodayHabits("/habits/get_today_habits"),
  setMarkToHabit("/habits/set_mark"),
  getHabitPeriods("/habits/get_periods"),
  getAllHabits("/habits/get_all_habits");

  final String value;

  const QueryPaths(this.value);
}
