import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/models/habit.dart';
import 'package:website/pages/habit_details_page.dart';
import 'package:website/services/habits_service.dart';

import 'habit_card.dart';

class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<SmallHabit> _habits = [];
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

  Future<void> _openHabitDetails(
      BuildContext context, SmallHabit smallHabit) async {
    var habit = await HabitsService.loadHabit(smallHabit.id);
    if (habit.id == '-1') return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailPage(habit: habit),
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
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lst,
    );
  }
}
