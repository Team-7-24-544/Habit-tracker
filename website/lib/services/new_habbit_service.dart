import 'package:flutter/material.dart';
import '../models/habit_settings.dart';
import 'api_manager.dart';
import 'api_query.dart';

class HabitService {
  static Future<bool> saveNewHabit(
    HabitSettings settings,
    ApiManager apiManager,
  ) async {
    final timeString = '${settings.timeOfDay.hour}:${settings.timeOfDay.minute}';
    final weekDaysString = settings.weekDays.map((day) => day ? '1' : '0').join(',');

    ApiQuery query = ApiQueryBuilder()
        .path('/habits/create')
        .addParameter('name', settings.name)
        .addParameter('description', settings.description)
        .addParameter('time', timeString)
        .addParameter('weekDays', weekDaysString)
        .addParameter('duration', settings.durationInDays.toString())
        //.addParameter('repetitions', settings.repetitionsPerDay.toString())
        .build();

    ApiResponse response = await apiManager.post(query);
    return response.success;
  }
}
