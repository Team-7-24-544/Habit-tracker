import 'package:tuple/tuple.dart';
import 'package:website/services/api_query.dart';

import '../../../models/MetaInfo.dart';
import '../../../services/api_manager.dart';

Future<Tuple2<List, List>> loadHabitPeriods(int userId) async {
  ApiQuery query =
      ApiQueryBuilder().path(QueryPaths.getHabitPeriods).addParameter('user_id', userId.toString()).build();

  final apiManager = MetaInfo.getApiManager();
  ApiResponse response = await apiManager.get(query);

  if (response.success) {
    final Map<String, dynamic> decoded = response.body;

    List<String> startDates = List<String>.from(decoded['habit_periods']['starts']);
    List<String> endDates = List<String>.from(decoded['habit_periods']['ends']);

    return Tuple2(startDates, endDates);
  } else {
    return Tuple2([], []);
  }
}
