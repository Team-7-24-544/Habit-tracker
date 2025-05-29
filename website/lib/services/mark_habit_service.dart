import 'package:website/models/MetaInfo.dart';

import 'api_query.dart';

Future<bool> markHabitAsCompleted(String habitId) async {
  final apiManager = MetaInfo.getApiManager();
  ApiQuery query = ApiQueryBuilder()
      .path(QueryPaths.setMarkToHabit)
      .addParameter('habit_id', habitId)
      .build();

  var response = await apiManager.post(query);
  if (!response.success || !response.body.containsKey('answer')) return false;
  return response.body['answer'] == "success";
}
