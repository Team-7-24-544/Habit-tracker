import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'package:website/services/api_query.dart';

import '../../../models/MetaInfo.dart';
import '../../../services/api_manager.dart';
import 'logger.dart';

Future<Tuple2<List, List>> loadHabitPeriods(
    int userId, BuildContext context) async {
  ApiQuery query = ApiQueryBuilder().path(QueryPaths.getHabitPeriods).build();

  final apiManager = MetaInfo.getApiManager();
  ApiResponse response = await apiManager.get(query);

  handleApiError(response: response, context: context);
  if (response.success) {
    final Map<String, dynamic> decoded = response.body;

    List<String> startDates =
        List<String>.from(decoded['habit_periods']['starts']);
    List<String> endDates = List<String>.from(decoded['habit_periods']['ends']);

    return Tuple2(startDates, endDates);
  } else {
    return Tuple2([], []);
  }
}
