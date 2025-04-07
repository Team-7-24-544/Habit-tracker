import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import 'package:website/services/utils_functions.dart';

class AuthService {
  static Future<int> validateCredentials(String username, String password) async {
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.login)
        .addParameter('password', hashPassword(password))
        .addParameter('login', username)
        .build();
    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.keys.contains('id')) {
      if (response.body['id'] > 0) {
        MetaInfo.instance.set(MetaKeys.userId, response.body['id']);
        MetaInfo.instance.set(MetaKeys.token, response.body['token']);
      }
      return response.body['id'];
    }
    return -2;
  }
}
