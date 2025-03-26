import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/services/api_manager.dart';

import 'api_query.dart';

Future<void> markHabitAsCompleted(String habitId) async {
  final apiManager = MetaInfo.getApiManager();
  final userId = MetaInfo.instance.get(MetaKeys.userId);
  ApiQuery query = ApiQueryBuilder()
      .path(QueryPaths.setMarkToHabit)
      .addParameter('user_id', userId.toString())
      .addParameter('habit_id', habitId)
      .build();

  ApiResponse response = await apiManager.post(query);
}
