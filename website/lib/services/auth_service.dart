import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import 'package:website/services/utils_functions.dart';

class AuthService {
  static Future<int> validateCredentials(
      String username, String password, ApiManager apiManager) async {
    ApiQuery query = ApiQueryBuilder()
        .path('/login')
        .addParameter('password', hashPassword(password))
        .addParameter('login', username)
        .build();
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.keys.contains('id')) {
      return response.body['id'];
    }
    return -1;
  }
}
