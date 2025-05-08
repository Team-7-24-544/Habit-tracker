import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/MetaInfo.dart';
import '../../models/habit.dart';
import '../../services/api_manager.dart';
import '../../services/api_query.dart';
import '../../services/logger.dart';
import '../../services/mark_habit_service.dart';
import 'habit_item.dart';

class HabitChecklist extends StatefulWidget {
  const HabitChecklist({super.key});

  @override
  State<HabitChecklist> createState() => _HabitChecklistState();
}

class _HabitChecklistState extends State<HabitChecklist> {
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadInitialHabits();
  }

  Future<void> _loadInitialHabits() async {
    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getTodayHabits).build();

    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);
    if (response.success) {
      final Map<String, dynamic> decoded = response.body;
      var now = DateTime.now();
      setState(() {
        _habits = [];

        for (var habitId in decoded.keys) {
          Map<String, dynamic> habit = {};
          try {
            habit = decoded[habitId];
          } catch (e) {
            showErrorToUser(context, 500, "Некорректный ответ сервера");
            logError(500, "Некорректный ответ сервера", response.body);
            continue;
          }
          if (!habit.containsKey('schedule')) continue;
          Map<String, dynamic> scheduleMap = habit['schedule'];
          if (!(scheduleMap.containsKey('uncompleted') &&
              scheduleMap.containsKey('completed') &&
              habit.containsKey('name') &&
              habit.containsKey('description'))) continue;

          Map<String, dynamic> uncompleted =
              jsonDecode(scheduleMap['uncompleted']);
          Map<String, dynamic> completed = jsonDecode(scheduleMap['completed']);

          if (completed.isNotEmpty) {
            for (var time in completed.keys) {
              var habitTimeStart = DateFormat('HH:mm').parse(time);
              var habitTimeEnd = DateFormat('HH:mm').parse(completed[time]);

              var habitDateTimeStart = DateTime(now.year, now.month, now.day,
                  habitTimeStart.hour, habitTimeStart.minute);
              var habitDateTimeEnd = DateTime(now.year, now.month, now.day,
                  habitTimeEnd.hour, habitTimeEnd.minute);

              _habits.add(Habit(
                id: habitId,
                name: habit['name'],
                description: habit['description'],
                isEnabled: now.isAfter(habitDateTimeStart) &&
                    now.isBefore(habitDateTimeEnd),
                start: time,
                end: completed[time],
                completed: true,
              ));
            }
          }

          if (uncompleted.isNotEmpty) {
            for (var time in uncompleted.keys) {
              var habitTimeStart = DateFormat('HH:mm').parse(time);
              var habitTimeEnd = DateFormat('HH:mm').parse(uncompleted[time]);

              var habitDateTimeStart = DateTime(now.year, now.month, now.day,
                  habitTimeStart.hour, habitTimeStart.minute);
              var habitDateTimeEnd = DateTime(now.year, now.month, now.day,
                  habitTimeEnd.hour, habitTimeEnd.minute);

              _habits.add(Habit(
                id: habitId,
                name: habit['name'],
                description: habit['description'],
                isEnabled: now.isAfter(habitDateTimeStart) &&
                    now.isBefore(habitDateTimeEnd),
                start: time,
                end: uncompleted[time],
                completed: false,
              ));
            }
          }
        }
        _habits.sort((a, b) => b.start.compareTo(a.start));
      });
    }
  }

  Future<bool> _toggleHabit(String habitId) async {
    final habitIndex = _habits.indexWhere((habit) => habit.id == habitId);
    if (habitIndex != -1) {
      var result = await markHabitAsCompleted(habitId);
      if (result) {
        setState(() {
          _habits[habitIndex] = _habits[habitIndex].copyWith(completed: true);
        });
      }
      return result;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> lst = [
      const Text(
        'Ежедневные привычки',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16)
    ];
    for (var habit in _habits) {
      lst.add(HabitItem(habit: habit, onToggle: _toggleHabit));
      lst.add(const SizedBox(height: 8));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lst,
    );
  }
}
