import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/mark_habit_service.dart';
import 'habit_item.dart';

class HabitChecklist extends StatefulWidget {
  const HabitChecklist({super.key});

  @override
  State<HabitChecklist> createState() => _HabitChecklistState();
}

class _HabitChecklistState extends State<HabitChecklist> {
  final HabitService _habitService = HabitService();
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadInitialHabits();
  }

  void _loadInitialHabits() {
    // В реальном приложении здесь будет загрузка из базы данных или API
    _habits = [
      Habit(
        id: '1',
        name: 'Утренняя медитация',
        description: '10 минут медитации после пробуждения',
      ),
      Habit(
        id: '2',
        name: 'Физические упражнения',
        description: '30 минут активности',
      ),
      Habit(
        id: '3',
        name: 'Чтение',
        description: '20 страниц книги',
      ),
    ];
    setState(() {});
  }

  void addNewHabit(Habit habit) {
    // Заглушка для добавления новой привычки
    setState(() {
      _habits.add(habit);
    });
  }

  Future<void> _toggleHabit(String habitId) async {
    final habitIndex = _habits.indexWhere((habit) => habit.id == habitId);
    if (habitIndex != -1) {
      final newCompleted = !_habits[habitIndex].completed;
      await _habitService.markHabitAsCompleted(habitId, newCompleted);
      setState(() {
        _habits[habitIndex] = _habits[habitIndex].copyWith(
          completed: newCompleted,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Ежедневные привычки',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        HabitItem(habit: _habits[0], onToggle: _toggleHabit),
        const SizedBox(height: 8),
        HabitItem(habit: _habits[1], onToggle: _toggleHabit),
        const SizedBox(height: 8),
        HabitItem(habit: _habits[2], onToggle: _toggleHabit),
        const SizedBox(height: 8),
      ],
    );
  }
}
