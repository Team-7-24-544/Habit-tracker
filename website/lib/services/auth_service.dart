import 'package:flutter/cupertino.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import 'package:website/services/utils_functions.dart';

import 'logger.dart';

class AuthService {
  static Future<int> validateCredentials(
      String username, String password, BuildContext context) async {
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.userLogin)
        .addParameter('password', hashPassword(password))
        .addParameter('login', username)
        .build();
    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);

    if (response.success) {
      if (response.body.keys.contains('id') &&
          response.body.keys.contains('token')) {
        if (response.body['id'] > 0) {
          MetaInfo.instance.set(MetaKeys.userId, response.body['id']);
          MetaInfo.instance.set(MetaKeys.token, response.body['token']);
        }
        return response.body['id'];
      }
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
    }
    return -2;
  }
}
