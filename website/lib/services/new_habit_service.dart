import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import '../models/habit_settings.dart';
import 'api_manager.dart';
import 'api_query.dart';

class HabitService {
  static Future<bool> saveNewHabit(HabitSettings settings) async {
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.createHabit)
        .addParameter('name', settings.name)
        .addParameter('description', settings.description)
        .addParameter('time_table', settings.timeTable)
        .build();

    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.post(query);
    return response.success;
  }
}
