import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/models/habit.dart';
import 'package:website/services/habits_service.dart';
import 'package:website/pages/habit_details_page.dart';
import 'habit_card.dart';

class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final userId = MetaInfo.instance.get(MetaKeys.userId);
    if (userId != null) {
      final habits = await HabitsService.getAllHabits(userId);
      if (mounted) {
        setState(() {
          _habits = habits;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleHabitStatus(String habitId, bool completed) async {
    final userId = MetaInfo.instance.get(MetaKeys.userId);
    if (userId != null) {
      await HabitsService.toggleHabitStatus(userId, habitId, completed);
      setState(() {
        final habitIndex = _habits.indexWhere((h) => h.id == habitId);
        if (habitIndex != -1) {
          _habits[habitIndex] = _habits[habitIndex].copyWith(completed: completed);
        }
      });
    }
  }

  void _openHabitDetails(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailsPage(habit: habit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.format_list_bulleted, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет привычек',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Нажмите "Добавить привычку" чтобы начать',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    List<HabitCard> lst = [];
    for (var habit in _habits) {
      lst.add(HabitCard(
        habit: habit,
        onTap: () => _openHabitDetails(context, habit),
        onStatusChanged: (completed) => _toggleHabitStatus(habit.id, completed),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lst,
    );
  }
}
