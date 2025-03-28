import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import '../models/habit.dart';

class HabitsService {
  static Future<List<Habit>> getUserHabits(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.getTodayHabits)
        .addParameter('user_id', userId.toString())
        .build();
    
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.containsKey('habits')) {
      final List<dynamic> habitsJson = response.body['habits'];
      return habitsJson.map((json) => Habit(
        id: json['id'].toString(),
        name: json['name'],
        description: json['description'],
        start: json['start'],
        end: json['end'],
        completed: json['completed'] ?? false,
        isEnabled: json['is_enabled'] ?? false,
      )).toList();
    }
    return [];
  }

  static Future<void> toggleHabitStatus(int userId, String habitId, bool completed) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.setMarkToHabit)
        .addParameter('user_id', userId.toString())
        .addParameter('habit_id', habitId)
        .addParameter('completed', completed.toString())
        .build();
    
    await apiManager.post(query);
  }
}