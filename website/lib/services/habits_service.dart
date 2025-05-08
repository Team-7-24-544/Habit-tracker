import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';

import '../models/habit.dart';

class HabitsService {
  static Future<List<SmallHabit>> getAllHabits(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getAllHabits).build();

    ApiResponse response = await apiManager.get(query);
    if (response.success) {
      final Map<String, dynamic> habitsData = response.body;
      List<SmallHabit> habits = [];

      for (var habitId in habitsData.keys) {
        final habitData = habitsData[habitId];

        habits.add(SmallHabit(
          id: habitId,
          name: habitData['name'],
          description: habitData['description'],
        ));
      }

      return habits;
    }
    return [];
  }

  static Future<LargeHabit> loadHabit(String habitId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.loadHabit)
        .addParameter('habit_id', habitId)
        .build();
    ApiResponse response = await apiManager.get(query);
    if (response.success) {
      Map<String, dynamic> decoded = response.body['schedule'];
      Map<String, Map<String, String>> schedule = decoded.map(
        (key, value) => MapEntry(
          key,
          Map<String, String>.from(value),
        ),
      );
      var habit = LargeHabit(
        id: response.body['id'].toString(),
        name: response.body['name'],
        description: response.body['description'],
        schedule: schedule,
        start: response.body['start'],
        pause: response.body['pause'],
        end: response.body['end'] ?? "-",
        missed: response.body['missed'],
        toggled: response.body['toggled'],
        streak: response.body['streak'],
      );
      return habit;
    }
    return LargeHabit(id: '-1');
  }
}
