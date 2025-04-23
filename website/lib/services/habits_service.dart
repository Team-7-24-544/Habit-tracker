import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import '../models/habit.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class HabitsService {
  static Future<List<Habit>> getUserHabits(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.getTodayHabits)
        .addParameter('user_id', userId.toString())
        .build();
    
    ApiResponse response = await apiManager.get(query);
    if (response.success) {
      final Map<String, dynamic> habitsData = response.body;
      List<Habit> habits = [];
      
      for (var habitId in habitsData.keys) {
        final habitData = habitsData[habitId];
        final schedule = habitData['schedule'];
        final uncompletedSchedule = json.decode(schedule['uncompleted'] as String) as Map<String, dynamic>;
        final completedSchedule = json.decode(schedule['completed'] as String) as Map<String, dynamic>;
        
        // Get the full weekly schedule
        final weeklySchedule = {
          'monday': json.decode(habitData['monday'] ?? '{}'),
          'tuesday': json.decode(habitData['tuesday'] ?? '{}'),
          'wednesday': json.decode(habitData['wednesday'] ?? '{}'),
          'thursday': json.decode(habitData['thursday'] ?? '{}'),
          'friday': json.decode(habitData['friday'] ?? '{}'),
          'saturday': json.decode(habitData['saturday'] ?? '{}'),
          'sunday': json.decode(habitData['sunday'] ?? '{}'),
        };
        
        // Format schedule for display
        List<String> scheduleStrings = [];
        weeklySchedule.forEach((day, times) {
          if (times is Map && times.isNotEmpty) {
            times.forEach((start, end) {
              scheduleStrings.add('$day: $start-$end');
            });
          }
        });
        
        // Calculate progress based on completed vs total tasks
        final totalTasks = uncompletedSchedule.length + completedSchedule.length;
        final progress = totalTasks > 0 ? completedSchedule.length / totalTasks : 0.0;
        
        habits.add(Habit(
          id: habitId,
          name: habitData['name'],
          description: habitData['description'],
          start: scheduleStrings.join('\n'),
          end: '', // We're using start for the full schedule now
          completed: completedSchedule.isNotEmpty,
          isEnabled: true,
          progress: progress,
          schedule: {
            'uncompleted': uncompletedSchedule.keys.toList(),
            'completed': completedSchedule.keys.toList(),
          },
        ));
      }
      
      return habits;
    }
    return [];
  }

  static Future<List<Habit>> getAllHabits(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.getAllHabits)
        .addParameter('user_id', userId.toString())
        .build();
    
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.containsKey('habits')) {
      final List<dynamic> habitsJson = response.body['habits'];
      return habitsJson.map((json) => Habit(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        start: '',
        end: '',
        completed: false,
        isEnabled: true,
        progress: 0.0,
        schedule: const {},
      )).toList();
    }
    return [];
  }

  static Future<Map<String, List<DateTime>>> getHabitPeriods(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.getHabitPeriods)
        .addParameter('user_id', userId.toString())
        .build();
    
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.containsKey('habit_periods')) {
      final periods = response.body['habit_periods'];
      final dateFormat = DateFormat('dd-MM-yyyy');
      
      return {
        'starts': (periods['starts'] as List).map((e) => dateFormat.parse(e)).toList(),
        'ends': (periods['ends'] as List).map((e) => dateFormat.parse(e)).toList(),
      };
    }
    return {'starts': [], 'ends': []};
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

  static Future<void> updateHabitSchedule(int userId, String habitId, Map<String, List<Map<String, String>>> schedule) async {
    final apiManager = MetaInfo.getApiManager();
    
    Map<String, Map<String, String>> timeTable = {};
    schedule.forEach((day, timeRanges) {
      Map<String, String> daySchedule = {};
      for (var range in timeRanges) {
        daySchedule[range['start']!] = range['end']!;
      }
      timeTable[day.toLowerCase()] = daySchedule;
    });

    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.updateHabitSchedule)
        .addParameter('user_id', userId.toString())
        .addParameter('habit_id', habitId)
        .addParameter('time_table', json.encode(timeTable))
        .build();
    
    await apiManager.post(query);
  }
}